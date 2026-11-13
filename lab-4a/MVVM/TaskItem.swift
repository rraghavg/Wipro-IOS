//
//  TaskItem.swift
//  lab-4a (MVVM)
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// model
struct TaskItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

// filter options
enum TaskFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case pending = "Pending"
    case completed = "Done"

    var id: String { rawValue }
}
