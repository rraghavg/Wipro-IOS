//
//  UserFormValidatorTests.swift
//  lab-10a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10A
//  XCTest suite covering form validation: normal, boundary, and invalid cases (R2, R3, R4)
//

import XCTest
#if canImport(Lab10A)
@testable import Lab10A
#endif

final class UserFormValidatorTests: XCTestCase {

    // MARK: - Normal Cases (R2 & R3)

    func testValidFormInputsPassValidation() {
        let nameResult = UserFormValidator.validateName("Raghav Gupta")
        let emailResult = UserFormValidator.validateEmail("raghav.gupta@wipro.com")
        let ageResult = UserFormValidator.validateAge(22)
        let passResult = UserFormValidator.validatePassword("WiproSwift2026!")

        XCTAssertEqual(nameResult, .success("Raghav Gupta"))
        XCTAssertEqual(emailResult, .success("raghav.gupta@wipro.com"))
        XCTAssertEqual(ageResult, .success(22))
        XCTAssertEqual(passResult, .success("WiproSwift2026!"))
    }

    // MARK: - Boundary Cases (R3)

    func testNameLengthBoundaryConditions() {
        // Boundary: 2 characters is the minimum accepted length
        let validTwoChar = UserFormValidator.validateName("Al")
        XCTAssertEqual(validTwoChar, .success("Al"), "Two-character names must be valid")

        // Boundary: 1 character must be rejected
        let invalidOneChar = UserFormValidator.validateName("A")
        XCTAssertEqual(invalidOneChar, .failure(.nameTooShort), "Single-character name must fail")

        // Boundary: Empty string or spaces only
        let spacesOnly = UserFormValidator.validateName("   ")
        XCTAssertEqual(spacesOnly, .failure(.nameTooShort), "Whitespace-only name must fail")
    }

    func testAgeRequirementBoundaryConditions() {
        // Boundary: Exactly 18 years old (allowed)
        let age18 = UserFormValidator.validateAge(18)
        XCTAssertEqual(age18, .success(18), "Age 18 must pass the age requirement")

        // Boundary: 17 years old (just under cutoff, rejected)
        let age17 = UserFormValidator.validateAge(17)
        XCTAssertEqual(age17, .failure(.underAgeRequirement), "Age 17 must be rejected")
    }

    // MARK: - Invalid Cases (R3)

    func testInvalidEmailFormatsAreRejected() {
        let missingAtSymbol = UserFormValidator.validateEmail("raghav.wipro.com")
        XCTAssertEqual(missingAtSymbol, .failure(.invalidEmailFormat))

        let missingDomain = UserFormValidator.validateEmail("raghav@")
        XCTAssertEqual(missingDomain, .failure(.invalidEmailFormat))

        let missingDot = UserFormValidator.validateEmail("raghav@wiprocom")
        XCTAssertEqual(missingDot, .failure(.invalidEmailFormat))
    }

    func testWeakPasswordRejected() {
        // Too short (7 chars with number)
        let shortPassword = UserFormValidator.validatePassword("Pass123")
        XCTAssertEqual(shortPassword, .failure(.passwordTooWeak))

        // Long enough but missing numbers
        let noNumberPassword = UserFormValidator.validatePassword("PasswordOnly")
        XCTAssertEqual(noNumberPassword, .failure(.passwordTooWeak))
    }
}
