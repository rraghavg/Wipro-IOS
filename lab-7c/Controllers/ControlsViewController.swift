//
//  ControlsViewController.swift
//  lab-7c
//
//  Objective: Connect multiple UIKit controls to state changes, update a live summary panel,
//  observe the full view lifecycle during navigation, and handle keyboard layout adjustments.
//

import UIKit

class ControlsViewController: UIViewController {

    private let screenName = "[Screen 1 - ControlsVC]"

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.keyboardDismissMode = .interactive
        return sv
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        return stack
    }()

    // Task 2: Live Summary Panel
    private let summaryCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
        view.layer.cornerRadius = 14
        view.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1.5
        return view
    }()

    private let summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBlue
        label.text = "📋 Live Profile Summary"
        return label
    }()

    private let summaryContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    // Task 1: Five Interactive Controls
    // Control 1: UITextField
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter student name"
        tf.borderStyle = .roundedRect
        tf.text = "Raghav Gupta"
        tf.accessibilityLabel = "Student Name Text Field"
        tf.returnKeyType = .done
        return tf
    }()

    // Control 2: UISegmentedControl
    private let semesterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Year 1", "Year 2", "Year 3", "Year 4"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 2
        sc.accessibilityLabel = "Academic Year Selection"
        return sc
    }()

    // Control 3: UISwitch
    private let honorsSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.isOn = true
        sw.accessibilityLabel = "Honors Track Toggle Switch"
        return sw
    }()

    // Control 4: UISlider
    private let studyHoursSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 5
        slider.maximumValue = 40
        slider.value = 25
        slider.accessibilityLabel = "Target Weekly Study Hours Slider"
        return slider
    }()

    private let studyHoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
        label.text = "25 hrs/week"
        return label
    }()

    // Control 5: UIDatePicker
    private let enrollmentDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.accessibilityLabel = "Enrollment Date Picker"
        return picker
    }()

    // Navigation & Push Button
    private lazy var navigateButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Inspect View Lifecycle (Push Screen)"
        config.image = UIImage(systemName: "arrow.right.circle.fill")
        config.imagePadding = 6
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .medium

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityLabel = "Navigate to Lifecycle Screen"
        btn.addTarget(self, action: #selector(handleNavigateTapped), for: .touchUpInside)
        return btn
    }()

    // MARK: - Task 3: View Lifecycle Logging
    // Question 4 Explanation:
    // - viewDidLoad(): Called once when view hierarchy is allocated. Best for one-time initialization,
    //   setting up Auto Layout constraints, configuring delegates, and initial data structures.
    override func viewDidLoad() {
        super.viewDidLoad()
        print("⏱ \(timestamp()) \(screenName) 1. viewDidLoad() — Initial view hierarchy loaded and setup.")
        title = "UI Controls & Lifecycle"
        view.backgroundColor = .systemGroupedBackground

        setupLayout()
        setupControlEvents()
        setupKeyboardDismissal()
        setupKeyboardNotifications()
        updateSummaryPanel()
    }

    // - viewWillAppear(): Called every time before the view is presented on screen. Best for refreshing
    //   dynamic data, updating badge counters, refreshing timestamps, or re-validating state changed in other screens.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("⏱ \(timestamp()) \(screenName) 2. viewWillAppear(animated: \(animated)) — View about to appear (refreshing summary).")
        updateSummaryPanel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("⏱ \(timestamp()) \(screenName) 3. viewDidAppear(animated: \(animated)) — View is visible and actively receiving user input.")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("⏱ \(timestamp()) \(screenName) 4. viewWillDisappear(animated: \(animated)) — View is about to be dismissed or covered by push.")
        view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("⏱ \(timestamp()) \(screenName) 5. viewDidDisappear(animated: \(animated)) — View completely disappeared from screen.")
    }

    // MARK: - Control Event Bindings (Task 1 & Task 2)
    private func setupControlEvents() {
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(controlValueChanged), for: .editingChanged)
        semesterSegmentedControl.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        honorsSwitch.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        studyHoursSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        enrollmentDatePicker.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
    }

    @objc private func controlValueChanged() {
        updateSummaryPanel()
    }

    @objc private func sliderValueChanged() {
        let hours = Int(studyHoursSlider.value)
        studyHoursLabel.text = "\(hours) hrs/week"
        updateSummaryPanel()
    }

    // Task 2: Live Summary Panel Updating
    private func updateSummaryPanel() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? "Anonymous"
        let yearIndex = semesterSegmentedControl.selectedSegmentIndex
        let yearName = semesterSegmentedControl.titleForSegment(at: yearIndex) ?? "Unknown"
        let isHonors = honorsSwitch.isOn ? "YES (Honors Program)" : "NO (Standard Program)"
        let hours = Int(studyHoursSlider.value)

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: enrollmentDatePicker.date)

        summaryContentLabel.text = """
        • Student Name : \(name.isEmpty ? "(Not specified)" : name)
        • Academic Year: \(yearName)
        • Honors Track : \(isHonors)
        • Weekly Target: \(hours) hours / week
        • Enrolled Date: \(dateString)
        """
    }

    // MARK: - Auto Layout & Keyboard Adjustment (Task 5)
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        // Summary Card
        let summaryStack = UIStackView(arrangedSubviews: [summaryTitleLabel, summaryContentLabel])
        summaryStack.translatesAutoresizingMaskIntoConstraints = false
        summaryStack.axis = .vertical
        summaryStack.spacing = 8
        summaryCard.addSubview(summaryStack)
        pinToCard(stack: summaryStack, card: summaryCard)
        contentStack.addArrangedSubview(summaryCard)

        // Control 1: Name Field Card
        let nameCard = createCardView()
        let nameTitle = createSectionTitle("1. Student Name (UITextField)")
        let nameStack = UIStackView(arrangedSubviews: [nameTitle, nameTextField])
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        nameStack.axis = .vertical
        nameStack.spacing = 8
        nameCard.addSubview(nameStack)
        pinToCard(stack: nameStack, card: nameCard)
        contentStack.addArrangedSubview(nameCard)

        // Control 2: Segmented Control Card
        let segCard = createCardView()
        let segTitle = createSectionTitle("2. Academic Standing (UISegmentedControl)")
        let segStack = UIStackView(arrangedSubviews: [segTitle, semesterSegmentedControl])
        segStack.translatesAutoresizingMaskIntoConstraints = false
        segStack.axis = .vertical
        segStack.spacing = 8
        segCard.addSubview(segStack)
        pinToCard(stack: segStack, card: segCard)
        contentStack.addArrangedSubview(segCard)

        // Control 3: Honors Switch Card
        let switchCard = createCardView()
        let switchTitle = createSectionTitle("3. Honors Track (UISwitch)")
        let switchRow = UIStackView()
        switchRow.axis = .horizontal
        switchRow.alignment = .center

        let switchDesc = UILabel()
        switchDesc.text = "Enable Honors Track & Research"
        switchDesc.font = .systemFont(ofSize: 14)
        switchDesc.textColor = .secondaryLabel

        switchRow.addArrangedSubview(switchDesc)
        switchRow.addArrangedSubview(honorsSwitch)

        let switchStack = UIStackView(arrangedSubviews: [switchTitle, switchRow])
        switchStack.translatesAutoresizingMaskIntoConstraints = false
        switchStack.axis = .vertical
        switchStack.spacing = 8
        switchCard.addSubview(switchStack)
        pinToCard(stack: switchStack, card: switchCard)
        contentStack.addArrangedSubview(switchCard)

        // Control 4: Study Hours Slider Card
        let sliderCard = createCardView()
        let sliderTitle = createSectionTitle("4. Target Study Hours (UISlider)")
        let sliderTopRow = UIStackView()
        sliderTopRow.axis = .horizontal
        let sliderMinMax = UILabel()
        sliderMinMax.text = "Min: 5h  •  Max: 40h"
        sliderMinMax.font = .systemFont(ofSize: 12)
        sliderMinMax.textColor = .secondaryLabel
        sliderTopRow.addArrangedSubview(sliderMinMax)
        sliderTopRow.addArrangedSubview(studyHoursLabel)

        let sliderStack = UIStackView(arrangedSubviews: [sliderTitle, sliderTopRow, studyHoursSlider])
        sliderStack.translatesAutoresizingMaskIntoConstraints = false
        sliderStack.axis = .vertical
        sliderStack.spacing = 8
        sliderCard.addSubview(sliderStack)
        pinToCard(stack: sliderStack, card: sliderCard)
        contentStack.addArrangedSubview(sliderCard)

        // Control 5: Date Picker Card
        let dateCard = createCardView()
        let dateTitle = createSectionTitle("5. Enrollment Date (UIDatePicker)")
        let dateRow = UIStackView()
        dateRow.axis = .horizontal
        dateRow.alignment = .center
        let dateDesc = UILabel()
        dateDesc.text = "Official Batch Start Date:"
        dateDesc.font = .systemFont(ofSize: 14)
        dateDesc.textColor = .secondaryLabel

        dateRow.addArrangedSubview(dateDesc)
        dateRow.addArrangedSubview(enrollmentDatePicker)

        let dateStack = UIStackView(arrangedSubviews: [dateTitle, dateRow])
        dateStack.translatesAutoresizingMaskIntoConstraints = false
        dateStack.axis = .vertical
        dateStack.spacing = 8
        dateCard.addSubview(dateStack)
        pinToCard(stack: dateStack, card: dateCard)
        contentStack.addArrangedSubview(dateCard)

        // Navigation Button
        contentStack.addArrangedSubview(navigateButton)
    }

    // Task 5: Handle keyboard presentation and dismissal
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom + 16
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        print("⌨️ Keyboard appeared — Content inset adjusted by \(bottomInset)pt to preserve layout visibility.")
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
        print("⌨️ Keyboard dismissed — Content inset smoothly restored to 0.")
    }

    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Navigation Action
    @objc private func handleNavigateTapped() {
        let detailVC = LifecycleDetailViewController()
        detailVC.summaryText = summaryContentLabel.text ?? ""
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Helpers
    private func createCardView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.04
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        return view
    }

    private func createSectionTitle(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }

    private func pinToCard(stack: UIStackView, card: UIView) {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14)
        ])
    }

    private func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}

// MARK: - UITextFieldDelegate
extension ControlsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
