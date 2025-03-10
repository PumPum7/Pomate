import SwiftUI

struct WeeklyProgressView: View {
	let sessions: [PomateSettings.SessionRecord]
	@EnvironmentObject var themeEnvironment: ThemeEnvironment

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("Weekly Progress")
				.font(.headline)

			// Simple bar chart showing daily work time
			VStack(alignment: .leading) {
				ForEach(lastSevenDays(), id: \.self) { date in
					let duration = totalWorkDurationFor(date: date)

					HStack(alignment: .center, spacing: 10) {
						Text(formatDate(date))
							.font(.caption)
							.frame(width: 40, alignment: .leading)

						GeometryReader { geometry in
							RoundedRectangle(cornerRadius: 4)
								.fill(
									ThemeManager.workSessionColor(
										for: themeEnvironment.currentTheme
									).opacity(0.7)
								)
								.frame(
									width: barWidth(
										duration: duration, maxWidth: geometry.size.width),
									height: 16)
						}
						.frame(height: 16)

						Text(formatDuration(duration))
							.font(.caption)
							.frame(width: 50, alignment: .trailing)
					}
					.frame(height: 20)
				}
			}
			.padding(.top, 8)
		}
	}

	// Helper functions
	func lastSevenDays() -> [Date] {
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: Date())

		return (0..<7).map { dayOffset in
			calendar.date(byAdding: .day, value: -dayOffset, to: today)!
		}.reversed()
	}

	func totalWorkDurationFor(date: Date) -> Int {
		let calendar = Calendar.current
		let sessionsOnDate = sessions.filter {
			calendar.isDate($0.date, inSameDayAs: date) && $0.type == "work"
		}

		return sessionsOnDate.reduce(0) { $0 + $1.duration }
	}

	func barWidth(duration: Int, maxWidth: CGFloat) -> CGFloat {
		let maxDuration = 4 * 60 * 60  // 4 hours as max scale
		let ratio = min(CGFloat(duration) / CGFloat(maxDuration), 1.0)
		return max(ratio * maxWidth, duration > 0 ? 4 : 0)  // At least 4pt if there's any time
	}

	func formatDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "EE"
		return formatter.string(from: date)
	}

	func formatDuration(_ seconds: Int) -> String {
		let hours = seconds / 3600
		let minutes = (seconds % 3600) / 60

		if hours > 0 {
			return "\(hours)h \(minutes)m"
		} else if minutes > 0 {
			return "\(minutes)m"
		} else {
			return "0m"
		}
	}
}
