//
//  task1.swift
//  assessment-m2
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training - Milestone 2
//  Task 1: Refactor Task List Screen to MVVM and Test ViewModel Logic
//

import Foundation

// ==========================================
// MARK: - 1. MODEL
// ==========================================

// Pure data model - holds task data and has no UI dependencies
struct TaskItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var priority: Priority
    var isCompleted: Bool
    let createdAt: Date
    
    enum Priority: String, CaseIterable, Comparable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var rank: Int {
            switch self {
            case .low: return 1
            case .medium: return 2
            case .high: return 3
            }
        }
        
        static func < (lhs: Priority, rhs: Priority) -> Bool {
            return lhs.rank < rhs.rank
        }
    }
    
    init(id: UUID = UUID(), title: String, priority: Priority = .medium, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.priority = priority
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

// ==========================================
// MARK: - 2. FILTER & SORT OPTIONS
// ==========================================

enum TaskFilter {
    case all
    case pending
    case completed
}

enum TaskSortOption {
    case byDate
    case byPriority
}

// ==========================================
// MARK: - 3. VIEW MODEL
// ==========================================

// The ViewModel handles all business logic, validation, filtering, and data manipulation.
// Notice: It does NOT import UIKit. This makes it fast and completely testable in unit tests.
class TaskListViewModel {
    
    // Private backing store for all tasks
    private(set) var tasks: [TaskItem] = []
    
    // UI State
    var currentFilter: TaskFilter = .all
    var currentSort: TaskSortOption = .byDate
    var errorMessage: String? = nil
    
    // Closure for UI data binding (notifies view when data changes)
    var onDataChanged: (() -> Void)?
    
    init(initialTasks: [TaskItem] = []) {
        self.tasks = initialTasks
    }
    
    // MARK: - Filtered and Sorted Computed Property
    
    var visibleTasks: [TaskItem] {
        // 1. Apply filter
        let filtered: [TaskItem]
        switch currentFilter {
        case .all:
            filtered = tasks
        case .pending:
            filtered = tasks.filter { !$0.isCompleted }
        case .completed:
            filtered = tasks.filter { $0.isCompleted }
        }
        
        // 2. Apply sorting
        switch currentSort {
        case .byDate:
            return filtered.sorted { $0.createdAt > $1.createdAt }
        case .byPriority:
            return filtered.sorted { $0.priority > $1.priority }
        }
    }
    
    // MARK: - Counts and Stats
    
    var totalCount: Int {
        return tasks.count
    }
    
    var pendingCount: Int {
        return tasks.filter { !$0.isCompleted }.count
    }
    
    var completedCount: Int {
        return tasks.filter { $0.isCompleted }.count
    }
    
    // MARK: - Business Logic: Add Task (with validation)
    
    @discardableResult
    func addTask(title: String, priority: TaskItem.Priority = .medium) -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validation Rule 1: Cannot be empty
        if trimmedTitle.isEmpty {
            errorMessage = "Task title cannot be empty."
            return false
        }
        
        // Validation Rule 2: Minimum 3 characters
        if trimmedTitle.count < 3 {
            errorMessage = "Task title must be at least 3 characters long."
            return false
        }
        
        // Validation Rule 3: Maximum 50 characters
        if trimmedTitle.count > 50 {
            errorMessage = "Task title cannot exceed 50 characters."
            return false
        }
        
        // Validation passed: create and add task
        let newTask = TaskItem(title: trimmedTitle, priority: priority)
        tasks.append(newTask)
        errorMessage = nil
        onDataChanged?()
        return true
    }
    
    // MARK: - Business Logic: Toggle Task
    
    @discardableResult
    func toggleTask(id: UUID) -> Bool {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Task not found."
            return false
        }
        
        tasks[index].isCompleted.toggle()
        errorMessage = nil
        onDataChanged?()
        return true
    }
    
    // MARK: - Business Logic: Delete Task
    
    @discardableResult
    func deleteTask(id: UUID) -> Bool {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Task not found."
            return false
        }
        
        tasks.remove(at: index)
        errorMessage = nil
        onDataChanged?()
        return true
    }
    
    // MARK: - Business Logic: Clear Completed Tasks
    
    func clearCompletedTasks() {
        tasks.removeAll { $0.isCompleted }
        errorMessage = nil
        onDataChanged?()
    }
}

