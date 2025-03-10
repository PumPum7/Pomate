import XCTest

final class PomateUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Verify app launches with expected initial screen elements
        XCTAssertTrue(app.segmentedControls.firstMatch.exists, "Segmented control should be visible on launch")
        XCTAssertTrue(app.buttons["Start"].exists, "Start button should be visible on launch")
        XCTAssertTrue(app.buttons["Work"].exists, "Work button should be visible on launch")
        XCTAssertTrue(app.buttons["Reset"].exists, "Reset button should be visible on launch")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testInitialTimerDisplay() throws {
        let app = XCUIApplication()
        app.launch()

        // Timer should display in 00:00 format
        let timerText = app.staticTexts.matching(
            NSPredicate(format: "label MATCHES %@", "\\d{2}:\\d{2}")
        ).firstMatch
        XCTAssertTrue(timerText.exists, "Timer text should be visible in 00:00 format")
        
        // Verify initial state text is "Ready"
        let stateText = app.staticTexts["Ready"]
        XCTAssertTrue(stateText.exists, "Initial state text should be 'Ready'")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Initial Timer Display"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testInitialSessionCount() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify initial session count is zero
        let sessionText = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Sessions completed: 0")
        ).firstMatch
        XCTAssertTrue(sessionText.exists, "Initial session count should be zero")
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Initial Session Count"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
