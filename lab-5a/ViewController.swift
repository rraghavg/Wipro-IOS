//
//  ViewController.swift
//  lab-5a
//
//  Created by Raghav Gupta on 16/11/26.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI Elements

    let titleLabel = UILabel()
    let statusLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let slowOpButton = UIButton(type: .system)
    let delayedOpButton = UIButton(type: .system)
    let concurrentOpButton = UIButton(type: .system)
    let responsivenessButton = UIButton(type: .system)
    let logTextView = UITextView()

    var tapCount = 0
    var isRunning = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Lab 5A: GCD & Queues"

        setupUI()
        log("UI", "ViewController loaded. Ready to execute tasks.")
    }

    // MARK: - UI Setup

    private func setupUI() {
        titleLabel.text = "GCD & Main-Thread UI"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center

        statusLabel.text = "Status: Idle"
        statusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemGreen

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemBlue

        slowOpButton.setTitle("1. Run Slow Operation (Background Queue)", for: .normal)
        slowOpButton.backgroundColor = .systemBlue
        slowOpButton.setTitleColor(.white, for: .normal)
        slowOpButton.layer.cornerRadius = 8
        slowOpButton.addTarget(self, action: #selector(runSlowOperation), for: .touchUpInside)

        delayedOpButton.setTitle("2. Delayed Response (asyncAfter 2.5s)", for: .normal)
        delayedOpButton.backgroundColor = .systemPurple
        delayedOpButton.setTitleColor(.white, for: .normal)
        delayedOpButton.layer.cornerRadius = 8
        delayedOpButton.addTarget(self, action: #selector(runDelayedOperation), for: .touchUpInside)

        concurrentOpButton.setTitle("3. Concurrent Tasks (DispatchGroup Extension)", for: .normal)
        concurrentOpButton.backgroundColor = .systemTeal
        concurrentOpButton.setTitleColor(.white, for: .normal)
        concurrentOpButton.layer.cornerRadius = 8
        concurrentOpButton.addTarget(self, action: #selector(runConcurrentOperations), for: .touchUpInside)

        responsivenessButton.setTitle("Test Main Thread: Taps = 0", for: .normal)
        responsivenessButton.backgroundColor = .secondarySystemFill
        responsivenessButton.layer.cornerRadius = 8
        responsivenessButton.addTarget(self, action: #selector(handleTapCounter), for: .touchUpInside)

        logTextView.isEditable = false
        logTextView.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        logTextView.backgroundColor = .secondarySystemBackground
        logTextView.layer.cornerRadius = 8
        logTextView.layer.borderWidth = 1
        logTextView.layer.borderColor = UIColor.separator.cgColor

        let buttonStack = UIStackView(arrangedSubviews: [
            titleLabel,
            statusLabel,
            activityIndicator,
            slowOpButton,
            delayedOpButton,
            concurrentOpButton,
            responsivenessButton
        ])
        buttonStack.axis = .vertical
        buttonStack.spacing = 10

        [buttonStack, logTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            slowOpButton.heightAnchor.constraint(equalToConstant: 42),
            delayedOpButton.heightAnchor.constraint(equalToConstant: 42),
            concurrentOpButton.heightAnchor.constraint(equalToConstant: 42),
            responsivenessButton.heightAnchor.constraint(equalToConstant: 36),

            logTextView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),
            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Task 4: Loading State & Duplicate Submission Lock

    private func setLoading(_ loading: Bool, status: String) {
        isRunning = loading
        statusLabel.text = "Status: \(status)"
        statusLabel.textColor = loading ? .systemOrange : .systemGreen

        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        // Disable buttons to strictly prevent duplicate submission while work is running
        slowOpButton.isEnabled = !loading
        delayedOpButton.isEnabled = !loading
        concurrentOpButton.isEnabled = !loading

        slowOpButton.alpha = loading ? 0.5 : 1.0
        delayedOpButton.alpha = loading ? 0.5 : 1.0
        concurrentOpButton.alpha = loading ? 0.5 : 1.0
    }

    // MARK: - Task 1 & 2: Slow Operation on Global Queue & Main Queue UI Update

    @objc private func runSlowOperation() {
        guard !isRunning else { return }
        setLoading(true, status: "Working in background...")
        log("UI", "Button tapped: starting slow background task")

        // Dispatch heavy / blocking work to background queue
        DispatchQueue.global(qos: .userInitiated).async {
            self.log("BACKGROUND", "Simulating heavy calculation on global queue...")

            // Heavy simulated computation without blocking main thread
            var result: UInt64 = 0
            for i in 1...10_000_000 {
                result = result &+ UInt64(i * i)
            }
            Thread.sleep(forTimeInterval: 3.0)

            self.log("BACKGROUND", "Background computation done. Returning to main thread.")

            // UI updates MUST be dispatched back to the main queue
            DispatchQueue.main.async {
                self.log("MAIN", "Updating UI on main thread safely.")
                self.setLoading(false, status: "Done! (Result: \(result & 0xFFFF))")
            }
        }
    }

    // MARK: - Task 3: Delayed Response via DispatchQueue.asyncAfter

    @objc private func runDelayedOperation() {
        guard !isRunning else { return }
        setLoading(true, status: "Waiting for delayed response...")
        log("UI", "Button tapped: scheduling asyncAfter response")

        // Simulate delayed response without blocking any thread
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.log("ASYNC-AFTER", "Timer fired on main queue after 2.5s.")
            self.setLoading(false, status: "Received delayed server response (200 OK)")
        }
    }

    // MARK: - Extension: Run Two Independent Operations Concurrently (DispatchGroup)

    @objc private func runConcurrentOperations() {
        guard !isRunning else { return }
        setLoading(true, status: "Running 2 concurrent tasks...")
        log("UI", "Button tapped: starting 2 concurrent operations")

        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "com.wipro.collector.serial")
        var collectedResults: [String] = []

        // Task A
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            self.log("TASK-A", "Task A (Fetch User Profile) started on background queue.")
            Thread.sleep(forTimeInterval: 2.0)
            serialQueue.sync {
                collectedResults.append("Profile: Raghav")
            }
            self.log("TASK-A", "Task A completed.")
            group.leave()
        }

        // Task B
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            self.log("TASK-B", "Task B (Fetch Notifications) started on background queue.")
            Thread.sleep(forTimeInterval: 1.5)
            serialQueue.sync {
                collectedResults.append("Notifications: 3 unread")
            }
            self.log("TASK-B", "Task B completed.")
            group.leave()
        }

        // Safely notify on main queue when both tasks finish
        group.notify(queue: .main) {
            let combined = collectedResults.joined(separator: ", ")
            self.log("MAIN", "DispatchGroup notified main queue. Both tasks finished.")
            self.setLoading(false, status: "Finished: [\(combined)]")
        }
    }

    // MARK: - Responsiveness Test

    @objc private func handleTapCounter() {
        tapCount += 1
        responsivenessButton.setTitle("Test Main Thread: Taps = \(tapCount)", for: .normal)
        log("UI", "Tapped counter (count = \(tapCount)). Main thread is totally responsive!")
    }

    // MARK: - Task 5: Thread / Queue Logging

    private func log(_ tag: String, _ message: String) {
        let isMain = Thread.isMainThread
        let threadTag = isMain ? "🟢 [MAIN THREAD]" : "🔵 [BG THREAD]  "
        let queueLabel = String(cString: __dispatch_queue_get_label(nil))

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())

        let entry = "[\(timestamp)] \(threadTag) [Queue: \(queueLabel)] [\(tag)] \(message)"

        // Print to Xcode debugger console
        print(entry)

        // Update on-screen log view on main thread
        if Thread.isMainThread {
            self.appendLog(entry)
        } else {
            DispatchQueue.main.async {
                self.appendLog(entry)
            }
        }
    }

    private func appendLog(_ text: String) {
        logTextView.text.append(text + "\n")
        let bottom = NSRange(location: logTextView.text.count - 1, length: 1)
        logTextView.scrollRangeToVisible(bottom)
    }
}
