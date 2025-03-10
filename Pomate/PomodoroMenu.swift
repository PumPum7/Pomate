import SwiftUI

struct PomodoroMenu: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer
    @ObservedObject var settings: PomateSettings
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // Tab selection - adjusted padding to make tabs visible
            Picker("", selection: $selectedTab) {
                Label("Timer", systemImage: "timer")
                    .tag(0)
                Label("Settings", systemImage: "gear")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top, 16) // Increased top padding to make tabs more visible
            .padding(.bottom, 12)

            // Content based on selected tab
            if selectedTab == 0 {
                TimerTabView(pomodoroTimer: pomodoroTimer)
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
            }
            .buttonStyle(.plain)
            .padding(.vertical, 8)
            .padding(.horizontal)
        }
        .frame(width: 320, height: 450)
    }
}
