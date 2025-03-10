import AppKit

// You can extend the notification management to a separate file if needed
extension Timer {
	func sendRichNotification(title: String, body: String) {
		let notification = NSUserNotification()
		notification.title = title
		notification.informativeText = body
		notification.soundName = NSUserNotificationDefaultSoundName

		// Add any additional notification customization here

		NSUserNotificationCenter.default.deliver(notification)
	}
}
