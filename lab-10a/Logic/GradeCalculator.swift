//
//  GradeCalculator.swift
//  lab-10a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10A
//  Business logic for calculating student letter grades, GPA, and handling boundaries/invalid scores.
//

import Foundation

enum GradeError: Error, Equatable {
    case negativeScore(Double)
    case scoreExceedsMaximum(Double)
}

struct GradeResult: Equatable {
    let letterGrade: String
    let gpa: Double
    let isHonorRoll: Bool
}

struct GradeCalculator {

    /// Calculates letter grade and GPA for a given numeric score (0 to 100).
    /// - Parameter score: Numeric test percentage.
    /// - Throws: `GradeError.negativeScore` if score < 0, or `GradeError.scoreExceedsMaximum` if score > 100.
    static func calculateGrade(score: Double) throws -> GradeResult {
        // R3: Invalid input checks
        if score < 0 {
            throw GradeError.negativeScore(score)
        }
        if score > 100 {
            throw GradeError.scoreExceedsMaximum(score)
        }

        // R3: Boundary checks (Standard 90, 80, 70, 60 cutoffs)
        switch score {
        case 90.0...100.0:
            return GradeResult(letterGrade: "A", gpa: 4.0, isHonorRoll: true)
        case 80.0..<90.0:
            return GradeResult(letterGrade: "B", gpa: 3.0, isHonorRoll: false)
        case 70.0..<80.0:
            return GradeResult(letterGrade: "C", gpa: 2.0, isHonorRoll: false)
        case 60.0..<70.0:
            return GradeResult(letterGrade: "D", gpa: 1.0, isHonorRoll: false)
        default:
            return GradeResult(letterGrade: "F", gpa: 0.0, isHonorRoll: false)
        }
    }
}
