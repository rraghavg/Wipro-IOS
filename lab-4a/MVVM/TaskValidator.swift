//
//  TaskValidator.swift
//  lab-4a (MVVM)
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// validation errors
enum TaskValidationError: Error, Equatable {
    case emptyTitle
    case tooShort
    case duplicate

    var message: String {
        switch self {
        case .emptyTitle:
            return "Task title cannot be empty"
        case .tooShort:
            return "Task must be at least 3 characters"
        case .duplicate:
            return "Task already exists"
        }
    }
}

// validation and filtering logic (outside view and view controller)
struct TaskValidator {

    static func validate(title: String, existingTasks: [TaskItem]) throws -> String {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            throw TaskValidationError.emptyTitle
        }

        if trimmed.count < 3 {
            throw TaskValidationError.tooShort
        }

        let exists = existingTasks.contains {
            $0.title.lowercased() == trimmed.lowercased()
        }
        if exists {
            throw TaskValidationError.duplicate
        }

        return trimmed
    }

    static func filter(_ tasks: [TaskItem], by filter: TaskFilter) -> [TaskItem] {
        switch filter {
        case .all:
            return tasks
        case .pending:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter { $0.isCompleted }
        }
    }
}