// ==========================================
// MARK: - 4. MOCK VIEW (Demonstrating MVVM Binding)
// ==========================================

class MockTaskListView {
    let viewModel: TaskListViewModel
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    private func bindViewModel() {
        // Simulates ViewController listening to ViewModel state changes
        viewModel.onDataChanged = { [weak self] in
            self?.render()
        }
    }
    
    func render() {
        print("\n--- [UI RENDER: Task List Screen] ---")
        print("Total: \(viewModel.totalCount) | Pending: \(viewModel.pendingCount) | Completed: \(viewModel.completedCount)")
        for task in viewModel.visibleTasks {
            let status = task.isCompleted ? "[X]" : "[ ]"
            print("\(status) [\(task.priority.rawValue)] \(task.title)")
        }
        if let err = viewModel.errorMessage {
            print("Alert banner: \(err)")
        }
        print("-------------------------------------\n")
    }
}

// ==========================================
// MARK: - 5. UNIT TEST SUITE FOR VIEW MODEL
// ==========================================

class TaskListViewModelTests {
    private var passedCount = 0
    private var failedCount = 0
    
    func runAllTests() {
        print("==================================================")
        print("RUNNING UNIT TESTS FOR TaskListViewModel (MVVM)")
        print("==================================================")
        
        testAddTask_ValidInput_AddsTaskSuccessfully()
        testAddTask_EmptyTitle_FailsValidation()
        testAddTask_TooShortTitle_FailsValidation()
        testToggleTask_FlipsCompletionStatus()
        testDeleteTask_RemovesTaskFromList()
        testFilter_ShowsOnlyPendingOrCompleted()
        testSort_SortsByPriorityCorrectly()
        testClearCompleted_RemovesOnlyCompletedTasks()
        
        print("\n==================================================")
        print("TEST SUMMARY: \(passedCount) Passed | \(failedCount) Failed")
        print("==================================================")
        assert(failedCount == 0, "Some unit tests failed!")
    }
    
    private func recordResult(testName: String, success: Bool, details: String = "") {
        if success {
            passedCount += 1
            print("  ✓ [PASS] \(testName)")
        } else {
            failedCount += 1
            print("  ✗ [FAIL] \(testName) - \(details)")
        }
    }
    
    // Test 1: Adding valid task
    func testAddTask_ValidInput_AddsTaskSuccessfully() {
        let vm = TaskListViewModel()
        let result = vm.addTask(title: "Complete Module 7 Lab", priority: .high)
        
        let success = result == true &&
                      vm.tasks.count == 1 &&
                      vm.tasks.first?.title == "Complete Module 7 Lab" &&
                      vm.tasks.first?.priority == .high &&
                      vm.errorMessage == nil
        
        recordResult(testName: "testAddTask_ValidInput_AddsTaskSuccessfully", success: success)
    }
    
    // Test 2: Validation on empty title
    func testAddTask_EmptyTitle_FailsValidation() {
        let vm = TaskListViewModel()
        let result = vm.addTask(title: "   ")
        
        let success = result == false &&
                      vm.tasks.isEmpty &&
                      vm.errorMessage == "Task title cannot be empty."
        
        recordResult(testName: "testAddTask_EmptyTitle_FailsValidation", success: success)
    }
    
    // Test 3: Validation on short title
    func testAddTask_TooShortTitle_FailsValidation() {
        let vm = TaskListViewModel()
        let result = vm.addTask(title: "Hi")
        
        let success = result == false &&
                      vm.tasks.isEmpty &&
                      vm.errorMessage == "Task title must be at least 3 characters long."
        
        recordResult(testName: "testAddTask_TooShortTitle_FailsValidation", success: success)
    }
    
    // Test 4: Toggle task status
    func testToggleTask_FlipsCompletionStatus() {
        let vm = TaskListViewModel()
        vm.addTask(title: "Review Auto Layout constraints", priority: .medium)
        guard let taskId = vm.tasks.first?.id else {
            recordResult(testName: "testToggleTask_FlipsCompletionStatus", success: false, details: "Task not created")
            return
        }
        
        // Initial state is pending (false)
        let initialPending = vm.tasks.first?.isCompleted == false
        
        // Toggle once -> true
        vm.toggleTask(id: taskId)
        let toggledToTrue = vm.tasks.first?.isCompleted == true
        
        // Toggle again -> false
        vm.toggleTask(id: taskId)
        let toggledBackToFalse = vm.tasks.first?.isCompleted == false
        
        let success = initialPending && toggledToTrue && toggledBackToFalse
        recordResult(testName: "testToggleTask_FlipsCompletionStatus", success: success)
    }
    
