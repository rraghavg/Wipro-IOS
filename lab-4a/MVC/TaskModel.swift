//
//  TaskModel.swift
//  lab-4a (MVC)
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// model
struct MVCTask {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

// filter options
enum MVCTaskFilter: Int, CaseIterable {
    case all = 0
    case pending = 1
    case completed = 2

    var title: String {
        switch self {
        case .all: return "All"
        case .pending: return "Pending"
        case .completed: return "Done"
        }
    }
}

// model store - holds tasks, validation and filtering logic
class MVCTaskStore {
    private(set) var tasks: [MVCTask] = [
        MVCTask(title: "Learn MVC", isCompleted: true),
        MVCTask(title: "Build MVVM app", isCompleted: false)
    ]

    // validate and add task
    func addTask(title: String) -> String? {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "Task title cannot be empty"
        }
        tasks.append(MVCTask(title: trimmed))
        return nil
    }

    // toggle complete
    func toggleTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    // delete task
    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    // filter tasks
    func filteredTasks(by filter: MVCTaskFilter) -> [MVCTask] {
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
