//
//  NotificationHandler.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 12/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit
import CleanroomLogger

enum NotificationCategory: String {
    case askForMakesFun = "com.fittschen.machtSpass.askForMakesFun"
    case answeredMakesFun = "com.fittschen.machtSpass.answeredMakesFun"
}

//MARK: Protocol declaration

protocol VersionSpecificNotificationHandler {
    
    func handleActionWithIdentifier(identifier: String?,
                                    for userInfo: [AnyHashable : Any]?,
                                    completionHandler: @escaping () -> Swift.Void)
    
    func hasUserBeenAskedAboutPushNotifications(hasBeenAsked: @escaping (Bool) -> ())
    
    func requestNotificationPermissionsWithCompletion(permissionsGranted: @escaping (Bool) -> ())
    
    func arePermissionsGranted(permissionsGranted: @escaping (Bool) -> ())
    
    func successfullyRegisteredForNotifications(deviceToken: Data)
    
    func failedToRegisterForNotifications(error: Error)
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)
}

//MARK: Default implementation

//In the default implementaton, handle things which are the same across multiple
extension VersionSpecificNotificationHandler {
    
    func handleActionWithIdentifier(identifier: String?,
                                    for userInfo: [AnyHashable : Any]?,
                                    completionHandler: @escaping () -> Swift.Void) {
        
        guard let actionIdentifier = identifier,
              let action = MachtSpassAction(rawValue: actionIdentifier),
              let machtSpassInfo = userInfo,
              let machtSpass = MachtSpass(userInfo: machtSpassInfo) else {
                //Nothing to do here except call completion and bail.
                completionHandler()
                return
        }
        
        action.perform(with: machtSpass)
        completionHandler()
    }
    
    func successfullyRegisteredForNotifications(deviceToken: Data) {
        let pushToken = String(format: "%@", deviceToken as CVarArg)
        let pushTokenString = pushToken.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
        
        UserDefaults.standard.setValue(pushTokenString, forKey: "PushDeviceToken")
        
        AzureClient.shared.client.push?.registerDeviceToken(deviceToken) { error in
            if let error = error {
                Log.error?.message("Error registering for push notifications with error: \(error)")
            } else {
                Log.debug?.message("Registered for push notifications with token: \(pushTokenString)")
            }
        }
    }
    
    func failedToRegisterForNotifications(error: Error) {
        Log.error?.message("Error registering for notifications \(error)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        guard let machtSpass = MachtSpass(userInfo: userInfo) else {
            completionHandler(.noData)
            return
        }
        
    }
}
