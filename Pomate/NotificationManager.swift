import AppKit
import UserNotifications

extension Timer {
    func sendRichNotification(title: String, body: String) {
        // Request authorization to send notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                // Create the notification content
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default

                // Create the notification request
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

                // Add the notification request to the notification center
                center.add(request) { error in
                    if let error = error {
                        print("Error adding notification: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
}
