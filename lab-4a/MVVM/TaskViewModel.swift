//
//  TaskViewModel.swift
//  lab-4a (MVVM)
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation
import Combine

// view model - holds state and connects model + validator to view
class TaskViewModel: ObservableObject {

    @Published var tasks: [TaskItem]
    @Published var newTitle: String = ""
    @Published var selectedFilter: TaskFilter = .all
    @Published var errorMessage: String? = nil

    init(initialTasks: [TaskItem] = [
        TaskItem(title: "Learn MVC", isCompleted: true),
        TaskItem(title: "Build MVVM app", isCompleted: false)
    ]) {
        self.tasks = initialTasks
    }

    // filtered list for UI
    var filteredTasks: [TaskItem] {
        return TaskValidator.filter(tasks, by: selectedFilter)
    }

    // add task using validator
    func addTask() {
        do {
            let validTitle = try TaskValidator.validate(title: newTitle, existingTasks: tasks)
            tasks.append(TaskItem(title: validTitle))
            newTitle = ""
            errorMessage = nil
        } catch let error as TaskValidationError {
            errorMessage = error.message
        } catch {
            errorMessage = "Something went wrong"
        }
    }

    // toggle complete
    func toggleComplete(task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    // delete by id
    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    // delete from SwiftUI List swipe
    func deleteTasks(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredTasks[$0] }
        for item in itemsToDelete {
            deleteTask(id: item.id)
        }
    }
}