    // Test 5: Delete task
    func testDeleteTask_RemovesTaskFromList() {
        let vm = TaskListViewModel()
        vm.addTask(title: "Task 1", priority: .low)
        vm.addTask(title: "Task 2", priority: .high)
        
        guard let idToDelete = vm.tasks.first?.id else {
            recordResult(testName: "testDeleteTask_RemovesTaskFromList", success: false, details: "Setup failed")
            return
        }
        
        let deleted = vm.deleteTask(id: idToDelete)
        let success = deleted && vm.tasks.count == 1 && vm.tasks.first?.title == "Task 2"
        recordResult(testName: "testDeleteTask_RemovesTaskFromList", success: success)
    }
    
    // Test 6: Filter logic
    func testFilter_ShowsOnlyPendingOrCompleted() {
        let vm = TaskListViewModel()
        vm.addTask(title: "Write Swift models", priority: .medium)
        vm.addTask(title: "Setup ViewController", priority: .high)
        vm.addTask(title: "Run Unit Tests", priority: .low)
        
        // Mark 2nd task as completed
        let secondId = vm.tasks[1].id
        vm.toggleTask(id: secondId)
        
        // Filter: Pending
        vm.currentFilter = .pending
        let pendingMatches = vm.visibleTasks.count == 2 && vm.visibleTasks.allSatisfy { !$0.isCompleted }
        
        // Filter: Completed
        vm.currentFilter = .completed
        let completedMatches = vm.visibleTasks.count == 1 && vm.visibleTasks.allSatisfy { $0.isCompleted }
        
        // Filter: All
        vm.currentFilter = .all
        let allMatches = vm.visibleTasks.count == 3
        
        let success = pendingMatches && completedMatches && allMatches
        recordResult(testName: "testFilter_ShowsOnlyPendingOrCompleted", success: success)
    }
    
    // Test 7: Sort by Priority
    func testSort_SortsByPriorityCorrectly() {
        let vm = TaskListViewModel()
        vm.addTask(title: "Low task", priority: .low)
        vm.addTask(title: "High task", priority: .high)
        vm.addTask(title: "Medium task", priority: .medium)
        
        vm.currentSort = .byPriority
        let visible = vm.visibleTasks
        
        let success = visible.count == 3 &&
                      visible[0].priority == .high &&
                      visible[1].priority == .medium &&
                      visible[2].priority == .low
        
        recordResult(testName: "testSort_SortsByPriorityCorrectly", success: success)
    }
    
    // Test 8: Clear completed tasks
    func testClearCompleted_RemovesOnlyCompletedTasks() {
        let vm = TaskListViewModel()
        vm.addTask(title: "Task A", priority: .medium)
        vm.addTask(title: "Task B", priority: .medium)
        vm.addTask(title: "Task C", priority: .medium)
        
        // Complete Task A and Task C
        vm.toggleTask(id: vm.tasks[0].id)
        vm.toggleTask(id: vm.tasks[2].id)
        
        vm.clearCompletedTasks()
        
        let success = vm.tasks.count == 1 &&
                      vm.tasks[0].title == "Task B" &&
                      vm.completedCount == 0 &&
                      vm.pendingCount == 1
        
        recordResult(testName: "testClearCompleted_RemovesOnlyCompletedTasks", success: success)
    }
}

// ==========================================
// MARK: - 6. DEMO EXECUTION
// ==========================================

print("--- DEMONSTRATING MVVM TASK LIST WITH UI BINDING ---")
let viewModel = TaskListViewModel()
let mockView = MockTaskListView(viewModel: viewModel)

// User adds tasks via UI
viewModel.addTask(title: "Study MVVM Architecture", priority: .high)
viewModel.addTask(title: "Implement Async/Await Network Call", priority: .high)
viewModel.addTask(title: "Prepare Viva comparison notes", priority: .medium)

// User checks off a task
if let firstTaskId = viewModel.tasks.first?.id {
    print("User toggles first task as completed...")
    viewModel.toggleTask(id: firstTaskId)
}

// Run the full unit testing suite
let tester = TaskListViewModelTests()
tester.runAllTests()
