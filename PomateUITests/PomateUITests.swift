import XCTest

final class PomateUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Tab Navigation Tests
    
    @MainActor
    func testTabNavigation() throws {
        // Verify we start in timer tab
        XCTAssertTrue(app.buttons["Start"].exists)
        
        // Navigate to Statistics tab
        app.segmentedControls.buttons["Statistics"].tap()
        XCTAssertTrue(app.staticTexts["Statistics"].exists)
        XCTAssertTrue(app.buttons["Export"].exists)
        
        // Navigate to Settings tab
        app.segmentedControls.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["Timer Durations"].exists)
        
        // Navigate back to Timer tab
        app.segmentedControls.buttons["Timer"].tap()
        XCTAssertTrue(app.buttons["Start"].exists)
    }

    // MARK: - Timer Tab Tests
    
    @MainActor
    func testTimerTabElements() throws {
        // Verify the timer is visible
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label MATCHES %@", "\\d{2}:\\d{2}"))
                .firstMatch.exists)

        // Verify session count is shown
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Sessions completed"))
                .firstMatch.exists)

        // Verify control buttons exist
        XCTAssertTrue(app.buttons["Work"].exists)
        XCTAssertTrue(app.buttons["Short Break"].exists)
        XCTAssertTrue(app.buttons["Long Break"].exists)
        XCTAssertTrue(app.buttons["Start"].exists)
        XCTAssertTrue(app.buttons["Reset"].exists)
    }

    @MainActor
    func testTimerControls() throws {
        // Start with Start button
        XCTAssertTrue(app.buttons["Start"].exists)

        // Click start button
        app.buttons["Start"].tap()

        // Now should show Pause button
        XCTAssertTrue(app.buttons["Pause"].exists)

        // Pause the timer
        app.buttons["Pause"].tap()

        // Should show Start again
        XCTAssertTrue(app.buttons["Start"].exists)

        // Reset the timer
        app.buttons["Reset"].tap()

        // Should still be in Start state
        XCTAssertTrue(app.buttons["Start"].exists)
    }
    
    @MainActor
    func testTimerTypeButtons() throws {
        // Test Work button
        app.buttons["Work"].tap()
        XCTAssertTrue(app.staticTexts["Work Session"].exists)
        
        // Test Short Break button
        app.buttons["Short Break"].tap()
        XCTAssertTrue(app.staticTexts["Short Break"].exists)
        
        // Test Long Break button
        app.buttons["Long Break"].tap()
        XCTAssertTrue(app.staticTexts["Long Break"].exists)
    }

    // MARK: - Settings Tab Tests
    
    @MainActor
    func testSettingsTabElements() throws {
        // Navigate to settings tab
        app.segmentedControls.buttons["Settings"].tap()

        // Check all major section headers
        XCTAssertTrue(app.staticTexts["Timer Durations"].exists)
        XCTAssertTrue(app.staticTexts["Sessions"].exists)
        XCTAssertTrue(app.staticTexts["Notifications"].exists)
        XCTAssertTrue(app.staticTexts["Appearance"].exists)

        // Check toggle control
        XCTAssertTrue(app.toggles["Play Sound"].exists)
        
        // Check theme picker exists
        XCTAssertTrue(app.staticTexts["Color Theme"].exists)
    }
    
    @MainActor
    func testSettingsInteractions() throws {
        // Navigate to settings tab
        app.segmentedControls.buttons["Settings"].tap()
        
        // Toggle sound setting
        let soundToggle = app.toggles["Play Sound"]
        let initialState = soundToggle.value as? String
        soundToggle.tap()
        
        // Verify toggle changed state
        let newState = soundToggle.value as? String
        XCTAssertNotEqual(initialState, newState)
    }
    
    // MARK: - Statistics Tab Tests
    
    @MainActor
    func testStatisticsTabElements() throws {
        // Navigate to statistics tab
        app.segmentedControls.buttons["Statistics"].tap()
        
        // Verify key elements exist
        XCTAssertTrue(app.staticTexts["Statistics"].exists)
        XCTAssertTrue(app.buttons["Export"].exists)
    }
}
