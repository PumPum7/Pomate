import SwiftUI
import UserNotifications

@main
struct PomateApp: App {
	@StateObject private var settings = PomateSettings()
	@StateObject private var pomodoroTimer: PomodoroTimer
	@StateObject private var themeEnvironment = ThemeEnvironment()
	@Environment(\.colorScheme) var colorScheme

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
				.preferredColorScheme(colorSchemeForTheme(settings.colorTheme))
				.environmentObject(themeEnvironment)
				.onAppear {
					// Apply theme when the app appears
					themeEnvironment.currentTheme = settings.colorTheme
					settings.applyTheme()
				}
		} label: {
			// Status bar icon and/or text
			StatusBarView(pomodoroTimer: pomodoroTimer)
				.environmentObject(themeEnvironment)
		}
		.menuBarExtraStyle(.window)
	}

	// Helper method to determine preferred color scheme based on theme
	private func colorSchemeForTheme(_ theme: PomateSettings.ColorTheme) -> ColorScheme? {
		switch theme {
		case .system:
			return nil  // Let system decide
		case .light:
			return .light
		case .dark:
			return .dark
		case .tomato, .ocean, .forest:
			// For custom themes we could use either light or dark as base
			// Here we'll return nil to use system preference
			return nil
		}
	}
}

// Theme environment class to propagate theme changes
class ThemeEnvironment: ObservableObject {
	@Published var currentTheme: PomateSettings.ColorTheme = .system

	init() {
		// Listen for theme changes
		NotificationCenter.default.addObserver(
			forName: Notification.Name("ThemeChanged"),
			object: nil,
			queue: .main
		) { [weak self] notification in
			if let theme = notification.object as? PomateSettings.ColorTheme {
				self?.currentTheme = theme
			}
		}
	}
}
