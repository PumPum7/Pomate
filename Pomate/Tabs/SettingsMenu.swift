import SwiftUI

struct SettingsTabView: View {
    @ObservedObject var settings: PomateSettings

    init(settings: PomateSettings) {
        _settings = .init(wrappedValue: settings)
    }

    // More reasonable time intervals for better UX
    private let workTimeOptions = [
        (15, "15 min"), (20, "20 min"), (25, "25 min"), (30, "30 min"),
        (35, "35 min"), (40, "40 min"), (45, "45 min"), (50, "50 min"),
        (55, "55 min"), (60, "60 min"), (90, "90 min"), (120, "120 min")
    ]

    private let breakTimeOptions = [
        (5, "5 min"), (10, "10 min"), (15, "15 min"), (20, "20 min"),
        (25, "25 min"), (30, "30 min"), (45, "45 min"), (60, "60 min")
    ]

    private let sessionsOptions = [2, 3, 4, 5, 6, 7, 8]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Timer Durations").font(.headline)

                    // Work duration setting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Work Session").foregroundColor(.secondary)
                        Picker("", selection: $settings.workDuration) {
                            ForEach(workTimeOptions, id: \.0) { minutes, label in
                                Text(label).tag(minutes * 60)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                    }

                    // Short break duration setting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Short Break").foregroundColor(.secondary)
                        Picker("", selection: $settings.shortBreakDuration) {
                            ForEach(breakTimeOptions, id: \.0) { minutes, label in
                                Text(label).tag(minutes * 60)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                    }

                    // Long break duration setting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Long Break").foregroundColor(.secondary)
                        Picker("", selection: $settings.longBreakDuration) {
                            ForEach(breakTimeOptions, id: \.0) { minutes, label in
                                Text(label).tag(minutes * 60)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                    }
                }

                Divider().padding(.vertical, 5)

                Group {
                    Text("Sessions").font(.headline)

                    // Sessions before long break setting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Sessions before long break").foregroundColor(.secondary)
                        Picker("", selection: $settings.sessionsBeforeLongBreak) {
                            ForEach(sessionsOptions, id: \.self) { count in
                                Text("\(count) sessions").tag(count)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                    }
                }

                Divider().padding(.vertical, 5)

                Group {
                    Text("Notifications").font(.headline)

                    Toggle("Play Sound", isOn: $settings.playSound)
                }
            }
            .padding()
        }
    }
}
