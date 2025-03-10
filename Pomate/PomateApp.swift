import SwiftUI
import UserNotifications

@main
struct PomateApp: App {
	@StateObject private var settings = PomateSettings()
	@StateObject private var pomodoroTimer: PomodoroTimer

	init() {
		// Create settings first, then use them to configure the timer
		let settingsObject = PomateSettings()
		_settings = StateObject(wrappedValue: settingsObject)
		_pomodoroTimer = StateObject(wrappedValue: PomodoroTimer(settings: settingsObject))

		// Request notification permission
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
			granted, error in
			if granted {
				print("Notification permission granted")
			} else if let error = error {
				print("Notification permission error: \(error.localizedDescription)")
			}
		}
	}

	var body: some Scene {
		MenuBarExtra {
			// Menu that appears when clicking on the status bar item
			PomodoroMenu(pomodoroTimer: pomodoroTimer, settings: settings)
		} label: {
			// Status bar icon and/or text
			StatusBarView(pomodoroTimer: pomodoroTimer)
		}
		.menuBarExtraStyle(.window)
	}
}
