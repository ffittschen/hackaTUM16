//
//  AppDelegate.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import UIKit
import UserNotifications
import CleanroomLogger
import MicrosoftAzureMobile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var rootViewController: UITabBarController?
    private var coordinator: AppCoordinator?
    private var notificationHandler: VersionSpecificNotificationHandler?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //  Enable debug logging
        Log.enable(debugMode: true)
        
        //  initialize first views 
        rootViewController = UITabBarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        
        //  initialize the app coordinator (See Coordinator Redux: http://khanlou.com/2015/10/coordinators-redux/)
        coordinator = AppCoordinator(tabBarController: rootViewController!)
        coordinator?.start()
        
        window?.makeKeyAndVisible()
        
        notificationHandler = NotificationHandler()
        UIApplication.shared.registerForRemoteNotifications()
        
        // Clear application badge when launching the app
        application.applicationIconBadgeNumber = 0
        
        // Style UINavigationBar
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor(hex: "#df0000")
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(hex: "#df0000")]
        
        return true
    }
    
    //MARK: - registering for push notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationHandler?.successfullyRegisteredForNotifications(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        notificationHandler?.failedToRegisterForNotifications(error: error)
    }
    
    //MARK: - Background notification handling
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        notificationHandler?.application(application,
                                         didReceiveRemoteNotification: userInfo,
                                         fetchCompletionHandler: completionHandler)
    }

}
