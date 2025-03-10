import SwiftUI

struct SettingsView: View {
	@ObservedObject var settings: PomateSettings
	@Environment(\.presentationMode) var presentationMode

	init(settings: PomateSettings) {
		self.settings = settings
	}

	private var minutesRange = Array(1...120)  // From 1 to 120 minutes
	private var sessionsRange = Array(1...10)  // From 1 to 10 sessions

	var body: some View {
		VStack(spacing: 20) {
			Text("Pomate Settings")
				.font(.title)
				.fontWeight(.bold)

			Form {
				Section(header: Text("Timer Durations")) {
					Picker("Work Session", selection: $settings.workDuration) {
						ForEach(minutesRange, id: \.self) { minutes in
							Text("\(minutes) minutes").tag(minutes * 60)
						}
					}

					Picker("Short Break", selection: $settings.shortBreakDuration) {
						ForEach(minutesRange, id: \.self) { minutes in
							Text("\(minutes) minutes").tag(minutes * 60)
						}
					}

					Picker("Long Break", selection: $settings.longBreakDuration) {
						ForEach(minutesRange, id: \.self) { minutes in
							Text("\(minutes) minutes").tag(minutes * 60)
						}
					}
				}

				Section(header: Text("Sessions")) {
					Picker(
						"Sessions before long break", selection: $settings.sessionsBeforeLongBreak
					) {
						ForEach(sessionsRange, id: \.self) { count in
							Text("\(count) sessions").tag(count)
						}
					}
				}

				Section(header: Text("Notifications")) {
					Toggle("Play Sound", isOn: $settings.playSound)
				}
			}

			Button("Close") {
				presentationMode.wrappedValue.dismiss()
			}
			.keyboardShortcut(.cancelAction)
			.padding()
		}
		.frame(width: 400, height: 500)
		.padding()
	}
}
