//
//  SecondViewController.swift
//  lab-4b
//
//  Created by Raghav Gupta on 14/11/26.
//

import UIKit

class SecondViewController: UIViewController {

    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let backButton = UIButton(type: .system)
    let logTitleLabel = UILabel()
    let logTextView = UITextView()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        LifecycleLogger.shared.log("SecondVC: viewDidLoad (runs once on load)")

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LifecycleLogger.shared.log("SecondVC: viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LifecycleLogger.shared.log("SecondVC: viewDidAppear")
        updateLogView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LifecycleLogger.shared.log("SecondVC: viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LifecycleLogger.shared.log("SecondVC: viewDidDisappear")
    }

    deinit {
        LifecycleLogger.shared.log("SecondVC: deinit (popped and deallocated)")
    }

    // MARK: - Navigation

    @objc func backButtonTapped() {
        // pop back to Screen 1
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UI Setup

    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Screen 2"

        titleLabel.text = "Screen 2 (Detail Screen)"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        infoLabel.text = "When you tap Back, Screen 1's viewWillAppear runs again and updates its refresh count. But its viewDidLoad will NOT run again because it is already in memory."
        infoLabel.numberOfLines = 0
        infoLabel.font = .systemFont(ofSize: 13)
        infoLabel.textColor = .secondaryLabel
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        backButton.setTitle("←  Back to Screen 1", for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        logTitleLabel.text = "Lifecycle Event Log:"
        logTitleLabel.font = .boldSystemFont(ofSize: 14)
        logTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        logTextView.isEditable = false
        logTextView.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        logTextView.backgroundColor = .secondarySystemBackground
        logTextView.layer.cornerRadius = 8
        logTextView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(backButton)
        view.addSubview(logTitleLabel)
        view.addSubview(logTextView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            backButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            logTitleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            logTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            logTextView.topAnchor.constraint(equalTo: logTitleLabel.bottomAnchor, constant: 6),
            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])

        updateLogView()
    }

    func updateLogView() {
        logTextView.text = LifecycleLogger.shared.logs.joined(separator: "\n")
        if !logTextView.text.isEmpty {
            let bottom = NSRange(location: logTextView.text.count - 1, length: 1)
            logTextView.scrollRangeToVisible(bottom)
        }
    }
}
