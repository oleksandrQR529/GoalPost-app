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
    
    func fetchStringDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let stringDate = "\(dateFormatter.string(from: date)) - \(timeFormatter.string(from: date))"
        
        return stringDate
    }
    
    // MARK: - Notifications
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func initNotification(goal: Goal) {
        
        if goal.reminderIsActivated {
        }else {
            let content = UNMutableNotificationContent()
            content.title = goal.goalDescription ?? "What is your goal?"
            content.subtitle = fetchStringDate(date: goal.goalReminderDate!)
            content.sound = UNNotificationSound.default
            content.badge = 1
            content.categoryIdentifier = "goalPost-notification"

            let uuid = goal.goalNotificationUuid!
            
            // show this notification at selected date
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: goal.goalReminderDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
            goal.reminderIsActivated = true
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did receive called")
        
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present called")

        completionHandler([.alert, .sound, .badge])
    }
    
}
