//
//  CourseListViewController.swift
//  lab-7b
//
//  List screen displaying courses, handling navigation controller push transitions,
//  and providing an empty state view with a reusable custom table cell.
//

import UIKit

class CourseListViewController: UIViewController {

    // MARK: - Properties
    private var courses: [Course] = Course.sampleCourses
    private var isEmptyStateActive: Bool = false

    // MARK: - UI Components
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CourseTableViewCell.self, forCellReuseIdentifier: CourseTableViewCell.reuseIdentifier)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 90
        return tv
    }()

    // Extension: Custom Empty State View
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let emptyStateIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "books.vertical.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let emptyStateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Courses Available"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let emptyStateMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There are currently no active course batches. Tap below to reload the course directory."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var reloadButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Restore Course List"
        config.image = UIImage(systemName: "arrow.clockwise")
        config.imagePadding = 6
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .capsule

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(toggleEmptyState), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Course Catalog"
        view.backgroundColor = .systemGroupedBackground

        setupNavigationBar()
        setupTableView()
        setupEmptyState()
    }

    private func setupNavigationBar() {
        let toggleButton = UIBarButtonItem(
            title: "Toggle Empty",
            style: .plain,
            target: self,
            action: #selector(toggleEmptyState)
        )
        navigationItem.rightBarButtonItem = toggleButton
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyState() {
        view.addSubview(emptyStateView)

        let stack = UIStackView(arrangedSubviews: [
            emptyStateIcon,
            emptyStateTitleLabel,
            emptyStateMessageLabel,
            reloadButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .center

        emptyStateView.addSubview(stack)

        NSLayoutConstraint.activate([
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            emptyStateIcon.widthAnchor.constraint(equalToConstant: 64),
            emptyStateIcon.heightAnchor.constraint(equalToConstant: 64),

            stack.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),

            reloadButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    // MARK: - Actions
    @objc private func toggleEmptyState() {
        isEmptyStateActive.toggle()
        if isEmptyStateActive {
            courses = []
            tableView.isHidden = true
            emptyStateView.isHidden = false
            navigationItem.rightBarButtonItem?.title = "Show Courses"
        } else {
            courses = Course.sampleCourses
            tableView.isHidden = false
            emptyStateView.isHidden = true
            navigationItem.rightBarButtonItem?.title = "Toggle Empty"
            tableView.reloadData()
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension CourseListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Safe cell dequeueing without fatal force casts
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CourseTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CourseTableViewCell else {
            return UITableViewCell()
        }

        guard indexPath.row < courses.count else {
            return cell
        }

        let course = courses[indexPath.row]
        cell.configure(with: course)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath.row < courses.count else { return }
        let selectedCourse = courses[indexPath.row]

        // Task 2: Pass selected model object directly (no global variables)
        let detailVC = CourseDetailViewController(course: selectedCourse)

        // Task 3: Use navigation controller push
        guard let navController = self.navigationController else {
            // Defensive fallback if navigation controller is somehow absent
            let modalNav = UINavigationController(rootViewController: detailVC)
            present(modalNav, animated: true)
            return
        }

        navController.pushViewController(detailVC, animated: true)
    }
}
