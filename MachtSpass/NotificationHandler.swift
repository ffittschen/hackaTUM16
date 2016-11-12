//
//  NotificationHandler.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 12/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationHandler: NSObject {
    
    override init() {
        super.init()
        //Set this object as the delegate to the user notification center
        UNUserNotificationCenter.current().delegate = self
        
        //Set up actions
        MachtSpassAction.configureNotificationActions()
    }
}

extension NotificationHandler: UNUserNotificationCenterDelegate {
    
    // This gets called when a notification comes in while you're in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        //Modify the notification as you wish, then call the completion handler.
        completionHandler(.alert)
    }
    
    
    // Called when the user selects an action or dismisses a notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        self.handleActionWithIdentifier(identifier: response.actionIdentifier,
                                        for: userInfo,
                                        completionHandler: completionHandler)
    }
}

//MARK: - VersionSpecificNotificationHandler conformance
extension NotificationHandler: VersionSpecificNotificationHandler {
    
    private func getAuthStatus(status: @escaping (UNAuthorizationStatus) -> ()) {
        UNUserNotificationCenter
            .current()
            .getNotificationSettings {
                settings in
                status(settings.authorizationStatus)
        }
    }
    
    func hasUserBeenAskedAboutPushNotifications(hasBeenAsked: @escaping (Bool) -> ()) {
        self.getAuthStatus() {
            status in
            
            DispatchQueue.main.async {
                switch status {
                case .notDetermined: //Not asked yet
                    hasBeenAsked(false)
                case .denied, //Asked and denied
                .authorized: //Asked and accepted
                    hasBeenAsked(true)
                }
            }
        }
    }
    
    func requestNotificationPermissionsWithCompletion(permissionsGranted: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) {
                granted, error in
                
                DispatchQueue.main.async {
                    if granted {
                        permissionsGranted(true)
                    } else {
                        print("Error or nil: \(error?.localizedDescription ?? "nil")")
                        permissionsGranted(false)
                    }
                }
        }
    }
    
    func arePermissionsGranted(permissionsGranted: @escaping (Bool) -> ()) {
        self.getAuthStatus() {
            status in
            
            DispatchQueue.main.async {
                switch status {
                case .notDetermined,
                     .denied:
                    permissionsGranted(false)
                case .authorized:
                    permissionsGranted(true)
                }
            }
        }
    }
    
    func scheduleNotification(for machtSpass: MachtSpass, delay: TimeInterval) {
        let resourceName = machtSpass.machtSpass ? R.image.party.name : R.image.thumbDown.name
        
        guard let imageURL = Bundle.main.url(forResource: resourceName, withExtension: "png"),
              let attachment = try? UNNotificationAttachment(identifier: resourceName,
                                                           url: imageURL,
                                                           options: .none) else {
                                                            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Macht \(machtSpass.productName) Spaß?"
        content.subtitle = "Was meinst du?"
        content.body = "Du kannst auswählen, ob \(machtSpass.productName) Spaß macht oder keinen Spaß macht und dadurch anderen helfen."
        content.attachments = [attachment]
        
        
        //Note: For a remote notification to invoke your Notification Content extension, you'd need to add this same category identifier as the value for the category key in the payload dictionary.
        content.categoryIdentifier = NotificationCategory.askForMakesFun
        
        //Set up a time-based trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        //Set up the request based on the trigger.
        let request = UNNotificationRequest(identifier: parrot.gif.rawValue,
                                            content: content,
                                            trigger: trigger)
        
        //Schedule the notification
        UNUserNotificationCenter.current().add(request) {
            error in
            if let error = error {
                debugPrint("Error scheduling notification: \(error)")
            } else {
                debugPrint("Notification added!")
            }
        }
    }
}
