//
//  GradeCalculatorTests.swift
//  lab-10a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10A
//  XCTest suite covering grade calculation: normal, boundary, and invalid cases (R2, R3, R4)
//

import XCTest
#if canImport(Lab10A)
@testable import Lab10A
#endif

final class GradeCalculatorTests: XCTestCase {

    // MARK: - Normal Cases (R2 & R3)

    func testNormalPassingGrades() throws {
        // Arrange
        let scoreA = 95.0
        let scoreB = 85.0
        let scoreC = 75.0

        // Act
        let resultA = try GradeCalculator.calculateGrade(score: scoreA)
        let resultB = try GradeCalculator.calculateGrade(score: scoreB)
        let resultC = try GradeCalculator.calculateGrade(score: scoreC)

        // Assert (R4: Meaningful assertions)
        XCTAssertEqual(resultA.letterGrade, "A", "Score 95.0 should result in grade A")
        XCTAssertEqual(resultA.gpa, 4.0, "Score 95.0 should result in GPA 4.0")
        XCTAssertTrue(resultA.isHonorRoll, "Grade A should qualify for Honor Roll")

        XCTAssertEqual(resultB.letterGrade, "B", "Score 85.0 should result in grade B")
        XCTAssertEqual(resultB.gpa, 3.0, "Score 85.0 should result in GPA 3.0")
        XCTAssertFalse(resultB.isHonorRoll, "Grade B should not qualify for Honor Roll")

        XCTAssertEqual(resultC.letterGrade, "C", "Score 75.0 should result in grade C")
        XCTAssertEqual(resultC.gpa, 2.0, "Score 75.0 should result in GPA 2.0")
    }

    // MARK: - Boundary Cases (R3)

    func testBoundaryGradeCutoffs() throws {
        // Exactly on the 90.0 boundary
        let resultExact90 = try GradeCalculator.calculateGrade(score: 90.0)
        XCTAssertEqual(resultExact90.letterGrade, "A", "Score 90.0 boundary must yield grade A")

        // Just below the 90.0 boundary (89.9)
        let resultBelow90 = try GradeCalculator.calculateGrade(score: 89.9)
        XCTAssertEqual(resultBelow90.letterGrade, "B", "Score 89.9 must yield grade B")

        // Exactly on the 80.0 boundary
        let resultExact80 = try GradeCalculator.calculateGrade(score: 80.0)
        XCTAssertEqual(resultExact80.letterGrade, "B", "Score 80.0 boundary must yield grade B")

        // Just below 80.0 boundary (79.9)
        let resultBelow80 = try GradeCalculator.calculateGrade(score: 79.9)
        XCTAssertEqual(resultBelow80.letterGrade, "C", "Score 79.9 must yield grade C")

        // Failing cutoff: 59.9 should be F, 60.0 should be D
        let resultExact60 = try GradeCalculator.calculateGrade(score: 60.0)
        XCTAssertEqual(resultExact60.letterGrade, "D", "Score 60.0 must yield passing grade D")

        let resultBelow60 = try GradeCalculator.calculateGrade(score: 59.9)
        XCTAssertEqual(resultBelow60.letterGrade, "F", "Score 59.9 must yield failing grade F")
    }

    func testMinAndMaxScaleBoundaries() throws {
        // Perfect score (100.0)
        let result100 = try GradeCalculator.calculateGrade(score: 100.0)
        XCTAssertEqual(result100.letterGrade, "A")
        XCTAssertEqual(result100.gpa, 4.0)

        // Minimum score (0.0)
        let result0 = try GradeCalculator.calculateGrade(score: 0.0)
        XCTAssertEqual(result0.letterGrade, "F")
        XCTAssertEqual(result0.gpa, 0.0)
    }

    // MARK: - Invalid Cases (R3)

    func testNegativeScoreThrowsExpectedError() {
        let negativeScore = -5.5

        XCTAssertThrowsError(try GradeCalculator.calculateGrade(score: negativeScore), "Negative scores must throw an error") { error in
            XCTAssertEqual(error as? GradeError, GradeError.negativeScore(-5.5))
        }
    }

    func testScoreAbove100ThrowsExpectedError() {
        let excessiveScore = 105.0

        XCTAssertThrowsError(try GradeCalculator.calculateGrade(score: excessiveScore), "Scores above 100 must throw an error") { error in
            XCTAssertEqual(error as? GradeError, GradeError.scoreExceedsMaximum(105.0))
        }
    }
}
