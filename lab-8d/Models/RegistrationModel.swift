//
//  RegistrationModel.swift
//  lab-8d
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training
//  Lab 8D: Event Registration Data Model & Validation Rules
//

import Foundation

enum ExperienceLevel: String, CaseIterable, Identifiable {
    case beginner = "Junior / Beginner"
    case intermediate = "Mid-Level Trainee"
    case advanced = "Senior Engineer"

    var id: String { rawValue }
}

enum SessionTrack: String, CaseIterable, Identifiable {
    case swiftUI = "SwiftUI & Declarative Layouts"
    case uikit = "UIKit & Auto Layout Architecture"
    case concurrency = "Modern Swift Concurrency"
    case architecture = "iOS Architecture Patterns (MVVM)"

    var id: String { rawValue }
}

struct RegistrationData: Equatable {
    var fullName: String = ""
    var email: String = ""
    var organization: String = "Wipro Technologies"
    var experienceLevel: ExperienceLevel = .intermediate
    var selectedTrack: SessionTrack = .swiftUI
    var wantsCertificate: Bool = true
    var agreedToCodeOfConduct: Bool = false
    var specialNotes: String = ""

    // MARK: - Declarative Validation Properties (R3 & R4)

    var isNameValid: Bool {
        fullName.trimmingCharacters(in: .whitespaces).count >= 2
    }

    var isEmailValid: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        return trimmed.contains("@") && trimmed.contains(".") && trimmed.count >= 5
    }

    var isOrganizationValid: Bool {
        !organization.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isFormComplete: Bool {
        isNameValid && isEmailValid && isOrganizationValid && agreedToCodeOfConduct
    }
}
