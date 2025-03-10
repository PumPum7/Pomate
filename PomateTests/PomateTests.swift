import Testing
import SwiftUICore
@testable import Pomate

struct PomateTests {
    
    // MARK: - PomodoroTimer Tests
    
    @Test func timerInitialState() {
        let settings = PomateSettings()
        let timer = PomodoroTimer(settings: settings)
        
        #expect(timer.state == .idle)
        #expect(timer.timeRemaining == settings.workDuration)
        #expect(timer.sessionsCompleted == 0)
    }
    
    @Test func timerStateTransitions() {
        let settings = PomateSettings()
        let timer = PomodoroTimer(settings: settings)
        
        // Start work session
        timer.startWorkSession()
        #expect(timer.state == .workSession)
        #expect(timer.timeRemaining == settings.workDuration)
        
        // Start short break
        timer.startShortBreak()
        #expect(timer.state == .shortBreak)
        #expect(timer.timeRemaining == settings.shortBreakDuration)
        
        // Start long break
        timer.startLongBreak()
        #expect(timer.state == .longBreak)
        #expect(timer.timeRemaining == settings.longBreakDuration)
    }
    
    @Test func timerResetFunctionality() {
        let settings = PomateSettings()
        let timer = PomodoroTimer(settings: settings)
        
        // Change state and sessions completed
        timer.startWorkSession()
        timer.sessionsCompleted = 3
        
        // Reset
        timer.reset()
        #expect(timer.state == .idle)
        #expect(timer.timeRemaining == settings.workDuration)
        #expect(timer.sessionsCompleted == 0)
    }
    
    @Test func timerFormatsTimeCorrectly() {
        let settings = PomateSettings()
        let timer = PomodoroTimer(settings: settings)
        
        // Test various time formatting scenarios
        timer.timeRemaining = 25 * 60  // 25:00
        #expect(timer.formatTime() == "25:00")
        
        timer.timeRemaining = 5 * 60 + 5  // 5:05
        #expect(timer.formatTime() == "05:05")
        
        timer.timeRemaining = 0  // 0:00
        #expect(timer.formatTime() == "00:00")
        
        timer.timeRemaining = 59  // 0:59
        #expect(timer.formatTime() == "00:59")
    }
    
    @Test func timerPauseFunctionality() {
        let settings = PomateSettings()
        let timer = PomodoroTimer(settings: settings)
        
        // Start a session
        timer.startWorkSession()
        let initialTime = timer.timeRemaining
        
        // Manually set time to simulate timer running
        timer.timeRemaining = initialTime - 10
        
        // Pause
        timer.pause()
        
        // Time should remain the same after pause
        #expect(timer.timeRemaining == initialTime - 10)
    }
    
    // MARK: - PomateSettings Tests
    
    @Test func settingsDefaultValues() {
        let settings = PomateSettings()
        
        #expect(settings.workDuration == 25 * 60)
        #expect(settings.shortBreakDuration == 5 * 60)
        #expect(settings.longBreakDuration == 15 * 60)
        #expect(settings.sessionsBeforeLongBreak == 4)
        #expect(settings.playSound == true)
    }
    
    @Test func settingsUpdateAndPublish() {
        let settings = PomateSettings()
        var didUpdateWork = false
        var didUpdateShortBreak = false
        
        // Create a test observation
        let cancellable1 = settings.$workDuration.sink { newValue in
            if newValue == 30 * 60 {
                didUpdateWork = true
            }
        }
        
        let cancellable2 = settings.$shortBreakDuration.sink { newValue in
            if newValue == 10 * 60 {
                didUpdateShortBreak = true
            }
        }
        
        // Update the settings
        settings.workDuration = 30 * 60
        settings.shortBreakDuration = 10 * 60
        
        // Verify updates were published
        #expect(didUpdateWork)
        #expect(didUpdateShortBreak)
        
        // Clean up
        cancellable1.cancel()
        cancellable2.cancel()
    }
    
    @Test func timerReactsToSettingsChanges() {
        let settings = PomateSettings()
        let timer = PomodoroTimer(settings: settings)
        
        // Initial state
        #expect(timer.timeRemaining == settings.workDuration)
        
        // Change settings while timer is idle
        settings.workDuration = 30 * 60
        
        // Timer should update
        #expect(timer.timeRemaining == 30 * 60)
    }
    
    // MARK: - Task Management Tests
    
    @Test func taskManagementFunctionality() {
        let settings = PomateSettings()
        
        // Add a task
        settings.addTask(name: "Test Task")
        #expect(settings.tasks.count == 1)
        #expect(settings.tasks[0].name == "Test Task")
        #expect(settings.tasks[0].isCompleted == false)
        
        // Set as current task
        let taskId = settings.tasks[0].id
        settings.currentTaskId = taskId
        #expect(settings.currentTask?.id == taskId)
        
        // Toggle completion
        settings.toggleTaskCompletion(taskId: taskId)
        #expect(settings.tasks[0].isCompleted == true)
        #expect(settings.tasks[0].completedAt != nil)
        
        // Toggle back
        settings.toggleTaskCompletion(taskId: taskId)
        #expect(settings.tasks[0].isCompleted == false)
        #expect(settings.tasks[0].completedAt == nil)
        
        // Increment sessions
        settings.incrementTaskSessions(taskId: taskId)
        #expect(settings.tasks[0].associatedSessions == 1)
        
        // Delete task
        settings.deleteTask(taskId: taskId)
        #expect(settings.tasks.isEmpty)
        #expect(settings.currentTaskId == nil)
    }
    
    // MARK: - Theme Tests
    
    @Test func themeColorFunctionality() {
        // Test primary colors for different themes
        #expect(ThemeManager.primaryColor(for: .tomato) == Color.red)
        #expect(ThemeManager.primaryColor(for: .ocean) == Color.blue)
        #expect(ThemeManager.primaryColor(for: .forest) == Color.green)
        
        // Test work session colors
        #expect(ThemeManager.workSessionColor(for: .tomato) == Color.red)
        
        // Test animation curves
        let tomatoAnimation = ThemeManager.animationCurve(for: .tomato)
        let oceanAnimation = ThemeManager.animationCurve(for: .ocean)
        #expect(tomatoAnimation != oceanAnimation)
    }
}
