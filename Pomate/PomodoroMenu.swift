import SwiftUI

struct PomodoroMenu: View {
	@ObservedObject var pomodoroTimer: PomodoroTimer
	@ObservedObject var settings: PomateSettings
	@State private var selectedTab = 0

	var body: some View {
		VStack {
			// Tab selection
			Picker("", selection: $selectedTab) {
				Text("Timer").tag(0)
				Text("Settings").tag(1)
			}
			.pickerStyle(SegmentedPickerStyle())
			.padding(.horizontal)
			.padding(.top)

			// Content based on selected tab
			if selectedTab == 0 {
				TimerTabView(pomodoroTimer: pomodoroTimer)
			} else {
				SettingsTabView(settings: settings)
			}

			Divider()

			Button("Quit") {
				NSApplication.shared.terminate(nil)
			}
			.padding(.bottom)
		}
		.frame(width: 300, height: 400)
		.padding(.vertical)
	}
}
