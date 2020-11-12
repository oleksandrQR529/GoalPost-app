//
//  UIResponderExt.swift
//  goalPost-app
//
//  Created by Саша on 04.10.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit
import UserNotifications

extension UIResponder: UNUserNotificationCenterDelegate {
    
    // MARK: - Date processing block
    
    func fetchStringDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let stringDate = "\(dateFormatter.string(from: date)) - \(timeFormatter.string(from: date))"
        
        return stringDate
    }
    
    func stripSecondsFromDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let str = dateFormatter.string(from: date as Date)
        let newDate = dateFormatter.date(from: str)!

        return newDate
    }
    
    // MARK: - Notifications
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All permission set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.content.categoryIdentifier == "goalPost-notification" {
            UIApplication.shared.applicationIconBadgeNumber = 0
            NotificationCenter.default.post(name: NSNotification.Name("goalPost-notification"), object: nil, userInfo: ["notificationUuid" : response.notification.request.identifier])
        }
    
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if notification.request.content.categoryIdentifier == "goalPost-notification" {
            UIApplication.shared.applicationIconBadgeNumber = 0
            NotificationCenter.default.post(name: NSNotification.Name("goalPost-notification"), object: nil, userInfo: ["notificationUuid" : notification.request.identifier])
        }else{
            NotificationCenter.default.post(name: NSNotification.Name("preGoalReminder-notification"), object: nil, userInfo: ["notificationUuid" : notification.request.identifier])
        }

        completionHandler([.alert, .sound, .badge])
    }
    
}
