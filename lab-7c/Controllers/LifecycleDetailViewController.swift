//
//  LifecycleDetailViewController.swift
//  lab-7c
//
//  Secondary view controller used to demonstrate push/pop navigation
//  and observe full UIKit view lifecycle callbacks in the console.
//

import UIKit

class LifecycleDetailViewController: UIViewController {

    private let screenName = "[Screen 2 - Lifecycle Detail]"

    // Summary data passed from primary controller
    var summaryText: String = ""

    // MARK: - UI Elements
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.text = "Navigation & Lifecycle Inspector"
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var dismissButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Pop Back to Controls (Trigger Disappear)"
        config.image = UIImage(systemName: "arrow.uturn.backward.circle.fill")
        config.imagePadding = 6
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .capsule

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()

    // MARK: - View Lifecycle Logging (Task 3)
    override func viewDidLoad() {
        super.viewDidLoad()
        print("⏱ \(timestamp()) \(screenName) 1. viewDidLoad() — View hierarchy loaded into memory.")
        title = "Lifecycle Observation"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .never

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("⏱ \(timestamp()) \(screenName) 2. viewWillAppear(animated: \(animated)) — View is about to be added to window.")
        detailsLabel.text = summaryText.isEmpty ? "No active configuration passed." : summaryText
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("⏱ \(timestamp()) \(screenName) 3. viewDidAppear(animated: \(animated)) — View is now visible on screen and interactive.")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("⏱ \(timestamp()) \(screenName) 4. viewWillDisappear(animated: \(animated)) — View is about to be removed / popped.")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("⏱ \(timestamp()) \(screenName) 5. viewDidDisappear(animated: \(animated)) — View was removed from window hierarchy.")
    }

    deinit {
        print("⏱ \(timestamp()) \(screenName) 6. deinit — Controller deallocated cleanly from memory (no retain cycles).")
    }

    // MARK: - UI Setup
    private func setupLayout() {
        view.addSubview(cardView)

        let stack = UIStackView(arrangedSubviews: [titleLabel, detailsLabel, dismissButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill

        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),

            dismissButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }

    private func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
