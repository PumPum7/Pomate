import SwiftUI

struct StatusBarView: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer
    @EnvironmentObject var themeEnvironment: ThemeEnvironment

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: getIconName())
                .foregroundColor(getIconColor())
                .font(.system(size: 12))

            if pomodoroTimer.state != .idle {
                Text(pomodoroTimer.formatTime())
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(getIconColor())
            }
        }
    }

    private func getIconName() -> String {
        switch pomodoroTimer.state {
        case .idle:
            return "timer"
        case .workSession:
            return "timer.circle.fill"
        case .shortBreak:
            return "cup.and.saucer.fill"
        case .longBreak:
            return "figure.walk"
        }
    }
    
    private func getIconColor() -> Color {
        switch pomodoroTimer.state {
        case .idle:
            return .primary
        case .workSession:
            return .red
        case .shortBreak:
            return .blue
        case .longBreak:
            return .green
        }
    }
}
