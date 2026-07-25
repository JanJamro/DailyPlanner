//
//  UserNotificationsManager.swift
//  DailyPlanner
//
//  Created by Jan on 25/07/2026.
//

import UserNotifications

class UserNotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = UserNotificationsManager()
    let center = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        center.delegate = self
    }
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Allowed")
            }
        }
    }
    
    func createNotificationsForEvent(_ event: Event) {
        if event.dateStart! > Date() {
            let content = UNMutableNotificationContent()
            var eventIn = "now"
            content.body = event.eventDescription ?? ""
            content.sound = .default
            content.title = "Daily planner - \(event.eventType?.eventTypeName ?? "") event \(eventIn)"
            let date = event.dateStart
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date!), repeats: false)
            let request = UNNotificationRequest(identifier: "\(event.id!)_eventStart", content: content, trigger: trigger)
            center.add(request)
            print("Added notification for event start")
            if event.dateStart!.timeIntervalSinceNow > 3600 {
                eventIn = "in 1 hour"
                content.title = "Daily planner - \(event.eventType?.eventTypeName ?? "") event \(eventIn)"
                let date = Calendar.current.date(byAdding: .hour, value: -1, to: event.dateStart!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date!), repeats: false)
                let request = UNNotificationRequest(identifier: "\(event.id!)_1hour", content: content, trigger: trigger)
                center.add(request)
                print("Added notification for hour before")
            }
            else {
                return
            }
            if event.dateStart!.timeIntervalSinceNow > 86400 {
                eventIn = "now"
                content.title = "Daily planner - \(event.eventType?.eventTypeName ?? "") event \(eventIn)"
                let date = Calendar.current.date(byAdding: .day, value: -1, to: event.dateStart!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date!), repeats: false)
                let request = UNNotificationRequest(identifier: "\(event.id!)_24hours", content: content, trigger: trigger)
                center.add(request)
                print("Added notification for day before")
            }
        }
    }
    
    func deleteNotificationForEvent(_ event: Event) {
        center.removePendingNotificationRequests(withIdentifiers: ["\(event.id!)_eventStart", "\(event.id!)_1hour", "\(event.id!)_24hours"])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
