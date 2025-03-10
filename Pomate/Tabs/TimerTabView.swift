import SwiftUI

struct TimerTabView: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer
    @State private var showTaskManager = false
    @EnvironmentObject var themeEnvironment: ThemeEnvironment
    
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
                
                // Current task display
                VStack(spacing: 8) {
                    HStack {
                        Text("Current Task")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: {
                            showTaskManager = true
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.caption)
                        }
                        .buttonStyle(.plain)
                        .popover(isPresented: $showTaskManager) {
                            TaskManagerView(settings: pomodoroTimer.settings)
                                .frame(width: 300, height: 400)
                                .environmentObject(themeEnvironment)
                        }
                    }
                    
                    if let currentTask = pomodoroTimer.settings.currentTask {
                        HStack {
                            Text(currentTask.name)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if currentTask.associatedSessions > 0 {
                                Text("\(currentTask.associatedSessions) sessions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(ThemeManager.primaryColor(for: themeEnvironment.currentTheme).opacity(0.1))
                        )
                    } else {
                        Button(action: {
                            showTaskManager = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Select a task")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                
                // Session counter
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ThemeManager.primaryColor(for: themeEnvironment.currentTheme))
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
                            action: { pomodoroTimer.startWorkSession() },
                            theme: themeEnvironment.currentTheme
                        )
                        
                        TimerButton(
                            title: "Short Break",
                            icon: "cup.and.saucer.fill",
                            isActive: pomodoroTimer.state == .shortBreak,
                            action: { pomodoroTimer.startShortBreak() },
                            theme: themeEnvironment.currentTheme
                        )
                        
                        TimerButton(
                            title: "Long Break",
                            icon: "figure.walk",
                            isActive: pomodoroTimer.state == .longBreak,
                            action: { pomodoroTimer.startLongBreak() },
                            theme: themeEnvironment.currentTheme
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
                        .tint(ThemeManager.buttonColor(for: themeEnvironment.currentTheme))
                        
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
            .background(ThemeManager.backgroundGradient(for: themeEnvironment.currentTheme))
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
        let theme = themeEnvironment.currentTheme
        
        switch pomodoroTimer.state {
        case .workSession:
            return ThemeManager.workSessionColor(for: theme)
        case .shortBreak:
            return ThemeManager.shortBreakColor(for: theme)
        case .longBreak:
            return ThemeManager.longBreakColor(for: theme)
        case .idle:
            return Color.gray
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
    let theme: PomateSettings.ColorTheme
    
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
        .background(isActive ? ThemeManager.primaryColor(for: theme).opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }
}
