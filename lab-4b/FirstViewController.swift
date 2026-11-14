//
//  FirstViewController.swift
//  lab-4b
//
//  Created by Raghav Gupta on 14/11/26.
//

import UIKit

class FirstViewController: UIViewController {

    let titleLabel = UILabel()
    let refreshLabel = UILabel()
    let draftTextField = UITextField()
    let draftStatusLabel = UILabel()
    let nextButton = UIButton(type: .system)
    let logTitleLabel = UILabel()
    let logTextView = UITextView()

    var refreshCount = 0

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        LifecycleLogger.shared.log("FirstVC: viewDidLoad (runs once on load)")

        setupUI()
        setupDraftPersistence()
        restoreDraft()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LifecycleLogger.shared.log("FirstVC: viewWillAppear (runs every time screen appears)")

        // lightweight refresh:
        // viewDidLoad only runs once. When returning from Screen 2,
        // viewWillAppear fires again, so refreshed data stays up to date.
        performLightweightRefresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LifecycleLogger.shared.log("FirstVC: viewDidAppear")
        updateLogView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LifecycleLogger.shared.log("FirstVC: viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LifecycleLogger.shared.log("FirstVC: viewDidDisappear")
    }

    // MARK: - Lightweight Refresh

    func performLightweightRefresh() {
        refreshCount += 1
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: Date())

        refreshLabel.text = "Refresh Count: \(refreshCount) (Last: \(time))"
    }

    // MARK: - Extension: Draft Persistence

    func setupDraftPersistence() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveDraft),
            name: NSNotification.Name("SaveDraftNotification"),
            object: nil
        )
    }

    @objc func saveDraft() {
        let text = draftTextField.text ?? ""
        UserDefaults.standard.set(text, forKey: "saved_draft")
        draftStatusLabel.text = "Draft saved on background: \"\(text)\""
        LifecycleLogger.shared.log("FirstVC: Draft saved to UserDefaults")
    }

    func restoreDraft() {
        if let saved = UserDefaults.standard.string(forKey: "saved_draft"), !saved.isEmpty {
            draftTextField.text = saved
            draftStatusLabel.text = "Draft restored from UserDefaults"
            LifecycleLogger.shared.log("FirstVC: Draft restored (\"\(saved)\")")
        } else {
            draftStatusLabel.text = "No saved draft"
        }
    }

    // MARK: - Navigation

    @objc func nextButtonTapped() {
        let secondVC = SecondViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }

    // MARK: - UI Setup

    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Screen 1"

        // title label
        titleLabel.text = "Screen 1 (Home)"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // refresh label
        refreshLabel.text = "Refresh Count: 0"
        refreshLabel.font = .systemFont(ofSize: 14)
        refreshLabel.textColor = .systemBlue
        refreshLabel.translatesAutoresizingMaskIntoConstraints = false

        // draft input (extension)
        draftTextField.placeholder = "Type draft here (auto-saved on background)..."
        draftTextField.borderStyle = .roundedRect
        draftTextField.translatesAutoresizingMaskIntoConstraints = false

        // draft status
        draftStatusLabel.font = .systemFont(ofSize: 12)
        draftStatusLabel.textColor = .secondaryLabel
        draftStatusLabel.translatesAutoresizingMaskIntoConstraints = false

        // next button
        nextButton.setTitle("Go to Screen 2  →", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        // log title
        logTitleLabel.text = "Lifecycle Event Log:"
        logTitleLabel.font = .boldSystemFont(ofSize: 14)
        logTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // log text view
        logTextView.isEditable = false
        logTextView.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        logTextView.backgroundColor = .secondarySystemBackground
        logTextView.layer.cornerRadius = 8
        logTextView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(refreshLabel)
        view.addSubview(draftTextField)
        view.addSubview(draftStatusLabel)
        view.addSubview(nextButton)
        view.addSubview(logTitleLabel)
        view.addSubview(logTextView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            refreshLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            refreshLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            refreshLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            draftTextField.topAnchor.constraint(equalTo: refreshLabel.bottomAnchor, constant: 12),
            draftTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            draftTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            draftTextField.heightAnchor.constraint(equalToConstant: 38),

            draftStatusLabel.topAnchor.constraint(equalTo: draftTextField.bottomAnchor, constant: 4),
            draftStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            draftStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nextButton.topAnchor.constraint(equalTo: draftStatusLabel.bottomAnchor, constant: 12),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 40),

            logTitleLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 16),
            logTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            logTextView.topAnchor.constraint(equalTo: logTitleLabel.bottomAnchor, constant: 6),
            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])

        LifecycleLogger.shared.onLogUpdate = { [weak self] in
            self?.updateLogView()
        }
    }

    func updateLogView() {
        logTextView.text = LifecycleLogger.shared.logs.joined(separator: "\n")
        if !logTextView.text.isEmpty {
            let bottom = NSRange(location: logTextView.text.count - 1, length: 1)
            logTextView.scrollRangeToVisible(bottom)
        }
    }
}
