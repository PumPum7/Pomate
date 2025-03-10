import XCTest

final class PomateUITests: XCTestCase {

	var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}

	@MainActor
	func testTimerTabExists() throws {
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
		XCTAssertTrue(app.buttons["Break"].exists)
		XCTAssertTrue(app.buttons["Start"].exists || app.buttons["Pause"].exists)
		XCTAssertTrue(app.buttons["Reset"].exists)
	}

	@MainActor
	func testTabSwitching() throws {
		// Start in timer tab
		XCTAssertTrue(app.buttons["Work"].exists)

		// Switch to settings tab
		app.segmentedControls.buttons["Settings"].tap()

		// Verify settings elements are visible
		XCTAssertTrue(app.staticTexts["Timer Durations"].exists)
		XCTAssertTrue(app.staticTexts["Work Session"].exists)
		XCTAssertTrue(app.staticTexts["Short Break"].exists)

		// Switch back to timer tab
		app.segmentedControls.buttons["Timer"].tap()

		// Verify timer elements are visible again
		XCTAssertTrue(app.buttons["Work"].exists)
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
	func testSettingsNavigation() throws {
		// Navigate to settings tab
		app.segmentedControls.buttons["Settings"].tap()

		// Check all major section headers
		XCTAssertTrue(app.staticTexts["Timer Durations"].exists)
		XCTAssertTrue(app.staticTexts["Sessions"].exists)
		XCTAssertTrue(app.staticTexts["Notifications"].exists)

		// Check toggle control
		XCTAssertTrue(app.toggles["Play Sound"].exists)
	}
}
