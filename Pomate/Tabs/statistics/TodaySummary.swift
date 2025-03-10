import SwiftUI

struct TodaySummaryView: View {
	let sessions: [PomateSettings.SessionRecord]
	@EnvironmentObject var themeEnvironment: ThemeEnvironment

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("Today")
				.font(.headline)

			HStack(spacing: 20) {
				StatCard(
					title: "Work Sessions",
					value: "\(workSessions.count)",
					icon: "briefcase.fill",
					color: ThemeManager.workSessionColor(for: themeEnvironment.currentTheme)
				)

				StatCard(
					title: "Focus Time",
					value: formatDuration(totalWorkDuration),
					icon: "timer",
					color: ThemeManager.primaryColor(for: themeEnvironment.currentTheme)
				)
			}
		}
	}

	// Helper computed properties
	var workSessions: [PomateSettings.SessionRecord] {
		sessions.filter { $0.type == "work" }
	}

	var totalWorkDuration: Int {
		workSessions.reduce(0) { $0 + $1.duration }
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
