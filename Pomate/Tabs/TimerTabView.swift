import SwiftUI

struct TimerTabView: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Timer display
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                    
                    Circle()
                        .trim(from: 0.0, to: progressValue())
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .foregroundColor(timerColor())
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: progressValue())
                    
                    VStack(spacing: 5) {
                        Text(pomodoroTimer.formatTime())
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                        
                        Text(stateText())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 200, height: 200)
                .padding(.top, 10)
                
                // Session counter
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Sessions completed: \(pomodoroTimer.sessionsCompleted)")
                        .font(.subheadline)
                }
                .padding(.horizontal)
                
                // Control buttons
                VStack(spacing: 12) {
                    // Timer type buttons
                    HStack(spacing: 12) {
                        TimerButton(
                            title: "Work",
                            icon: "briefcase.fill",
                            isActive: pomodoroTimer.state == .workSession,
                            action: { pomodoroTimer.startWorkSession() }
                        )
                        
                        TimerButton(
                            title: "Short Break",
                            icon: "cup.and.saucer.fill",
                            isActive: pomodoroTimer.state == .shortBreak,
                            action: { pomodoroTimer.startShortBreak() }
                        )
                        
                        TimerButton(
                            title: "Long Break",
                            icon: "figure.walk",
                            isActive: pomodoroTimer.state == .longBreak,
                            action: { pomodoroTimer.startLongBreak() }
                        )
                    }
                    
                    // Control buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            if pomodoroTimer.state != .idle {
                                pomodoroTimer.pause()
                            } else {
                                pomodoroTimer.startWorkSession()
                            }
                        }) {
                            Label(
                                pomodoroTimer.state == .idle ? "Start" : "Pause",
                                systemImage: pomodoroTimer.state == .idle ? "play.fill" : "pause.fill"
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            pomodoroTimer.reset()
                        }) {
                            Label("Reset", systemImage: "arrow.counterclockwise")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // Helper functions
    private func progressValue() -> CGFloat {
        let totalTime: CGFloat
        
        switch pomodoroTimer.state {
        case .workSession:
            totalTime = CGFloat(pomodoroTimer.settings.workDuration)
        case .shortBreak:
            totalTime = CGFloat(pomodoroTimer.settings.shortBreakDuration)
        case .longBreak:
            totalTime = CGFloat(pomodoroTimer.settings.longBreakDuration)
        case .idle:
            return 0
        }
        
        let remaining = CGFloat(pomodoroTimer.timeRemaining)
        let progress = 1.0 - (remaining / totalTime)
        return min(max(progress, 0), 1)
    }
    
    private func timerColor() -> Color {
        switch pomodoroTimer.state {
        case .workSession:
            return .red
        case .shortBreak:
            return .blue
        case .longBreak:
            return .green
        case .idle:
            return .gray
        }
    }
    
    private func stateText() -> String {
        switch pomodoroTimer.state {
        case .workSession:
            return "Work Session"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        case .idle:
            return "Ready"
        }
    }
}

// Custom button style for timer type selection
struct TimerButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.bordered)
        .background(isActive ? Color.accentColor.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }
}
