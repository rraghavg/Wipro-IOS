//
//  ViewController.swift
//  lab-5b
//
//  Created by Raghav Gupta on 17/11/26.
//

import UIKit

// MARK: - Model

struct Course: Identifiable {
    let id: String
    let title: String
    let duration: String
    let instructor: String
}

// MARK: - View State

enum ViewState {
    case idle
    case loading
    case success([Course])
    case empty
    case failure(String)
    case cancelled
}

// MARK: - Simulation Scenario

enum FetchScenario: Int {
    case success = 0
    case empty = 1
    case failure = 2
}

class ViewController: UIViewController {

    // MARK: - UI Elements

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let scenarioControl = UISegmentedControl(items: ["Success", "Empty", "Failure"])
    private let fetchButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let retryButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let statusLabel = UILabel()
    private let tableView = UITableView()

    // MARK: - State & Task Reference

    private var currentState: ViewState = .idle {
        didSet {
            renderState(currentState)
        }
    }

    private var courses: [Course] = []
    private var fetchTask: Task<Void, Never>?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lab 5B: async/await & Task"
        view.backgroundColor = .systemBackground

        setupUI()
        renderState(.idle)
    }

    // MARK: - UI Setup

    private func setupUI() {
        titleLabel.text = "Courses Catalog"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center

        subtitleLabel.text = "Demonstrating async/await, Task, 4 States & Cancellation"
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        scenarioControl.selectedSegmentIndex = 0

        fetchButton.setTitle("Fetch Courses", for: .normal)
        fetchButton.backgroundColor = .systemBlue
        fetchButton.setTitleColor(.white, for: .normal)
        fetchButton.layer.cornerRadius = 8
        fetchButton.addTarget(self, action: #selector(handleFetchTapped), for: .touchUpInside)

        cancelButton.setTitle("Cancel Task", for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 8
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        cancelButton.addTarget(self, action: #selector(handleCancelTapped), for: .touchUpInside)

        retryButton.setTitle("🔄 Retry Request", for: .normal)
        retryButton.backgroundColor = .systemOrange
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 8
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(handleFetchTapped), for: .touchUpInside)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemBlue

        statusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.textColor = .secondaryLabel

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CourseCell")
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.separator.cgColor

        let buttonRow = UIStackView(arrangedSubviews: [fetchButton, cancelButton])
        buttonRow.axis = .horizontal
        buttonRow.spacing = 10
        buttonRow.distribution = .fillEqually

        let topStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            scenarioControl,
            buttonRow,
            retryButton,
            activityIndicator,
            statusLabel
        ])
        topStack.axis = .vertical
        topStack.spacing = 10

        [topStack, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            fetchButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            retryButton.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 14),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14)
        ])
    }

    // MARK: - State Rendering

    private func renderState(_ state: ViewState) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
            statusLabel.text = "Select a scenario and tap 'Fetch Courses'."
            statusLabel.textColor = .secondaryLabel
            tableView.isHidden = true
            retryButton.isHidden = true
            fetchButton.isEnabled = true
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5

        case .loading:
            activityIndicator.startAnimating()
            statusLabel.text = "⏳ Loading courses... (Task running)"
            statusLabel.textColor = .systemBlue
            tableView.isHidden = true
            retryButton.isHidden = true
            fetchButton.isEnabled = false
            cancelButton.isEnabled = true
            cancelButton.alpha = 1.0

        case .success(let items):
            activityIndicator.stopAnimating()
            courses = items
            tableView.reloadData()
            tableView.isHidden = false
            statusLabel.text = "✅ Successfully loaded \(items.count) courses."
            statusLabel.textColor = .systemGreen
            retryButton.isHidden = true
            fetchButton.isEnabled = true
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5

        case .empty:
            activityIndicator.stopAnimating()
            courses = []
            tableView.reloadData()
            tableView.isHidden = true
            statusLabel.text = "📭 No courses available (Empty State)."
            statusLabel.textColor = .systemOrange
            retryButton.isHidden = true
            fetchButton.isEnabled = true
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5

        case .failure(let errorMsg):
            activityIndicator.stopAnimating()
            courses = []
            tableView.reloadData()
            tableView.isHidden = true
            statusLabel.text = "❌ Error: \(errorMsg)"
            statusLabel.textColor = .systemRed
            retryButton.isHidden = false // Extension: Retry action
            fetchButton.isEnabled = true
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5

        case .cancelled:
            activityIndicator.stopAnimating()
            statusLabel.text = "🛑 Operation was cancelled by user."
            statusLabel.textColor = .systemPurple
            retryButton.isHidden = false
            fetchButton.isEnabled = true
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
        }
    }

    // MARK: - Action Handlers

    @objc private func handleFetchTapped() {
        let scenario = FetchScenario(rawValue: scenarioControl.selectedSegmentIndex) ?? .success
        startFetch(scenario: scenario)
    }

    @objc private func handleCancelTapped() {
        // Cancel the running Task
        fetchTask?.cancel()
    }

    // MARK: - Task & async/await Integration

    private func startFetch(scenario: FetchScenario) {
        // Cancel any existing in-flight task
        fetchTask?.cancel()

        // 1. Transition UI into Loading state
        currentState = .loading

        // 2. Launch an asynchronous Task on the MainActor
        fetchTask = Task { @MainActor in
            do {
                // Call the throwing async function
                let result = try await fetchCourses(scenario: scenario)

                // Check if result is empty or populated
                if result.isEmpty {
                    self.currentState = .empty
                } else {
                    self.currentState = .success(result)
                }
            } catch is CancellationError {
                // Cooperative cancellation handled
                self.currentState = .cancelled
            } catch {
                // Failure state handled with error message
                self.currentState = .failure(error.localizedDescription)
            }
        }
    }

    // MARK: - Async Function with Cooperative Cancellation Check

    /// Simulates fetching courses asynchronously with latency and cooperative cancellation checks.
    private func fetchCourses(scenario: FetchScenario) async throws -> [Course] {
        // Simulate progressive latency in 0.1s increments to check cancellation cooperatively
        for _ in 1...20 { // 2.0 seconds total delay
            try Task.checkCancellation()
            try await Task.sleep(nanoseconds: 100_000_000)
        }

        switch scenario {
        case .success:
            return [
                Course(id: "CS101", title: "iOS Swift Concurrency", duration: "4 Weeks", instructor: "Raghav Gupta"),
                Course(id: "CS102", title: "Modern UIKit & Autolayout", duration: "3 Weeks", instructor: "Raghav Gupta"),
                Course(id: "CS103", title: "Grand Central Dispatch Deep Dive", duration: "2 Weeks", instructor: "Raghav Gupta"),
                Course(id: "CS104", title: "SwiftUI Architecture & State", duration: "5 Weeks", instructor: "Raghav Gupta")
            ]

        case .empty:
            return []

        case .failure:
            struct NetworkError: LocalizedError {
                var errorDescription: String? { "Failed to reach remote server (HTTP 503 Service Unavailable)" }
            }
            throw NetworkError()
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        let course = courses[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = course.title
        content.secondaryText = "\(course.id) • \(course.duration) • Instructor: \(course.instructor)"
        cell.contentConfiguration = content
        return cell
    }
}
