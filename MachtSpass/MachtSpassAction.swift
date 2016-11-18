//
//  MachtSpassAction.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 12/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UserNotifications
import CleanroomLogger

//  Adapted from: https://github.com/designatednerd/iOS10NotificationSample

enum MachtSpassAction: String {
    case machtSpass = "com.fittschen.machtSpass"
    case machtKeinenSpass = "com.fittschen.machtKeinenSpass"
    case showAnswer = "com.fittschen.showAnswer"
    
    func perform(with machtSpass: MachtSpass) {
        switch self {
        case .machtSpass:
            Log.debug?.message("TODO: Handle 'machtSpass' choice")
        case .machtKeinenSpass:
            Log.debug?.message("TODO: Handle 'machtKeinenSpass' choice")
        case .showAnswer:
            Log.debug?.message("TODO: Handle 'showAnswer' choice")
        }
    }
    
    static func configureNotificationActions() {
        let machtSpassAction = UNNotificationAction(identifier: MachtSpassAction.machtSpass.rawValue,
                                               title: "Macht Spaß!! 🎉")
        
        let machtKeinenSpassAction = UNNotificationAction(identifier: MachtSpassAction.machtKeinenSpass.rawValue,
                                             title: "Macht keinen Spaß.. 😞")
        
        let showAnswerAction = UNNotificationAction(identifier: MachtSpassAction.showAnswer.rawValue,
                                                   title: "Antwort anzeigen")
        
        let askForMakesFunCategory = UNNotificationCategory(identifier: NotificationCategory.askForMakesFun.rawValue,
                                                            actions: [machtSpassAction, machtKeinenSpassAction],
                                                            intentIdentifiers: [])
        let answeredMakesFunCategory = UNNotificationCategory(identifier: NotificationCategory.answeredMakesFun.rawValue,
                                                              actions: [showAnswerAction],
                                                              intentIdentifiers: [])
        
        UNUserNotificationCenter
            .current()
            .setNotificationCategories([askForMakesFunCategory, answeredMakesFunCategory])
    }
}
