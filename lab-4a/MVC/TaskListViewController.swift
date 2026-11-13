//
//  TaskListViewController.swift
//  lab-4a (MVC)
//
//  Created by Raghav Gupta on 12/11/26.
//

import UIKit

// controller - connects model (MVCTaskStore) and view (MVCTaskListView)
class TaskListViewController: UIViewController {

    private let taskView = MVCTaskListView()
    private let store = MVCTaskStore()
    private var currentFilter: MVCTaskFilter = .all

    private var visibleTasks: [MVCTask] {
        return store.filteredTasks(by: currentFilter)
    }

    override func loadView() {
        view = taskView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        taskView.tableView.dataSource = self
        taskView.tableView.delegate = self

        // wire actions
        taskView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        taskView.filterSegment.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
    }

    @objc private func addTapped() {
        let text = taskView.taskTextField.text ?? ""

        if let error = store.addTask(title: text) {
            taskView.errorLabel.text = error
            taskView.errorLabel.isHidden = false
        } else {
            taskView.errorLabel.isHidden = true
            taskView.taskTextField.text = ""
            taskView.tableView.reloadData()
        }
    }

    @objc private func filterChanged() {
        let index = taskView.filterSegment.selectedSegmentIndex
        currentFilter = MVCTaskFilter(rawValue: index) ?? .all
        taskView.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & Delegate

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = visibleTasks[indexPath.row]

        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        cell.textLabel?.textColor = task.isCompleted ? .secondaryLabel : .label

        return cell
    }

    // tap row to toggle complete
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = visibleTasks[indexPath.row]
        store.toggleTask(id: task.id)
        tableView.reloadData()
    }

    // swipe to delete
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = visibleTasks[indexPath.row]
            store.deleteTask(id: task.id)
            tableView.reloadData()
        }
    }
}
