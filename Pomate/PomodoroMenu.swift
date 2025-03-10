import SwiftUI

struct PomodoroMenu: View {
	@ObservedObject var pomodoroTimer: PomodoroTimer
	@ObservedObject var settings: PomateSettings
	@State private var selectedTab = 0
	@EnvironmentObject var themeEnvironment: ThemeEnvironment

	var body: some View {
		VStack(spacing: 0) {
			// Tab selection - adjusted padding to make tabs visible
			Picker("", selection: $selectedTab) {
				Label("Timer", systemImage: "timer")
					.tag(0)
				Label("Stats", systemImage: "chart.bar.fill")
					.tag(1)
				Label("Settings", systemImage: "gear")
					.tag(2)
			}
			.pickerStyle(SegmentedPickerStyle())
			.padding(.horizontal)
			.padding(.top, 16)  // Increased top padding to make tabs more visible
			.padding(.bottom, 12)
			.accentColor(ThemeManager.primaryColor(for: themeEnvironment.currentTheme))

			// Content based on selected tab
			if selectedTab == 0 {
				TimerTabView(pomodoroTimer: pomodoroTimer)
			} else if selectedTab == 1 {
				StatisticsTabView(settings: settings)
			} else {
				SettingsTabView(settings: settings)
			}

			Divider()
				.padding(.top, 8)

			Button(action: {
				NSApplication.shared.terminate(nil)
			}) {
				Label("Quit", systemImage: "power")
					.frame(maxWidth: .infinity)
					.foregroundColor(ThemeManager.primaryColor(for: themeEnvironment.currentTheme))
			}
			.buttonStyle(.plain)
			.padding(.vertical, 8)
			.padding(.horizontal)
		}
		.frame(width: 320, height: 450)
		.background(ThemeManager.backgroundGradient(for: themeEnvironment.currentTheme))
	}
}
