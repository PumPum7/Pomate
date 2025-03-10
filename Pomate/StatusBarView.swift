import SwiftUI

struct StatusBarView: View {
	@ObservedObject var pomodoroTimer: PomodoroTimer

	var body: some View {
		HStack(spacing: 4) {
			Image(systemName: getIconName())

			Text(pomodoroTimer.formatTime())
				.font(.system(size: 12, weight: .medium, design: .monospaced))
		}
	}

	private func getIconName() -> String {
		switch pomodoroTimer.state {
		case .idle:
			return "timer"
		case .workSession:
			return "timer.circle.fill"
		case .shortBreak, .longBreak:
			return "cup.and.saucer.fill"
		}
	}
}
