//
//  Lab10BUITests.swift
//  lab-10b
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10B
//  Automated UI journeys using XCUITest, accessibility identifiers, and dynamic expectation waits (R1, R2, R3, R4, Extension)
//

import XCTest

final class Lab10BUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - R1 & R2 & R4: Key User Journey: Fill Form, Submit, Verify Visible Result

    func testSuccessfulFormSubmission() throws {
        // Locate text fields using accessibility identifiers (R2)
        let nameField = app.textFields["nameTextField"]
        let emailField = app.textFields["emailTextField"]
        let termsToggle = app.switches["termsToggle"]
        let submitButton = app.buttons["submitButton"]

        // R4: Dynamic wait for UI element to appear (avoiding fixed Thread.sleep)
        XCTAssertTrue(nameField.waitForExistence(timeout: 3.0), "Name field should appear on launch")

        // Step 1: Enter form data
        nameField.tap()
        nameField.typeText("Raghav Gupta")

        emailField.tap()
        emailField.typeText("raghav.gupta@wipro.com")

        // Step 2: Toggle terms agreement
        if termsToggle.value as? String == "0" {
            termsToggle.tap()
        }

        // Step 3: Tap submit
        submitButton.tap()

        // Step 4: Verify visible result (Alert presented)
        let alert = app.alerts["Registration Complete"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2.0), "Success alert must be displayed after submitting valid form")

        // Dismiss alert
        alert.buttons["alertOkButton"].tap()
    }

    // MARK: - R3: Validation Error Handling

    func testFormValidationErrorForEmptyInput() throws {
        let submitButton = app.buttons["submitButton"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 3.0))

        // Tap submit without entering any data
        submitButton.tap()

        // Verify inline error banner is rendered (R3)
        let errorBanner = app.staticTexts["validationErrorBanner"]
        XCTAssertTrue(errorBanner.waitForExistence(timeout: 2.0), "Validation error banner must appear when submitting empty inputs")
        XCTAssertTrue(errorBanner.label.contains("cannot be empty"), "Error message should inform user about empty fields")
    }

    // MARK: - Extension: List-to-Detail Navigation Journey

    func testListToDetailNavigationJourney() throws {
        // Step 1: Switch to Directory Tab
        let directoryTab = app.tabBars.buttons["directoryTabButton"]
        XCTAssertTrue(directoryTab.waitForExistence(timeout: 3.0))
        directoryTab.tap()

        // Step 2: Tap first candidate row
        let candidateRow = app.buttons["candidateRow_0"]
        XCTAssertTrue(candidateRow.waitForExistence(timeout: 2.0), "Candidate list row must be present")
        candidateRow.tap()

        // Step 3: Verify detail screen is loaded
        let detailTitle = app.staticTexts["candidateDetailTitle"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 2.0), "Candidate detail screen title should be visible")
        XCTAssertEqual(detailTitle.label, "Raghav Gupta")

        // Step 4: Verify skill detail bio
        let detailBio = app.staticTexts["candidateDetailBio"]
        XCTAssertTrue(detailBio.exists)

        // Step 5: Navigate back to list screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Verify returning to candidate list
        XCTAssertTrue(candidateRow.waitForExistence(timeout: 2.0), "Should safely return to candidate directory")
    }
}
