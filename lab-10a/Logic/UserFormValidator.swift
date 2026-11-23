//
//  UserFormValidator.swift
//  lab-10a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10A
//  Form validation rules for user registration with normal, boundary, and invalid checks.
//

import Foundation

enum FormValidationError: String, Error, Equatable {
    case nameTooShort = "Full name must be at least 2 characters."
    case invalidEmailFormat = "Please enter a valid email containing '@' and a domain."
    case underAgeRequirement = "Applicant must be at least 18 years old."
    case passwordTooWeak = "Password must be at least 8 characters and contain a number."
}

struct UserFormValidator {

    static func validateName(_ name: String) -> Result<String, FormValidationError> {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        // Boundary: length exactly 2 is valid; 1 is invalid
        if trimmed.count >= 2 {
            return .success(trimmed)
        } else {
            return .failure(.nameTooShort)
        }
    }

    static func validateEmail(_ email: String) -> Result<String, FormValidationError> {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        // Normal & Invalid: must have '@', '.', and sufficient length
        if trimmed.contains("@") && trimmed.contains(".") && trimmed.count >= 5 && !trimmed.hasPrefix("@") {
            return .success(trimmed)
        } else {
            return .failure(.invalidEmailFormat)
        }
    }

    static func validateAge(_ age: Int) -> Result<Int, FormValidationError> {
        // Boundary: exactly 18 is valid; 17 is invalid; negative is invalid
        if age >= 18 {
            return .success(age)
        } else {
            return .failure(.underAgeRequirement)
        }
    }

    static func validatePassword(_ password: String) -> Result<String, FormValidationError> {
        let hasNumber = password.contains(where: { $0.isNumber })
        // Boundary: 8 characters with number is valid; 7 is invalid
        if password.count >= 8 && hasNumber {
            return .success(password)
        } else {
            return .failure(.passwordTooWeak)
        }
    }
}
