//
//  TaskListView.swift
//  lab-4a (MVC)
//
//  Created by Raghav Gupta on 12/11/26.
//

import UIKit

// view - only handles UI layout and controls
class MVCTaskListView: UIView {

    let titleLabel = UILabel()
    let taskTextField = UITextField()
    let addButton = UIButton(type: .system)
    let errorLabel = UILabel()
    let filterSegment = UISegmentedControl(items: MVCTaskFilter.allCases.map { $0.title })
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        // title
        titleLabel.text = "Task List (MVC)"
        titleLabel.font = .boldSystemFont(ofSize: 26)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // input field
        taskTextField.placeholder = "Enter new task..."
        taskTextField.borderStyle = .roundedRect
        taskTextField.translatesAutoresizingMaskIntoConstraints = false

        // add button
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        // error label
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 13)
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        // filter control
        filterSegment.selectedSegmentIndex = 0
        filterSegment.translatesAutoresizingMaskIntoConstraints = false

        // table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(taskTextField)
        addSubview(addButton)
        addSubview(errorLabel)
        addSubview(filterSegment)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            taskTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            taskTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            taskTextField.heightAnchor.constraint(equalToConstant: 40),

            addButton.centerYAnchor.constraint(equalTo: taskTextField.centerYAnchor),
            addButton.leadingAnchor.constraint(equalTo: taskTextField.trailingAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 60),

            errorLabel.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 6),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            filterSegment.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 12),
            filterSegment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            filterSegment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: filterSegment.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
