//
//  NotificationManager.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func scheduleNotification(for dateString: String, team1: String, team2: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Error: Could not parse date from string.")
            return
        }

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(team1) vs \(team2)"
        notificationContent.body = "Starts in 30mins"

        let triggerDate = date.addingTimeInterval(-30 * 60) // 30 minutes before the date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate), repeats: false)

        let request = UNNotificationRequest(identifier: "NotificationIdentifier", content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}
