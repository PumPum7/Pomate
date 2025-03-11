import AppKit
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

	// Session history tracking
	struct SessionRecord: Codable, Identifiable {
		var id = UUID()
		let date: Date
		let duration: Int
		let type: String  // "work", "shortBreak", "longBreak"
		let completed: Bool
	}

	@Published var sessionHistory: [SessionRecord] = [] {
		didSet {
			saveSessionHistory()
		}
	}

	// Task management
	struct Task: Codable, Identifiable {
		var id = UUID()
		var name: String
		var isCompleted: Bool = false
		var createdAt: Date = Date()
		var completedAt: Date?
		var associatedSessions: Int = 0
	}

	@Published var tasks: [Task] = [] {
		didSet {
			saveTasks()
		}
	}

	@Published var currentTaskId: UUID? {
		didSet {
			if let idString = currentTaskId?.uuidString {
				UserDefaults.standard.set(idString, forKey: "currentTaskId")
			} else {
				UserDefaults.standard.removeObject(forKey: "currentTaskId")
			}
		}
	}

	// Theme customization
	enum ColorTheme: String, CaseIterable, Codable {
		case system  // Follow system appearance
		case light  // Light mode
		case dark  // Dark mode
		case tomato  // Red-focused theme
		case ocean  // Blue-focused theme
		case forest  // Green-focused theme
	}

	@Published var colorTheme: ColorTheme = .system {
		didSet {
			UserDefaults.standard.set(colorTheme.rawValue, forKey: "colorTheme")
			applyTheme()
		}
	}

	init() {
		// Initialize with default values first
		self.workDuration = 25 * 60
		self.shortBreakDuration = 5 * 60
		self.longBreakDuration = 15 * 60
		self.sessionsBeforeLongBreak = 4
		self.playSound = true
		self.colorTheme = .system  // Set default theme

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

		// Load theme
		if let savedTheme = UserDefaults.standard.string(forKey: "colorTheme"),
			let theme = ColorTheme(rawValue: savedTheme)
		{
			self.colorTheme = theme
		}

		// We'll apply the theme later when the app is fully initialized
		// Don't call applyTheme() here to avoid the nil NSApp issue

		// Load session history
		loadSessionHistory()

		// Load tasks
		loadTasks()

		// Load current task
		if let currentTaskIdString = UserDefaults.standard.string(forKey: "currentTaskId"),
			let uuid = UUID(uuidString: currentTaskIdString)
		{
			self.currentTaskId = uuid
		}
	}

	// Session history persistence
	func saveSessionHistory() {
		do {
			let encoded = try JSONEncoder().encode(sessionHistory)
			UserDefaults.standard.set(encoded, forKey: "sessionHistory")
			print("[Persistence] Successfully saved session history with \(sessionHistory.count) records")
		} catch {
			print("[Persistence] Error saving session history: \(error.localizedDescription)")
		}
	}

	func loadSessionHistory() {
		do {
			guard let data = UserDefaults.standard.data(forKey: "sessionHistory") else {
				print("[Persistence] No session history found")
				return
			}
			
			let decoded = try JSONDecoder().decode([SessionRecord].self, from: data)
			sessionHistory = decoded
			print("[Persistence] Successfully loaded \(decoded.count) session records")
		} catch {
			print("[Persistence] Error loading session history: \(error.localizedDescription)")
			// Reset to empty array if data is corrupted
			sessionHistory = []
		}
	}

	// Task persistence
	func saveTasks() {
		do {
			let encoded = try JSONEncoder().encode(tasks)
			UserDefaults.standard.set(encoded, forKey: "tasks")
			print("[Persistence] Successfully saved \(tasks.count) tasks")
		} catch {
			print("[Persistence] Error saving tasks: \(error.localizedDescription)")
		}
	}

	func loadTasks() {
		do {
			guard let data = UserDefaults.standard.data(forKey: "tasks") else {
				print("[Persistence] No tasks found")
				return
			}
			
			let decoded = try JSONDecoder().decode([Task].self, from: data)
			tasks = decoded
			print("[Persistence] Successfully loaded \(decoded.count) tasks")
		} catch {
			print("[Persistence] Error loading tasks: \(error.localizedDescription)")
			// Reset to empty array if data is corrupted
			tasks = []
		}
	}

	// Task management functions
	func addTask(name: String) {
		let newTask = Task(name: name)
		tasks.append(newTask)
	}

	func toggleTaskCompletion(taskId: UUID) {
		if let index = tasks.firstIndex(where: { $0.id == taskId }) {
			tasks[index].isCompleted.toggle()

			if tasks[index].isCompleted {
				tasks[index].completedAt = Date()
			} else {
				tasks[index].completedAt = nil
			}
		}
	}

	func deleteTask(taskId: UUID) {
		tasks.removeAll(where: { $0.id == taskId })

		// If the deleted task was the current task, clear the current task
		if currentTaskId == taskId {
			currentTaskId = nil
		}
	}

	func incrementTaskSessions(taskId: UUID) {
		if let index = tasks.firstIndex(where: { $0.id == taskId }) {
			tasks[index].associatedSessions += 1
		}
	}

	// Get current task if it exists
	var currentTask: Task? {
		guard let currentTaskId = currentTaskId else { return nil }
		return tasks.first(where: { $0.id == currentTaskId })
	}

	// Theme application
	func applyTheme() {
		#if os(macOS)
			// Check if NSApp is available before trying to modify its appearance
			if NSApplication.shared.isRunning {
				switch colorTheme {
				case .system:
					NSApp.appearance = nil
				case .light:
					NSApp.appearance = NSAppearance(named: .aqua)
				case .dark:
					NSApp.appearance = NSAppearance(named: .darkAqua)
				default:
					NSApp.appearance = nil  // For custom color themes, use system appearance
				}
			}
		#endif

		// Notify observers that theme has changed
		NotificationCenter.default.post(name: Notification.Name("ThemeChanged"), object: colorTheme)
	}
}
