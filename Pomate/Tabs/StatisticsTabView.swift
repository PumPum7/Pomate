import SwiftUI

struct StatisticsTabView: View {
    @ObservedObject var settings: PomateSettings
    @EnvironmentObject var themeEnvironment: ThemeEnvironment
    @State private var showingExportDialog = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with title and export button
                HStack {
                    Text("Statistics")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        showingExportDialog = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export")
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(ThemeManager.primaryColor(for: themeEnvironment.currentTheme).opacity(0.15))
                        )
                        .foregroundColor(ThemeManager.primaryColor(for: themeEnvironment.currentTheme))
                    }
                    .buttonStyle(.plain)
                    .fileExporter(
                        isPresented: $showingExportDialog,
                        document: CSVDocument(data: generateCSV(from: settings.sessionHistory)),
                        contentType: .commaSeparatedText,
                        defaultFilename: "pomate_statistics_\(formattedDate())"
                    ) { result in
                        switch result {
                        case .success(let url):
                            print("Saved to \(url)")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }

                // Today's summary
                TodaySummaryView(sessions: todaySessions())
                    .padding(.top, 4)

                Divider()
                    .padding(.vertical, 4)

                // Weekly chart
                WeeklyProgressView(sessions: settings.sessionHistory)

                Divider()
                    .padding(.vertical, 4)

                // Total statistics
                TotalStatsView(sessions: settings.sessionHistory)

                Spacer()
            }
            .padding()
            .background(ThemeManager.backgroundGradient(for: themeEnvironment.currentTheme))
        }
    }

    // Helper to get today's sessions
    func todaySessions() -> [PomateSettings.SessionRecord] {
        let calendar = Calendar.current
        return settings.sessionHistory.filter {
            calendar.isDateInToday($0.date)
        }
    }

    // Generate CSV data from session history
    private func generateCSV(from sessions: [PomateSettings.SessionRecord]) -> String {
        // CSV header
        var csv = "Date,Time,Type,Duration (seconds),Completed\n"

        // Sort sessions by date (newest first)
        let sortedSessions = sessions.sorted { $0.date > $1.date }

        // Date formatters
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short

        // Add each session as a row
        for session in sortedSessions {
            let date = dateFormatter.string(from: session.date)
            let time = timeFormatter.string(from: session.date)
            let type = session.type
            let duration = session.duration
            let completed = session.completed ? "Yes" : "No"

            csv += "\(date),\(time),\(type),\(duration),\(completed)\n"
        }

        return csv
    }

    // Format current date for filename
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
