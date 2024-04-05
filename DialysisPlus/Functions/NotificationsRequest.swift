//
//  NotificationsRequest.swift
//  DialysisPlus
//
//  Created by Meghs on 03/03/24.
//

import Foundation
import UserNotifications

func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification authorization granted")
            } else if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }

