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
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
			granted, error in
			if granted {
				print("Notification permission granted")
			} else if let error = error {
				print("Notification permission error: \(error.localizedDescription)")
			}
		}
        
        // Set up notification categories and actions if needed
        configureNotifications()
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
                .animation(ThemeManager.animationCurve(for: settings.colorTheme), value: settings.colorTheme)
		} label: {
			// Status bar icon and/or text
			StatusBarView(pomodoroTimer: pomodoroTimer)
				.environmentObject(themeEnvironment)
                .animation(ThemeManager.animationCurve(for: themeEnvironment.currentTheme), value: pomodoroTimer.state)
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
			// For custom themes, use a base color scheme that works best with the theme
			return theme == .tomato ? .light : .dark
		}
	}
    
    // Configure notification categories and actions
    private func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        
        // Create a "Start Next Session" action
        let startNextAction = UNNotificationAction(
            identifier: "START_NEXT",
            title: "Start Next Session",
            options: .foreground
        )
        
        // Create a "Take Longer Break" action
        let extendBreakAction = UNNotificationAction(
            identifier: "EXTEND_BREAK",
            title: "Extend Break (+5 min)",
            options: .foreground
        )
        
        // Create categories for different notification types
        let workDoneCategory = UNNotificationCategory(
            identifier: "WORK_DONE",
            actions: [startNextAction],
            intentIdentifiers: [],
            options: []
        )
        
        let breakDoneCategory = UNNotificationCategory(
            identifier: "BREAK_DONE",
            actions: [startNextAction, extendBreakAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Register the notification categories
        center.setNotificationCategories([workDoneCategory, breakDoneCategory])
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
    
    // Add a method to get the appropriate color for the current timer state
    func colorForState(_ state: PomodoroTimer.TimerState) -> Color {
        switch state {
        case .idle:
            return .primary
        case .workSession:
            return ThemeManager.workSessionColor(for: currentTheme)
        case .shortBreak:
            return ThemeManager.shortBreakColor(for: currentTheme)
        case .longBreak:
            return ThemeManager.longBreakColor(for: currentTheme)
        }
    }
}
