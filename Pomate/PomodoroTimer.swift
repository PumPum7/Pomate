import Combine
import SwiftUI

class PomodoroTimer: ObservableObject {
	enum TimerState {
		case idle
		case workSession
		case shortBreak
		case longBreak
	}

	@Published var state: TimerState = .idle
	@Published var timeRemaining: Int = 25 * 60  // 25 minutes in seconds
	@Published var sessionsCompleted: Int = 0
    
    // Track initial duration for calculating actual time spent
    private var initialDuration: Int = 25 * 60

	private var timer: Timer?
	var settings: PomateSettings

	init(settings: PomateSettings) {
		self.settings = settings
		self.timeRemaining = settings.workDuration
        self.initialDuration = settings.workDuration

		// Listen for settings changes
		settings.$workDuration
			.sink { [weak self] newValue in
				if self?.state == .idle {
					self?.timeRemaining = newValue
                    self?.initialDuration = newValue
				}
			}
			.store(in: &cancellables)
	}

	private var cancellables = Set<AnyCancellable>()

	func startWorkSession() {
		state = .workSession
		timeRemaining = settings.workDuration
        initialDuration = settings.workDuration
		startTimer()
	}

	func startShortBreak() {
		state = .shortBreak
		timeRemaining = settings.shortBreakDuration
        initialDuration = settings.shortBreakDuration
		startTimer()
	}

	func startLongBreak() {
		state = .longBreak
		timeRemaining = settings.longBreakDuration
        initialDuration = settings.longBreakDuration
		startTimer()
	}

	func pause() {
		timer?.invalidate()
		timer = nil
	}

	func reset() {
		timer?.invalidate()
		timer = nil
		state = .idle
		timeRemaining = settings.workDuration
        initialDuration = settings.workDuration
		sessionsCompleted = 0
	}
    
    // Record a completed session
    private func recordSession(type: String, completed: Bool) {
        let record = PomateSettings.SessionRecord(
            date: Date(),
            duration: initialDuration - timeRemaining,
            type: type,
            completed: completed
        )
        settings.sessionHistory.append(record)
        
        // If this is a work session and there's a current task, increment its session count
        if type == "work" && completed, let currentTaskId = settings.currentTaskId {
            settings.incrementTaskSessions(taskId: currentTaskId)
        }
    }

	private func startTimer() {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
			[weak self] currentTimer in
			guard let self = self else { return }

			if self.timeRemaining > 0 {
				self.timeRemaining -= 1
			} else {
				self.timer?.invalidate()
				self.timer = nil

				// Handle session completion
				switch self.state {
				case .workSession:
					self.sessionsCompleted += 1
                    
                    // Record completed work session
                    self.recordSession(type: "work", completed: true)

					if self.settings.playSound {
						currentTimer.sendRichNotification(
							title: "Work session completed!", body: "Time for a break.")
					}

					if self.sessionsCompleted % self.settings.sessionsBeforeLongBreak == 0 {
						self.startLongBreak()
					} else {
						self.startShortBreak()
					}

				case .shortBreak:
                    // Record completed short break
                    self.recordSession(type: "shortBreak", completed: true)
                    
					if self.settings.playSound {
						currentTimer.sendRichNotification(
							title: "Break completed!", body: "Time to get back to work.")
					}
					self.startWorkSession()
                    
                case .longBreak:
                    // Record completed long break
                    self.recordSession(type: "longBreak", completed: true)
                    
                    if self.settings.playSound {
                        currentTimer.sendRichNotification(
                            title: "Break completed!", body: "Time to get back to work.")
                    }
                    self.startWorkSession()

				case .idle:
					break
				}
			}
		}
	}

	// Helper for formatting time
	func formatTime() -> String {
		let minutes = timeRemaining / 60
		let seconds = timeRemaining % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
    
    deinit {
        // Clean up timer resources
        timer?.invalidate()
        timer = nil
        
        // Clean up Combine subscriptions
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
