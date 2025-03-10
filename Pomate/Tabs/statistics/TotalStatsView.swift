import SwiftUI

struct TotalStatsView: View {
    let sessions: [PomateSettings.SessionRecord]
    @EnvironmentObject var themeEnvironment: ThemeEnvironment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All-Time Stats")
                .font(.headline)

            HStack(spacing: 20) {
                StatCard(
                    title: "Total Sessions",
                    value: "\(totalWorkSessions)",
                    icon: "number.circle.fill",
                    color: ThemeManager.longBreakColor(for: themeEnvironment.currentTheme)
                )

                StatCard(
                    title: "Total Focus Time",
                    value: formatDuration(totalWorkDuration),
                    icon: "clock.fill",
                    color: ThemeManager.shortBreakColor(for: themeEnvironment.currentTheme)
                )
            }
        }
    }

    // Helper computed properties
    var totalWorkSessions: Int {
        sessions.filter { $0.type == "work" }.count
    }

    var totalWorkDuration: Int {
        sessions.filter { $0.type == "work" }.reduce(0) { $0 + $1.duration }
    }

    // Format duration as HH:MM
    func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
