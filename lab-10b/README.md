# Lab 10B: UI Automation with XCUITest

**Wipro iOS Developer Training — Module 10**

## 1. Overview
Lab 10B automates key user journeys using Apple's XCUITest framework, testing end-to-end form completion, validation error states, and list-to-detail navigation without using arbitrary fixed sleeps.

## 2. Architecture & Components
- **`Lab10BApp.swift`**: SwiftUI app equipped with explicit `.accessibilityIdentifier(...)` on all interactive fields and labels.
- **`UITests/Lab10BUITests.swift`**:
  - `testSuccessfulFormSubmission()`: Fills out name, email, toggles terms, submits, and asserts alert presence with `waitForExistence(timeout:)`.
  - `testFormValidationErrorForEmptyInput()`: Submits blank inputs and verifies inline error banner presentation.
  - `testListToDetailNavigationJourney()`: Switches tabs, taps candidate row, verifies detail bio, and navigates back to list.
- **`Unit-vs-UI-Testing-Explanation.txt`**: Deep-dive technical document comparing unit tests vs. UI automation, accessibility identifier importance, and dynamic wait best practices.

## 3. Rubric Verification
- [x] **R1: End-to-End Journey**: Automated launch, form population, submission, and confirmation alert verification.
- [x] **R2: Accessibility Identifiers**: Distinct identifiers on text fields, toggles, buttons, and banners.
- [x] **R3: Validation Error State**: Test validating error presentation on empty input submission.
- [x] **R4: Dynamic Waits**: Used `waitForExistence(timeout:)` throughout; zero arbitrary `sleep()` calls.
- [x] **R5: Unit vs UI Comparison**: Documented differences in scope, speed, flakiness, and maintenance cost.
- [x] **Extension**: Automated list-to-detail navigation journey and back-button flow.
