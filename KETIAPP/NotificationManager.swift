//
//  NotificationManager.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/31.
//

import Foundation
import UserNotifications

class NotificationManager {
    private static let shared = NotificationManager()
    public static func sharedNotificationManager() -> NotificationManager {
        return NotificationManager()
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // Method that access authorization to send to users
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
        
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("NotificationAuthorizationError = \(error)")
                self.requestNotificationAuthorization()
            } else {
                if success {
                    print("Notification access allowed")
                } else {
                    print("Notification access denied")
                    self.requestNotificationAuthorization()
                }
            }
        }
    }
    
    // Send notifications if earthquake occured
    func setEarthquakeNotification() {
        print("Send notification to user for open application")
        
        let notificaitonContent = UNMutableNotificationContent()
        notificaitonContent.title = "지진이 발생하였습니다!"
        notificaitonContent.body = "앱을 열어 행동요령을 확인해주세요!"
        notificaitonContent.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "appTerminateNotification", content: notificaitonContent, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

