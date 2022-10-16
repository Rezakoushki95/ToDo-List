//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Reza Koushki on 16/10/2022.
//

import Foundation
import UserNotifications

struct LocalNotificationManager {
	
	static func autherizeLocalNotifications() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			guard error == nil else {
				print("ERROR \(error!.localizedDescription)")
				return
			}
			
			if granted {
				print("Notification Authorization Granted")
			} else {
				print("The User Denied Notifications")
				//TODO: Put an alert here to tell the user what to do
			}
		}
	}
	
	static func setCalendarNotification(title: String, subtitle: String, body: String, bagdeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
		// Create Content
		let content = UNMutableNotificationContent()
		content.title = title
		content.subtitle = subtitle
		content.body = body
		content.badge = bagdeNumber
		content.sound = sound
		
		// Create Trigger -> When is this notification going off?
		var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
		dateComponents.second = 00
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		
		// Create Request
		let notificationID = UUID().uuidString
		let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
		
		// Register request with the notification center
		UNUserNotificationCenter.current().add(request) { error in
			if let error = error {
				print("ERROR \(error.localizedDescription) YIKES, adding notifcation request went wrong.")
			} else {
				print("Notification Scheduled \(notificationID), title: \(content.title)")
			}
		}
		
		return notificationID
	}
	
	
}


