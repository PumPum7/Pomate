import Combine
import Foundation

class PomateSettings: ObservableObject {
	@Published var workDuration: Int {
		didSet {
			UserDefaults.standard.set(workDuration, forKey: "workDuration")
		}
	}

	@Published var shortBreakDuration: Int {
		didSet {
			UserDefaults.standard.set(shortBreakDuration, forKey: "shortBreakDuration")
		}
	}

	@Published var longBreakDuration: Int {
		didSet {
			UserDefaults.standard.set(longBreakDuration, forKey: "longBreakDuration")
		}
	}

	@Published var sessionsBeforeLongBreak: Int {
		didSet {
			UserDefaults.standard.set(sessionsBeforeLongBreak, forKey: "sessionsBeforeLongBreak")
		}
	}

	@Published var playSound: Bool {
		didSet {
			UserDefaults.standard.set(playSound, forKey: "playSound")
		}
	}

	init() {
		// Initialize with default values first
		self.workDuration = 25 * 60
		self.shortBreakDuration = 5 * 60
		self.longBreakDuration = 15 * 60
		self.sessionsBeforeLongBreak = 4
		self.playSound = true

		// Then load saved values if they exist
		if let savedWork = UserDefaults.standard.object(forKey: "workDuration") as? Int {
			self.workDuration = savedWork
		}

		if let savedShortBreak = UserDefaults.standard.object(forKey: "shortBreakDuration") as? Int
		{
			self.shortBreakDuration = savedShortBreak
		}

		if let savedLongBreak = UserDefaults.standard.object(forKey: "longBreakDuration") as? Int {
			self.longBreakDuration = savedLongBreak
		}

		if let savedSessions = UserDefaults.standard.object(forKey: "sessionsBeforeLongBreak")
			as? Int
		{
			self.sessionsBeforeLongBreak = savedSessions
		}

		if let savedPlaySound = UserDefaults.standard.object(forKey: "playSound") as? Bool {
			self.playSound = savedPlaySound
		}
	}
}
