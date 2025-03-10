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
		XCTAssertTrue(app.segmentedControls.firstMatch.exists)
		XCTAssertTrue(app.buttons["Start"].exists)

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
		XCTAssertTrue(timerText.exists)

		let attachment = XCTAttachment(screenshot: app.screenshot())
		attachment.name = "Initial Timer Display"
		attachment.lifetime = .keepAlways
		add(attachment)
	}
}
