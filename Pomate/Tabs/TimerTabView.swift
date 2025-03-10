import SwiftUI

struct TimerTabView: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        VStack(spacing: 16) {
            Text(pomodoroTimer.formatTime())
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .padding(.top)

            Text("Sessions completed: \(pomodoroTimer.sessionsCompleted)")
                .font(.caption)

            HStack(spacing: 10) {
                Button(action: {
                    pomodoroTimer.startWorkSession()
                }) {
                    Text("Work")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: {
                    pomodoroTimer.startShortBreak()
                }) {
                    Text("Break")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            HStack(spacing: 10) {
                Button(action: {
                    if pomodoroTimer.state != .idle {
                        pomodoroTimer.pause()
                    } else {
                        // Resume based on previous state or default to work session
                        pomodoroTimer.startWorkSession()
                    }
                }) {
                    Text(pomodoroTimer.state == .idle ? "Start" : "Pause")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: {
                    pomodoroTimer.reset()
                }) {
                    Text("Reset")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
