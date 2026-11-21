//
//  ProfileFormViewController.swift
//  assessment-m3
//
//  Created by Raghav Gupta
//  R1: UIKit form with validation and Auto Layout
//
//  This screen has three text fields (name, email, course) laid out
//  with Auto Layout constraints inside a scroll view, plus inline
//  validation messages when the user taps Submit.
//

import UIKit

class ProfileFormViewController: UIViewController {

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .onDrag
        return sv
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    // header
    private let headerLabel: UILabel = {
        let l = UILabel()
        l.text = "Student Registration"
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.textAlignment = .center
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Fill in your details below to register."
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    // name
    private let nameField = UITextField()
    private let nameError = UILabel()

    // email
    private let emailField = UITextField()
    private let emailError = UILabel()

    // course
    private let courseField = UITextField()
    private let courseError = UILabel()

    // submit button
    private let submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Submit"
        config.cornerStyle = .medium
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // success banner
    private let successBanner: UILabel = {
        let l = UILabel()
        l.text = "✅ Registration submitted successfully!"
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .systemGreen
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    // keep track of keyboard height so we can adjust scroll insets
    private var keyboardHeight: CGFloat = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .systemGroupedBackground
        buildForm()
        setupConstraints()
        setupKeyboardObservers()
    }

    // MARK: - Build Form

    private func buildForm() {
        // configure each text field with the right keyboard, placeholder, and accessibility
        configureTextField(nameField, placeholder: "Full Name",
                           keyboard: .default, content: .name,
                           accessLabel: "Full name input")
        configureTextField(emailField, placeholder: "Email Address",
                           keyboard: .emailAddress, content: .emailAddress,
                           accessLabel: "Email address input")
        configureTextField(courseField, placeholder: "Course (e.g. iOS Development)",
                           keyboard: .default, content: .organizationName,
                           accessLabel: "Course name input")

        // configure each inline error label
        configureErrorLabel(nameError)
        configureErrorLabel(emailError)
        configureErrorLabel(courseError)

        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        // add everything to the stack
        contentStack.addArrangedSubview(headerLabel)
        contentStack.addArrangedSubview(subtitleLabel)
        contentStack.setCustomSpacing(24, after: subtitleLabel)

        addFieldRow(label: "Full Name *", field: nameField, error: nameError)
        addFieldRow(label: "Email *", field: emailField, error: emailError)
        addFieldRow(label: "Course *", field: courseField, error: courseError)

        contentStack.addArrangedSubview(submitButton)
        contentStack.addArrangedSubview(successBanner)
    }

    private func addFieldRow(label text: String, field: UITextField, error: UILabel) {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .label
        contentStack.addArrangedSubview(lbl)
        contentStack.setCustomSpacing(4, after: lbl)
        contentStack.addArrangedSubview(field)
        contentStack.setCustomSpacing(2, after: field)
        contentStack.addArrangedSubview(error)
    }

    private func configureTextField(_ tf: UITextField,
                                     placeholder: String,
                                     keyboard: UIKeyboardType,
                                     content: UITextContentType,
                                     accessLabel: String) {
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = placeholder
        tf.keyboardType = keyboard
        tf.textContentType = content
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        tf.font = .systemFont(ofSize: 16)
        tf.accessibilityLabel = accessLabel
        tf.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    }

    private func configureErrorLabel(_ lbl: UILabel) {
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .systemRed
        lbl.numberOfLines = 0
        lbl.isHidden = true
    }

    // MARK: - Auto Layout

    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            submitButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = frame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        keyboardHeight = 0
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    // MARK: - Validation & Submit

    @objc private func submitTapped() {
        view.endEditing(true)
        successBanner.isHidden = true

        var isValid = true

        // validate name
        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespaces)
        if name.isEmpty {
            showError(nameError, message: "Name is required.")
            shakeField(nameField)
            isValid = false
        } else if name.count < 2 {
            showError(nameError, message: "Name must be at least 2 characters.")
            shakeField(nameField)
            isValid = false
        } else {
            hideError(nameError)
        }

        // validate email
        let email = (emailField.text ?? "").trimmingCharacters(in: .whitespaces)
        if email.isEmpty {
            showError(emailError, message: "Email is required.")
            shakeField(emailField)
            isValid = false
        } else if !email.contains("@") || !email.contains(".") {
            showError(emailError, message: "Please enter a valid email address.")
            shakeField(emailField)
            isValid = false
        } else {
            hideError(emailError)
        }

        // validate course
        let course = (courseField.text ?? "").trimmingCharacters(in: .whitespaces)
        if course.isEmpty {
            showError(courseError, message: "Course is required.")
            shakeField(courseField)
            isValid = false
        } else {
            hideError(courseError)
        }

        if isValid {
            successBanner.isHidden = false
            nameField.text = ""
            emailField.text = ""
            courseField.text = ""
        }
    }

    private func showError(_ label: UILabel, message: String) {
        label.text = message
        label.isHidden = false
    }

    private func hideError(_ label: UILabel) {
        label.isHidden = true
    }

    private func shakeField(_ field: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-8, 8, -6, 6, -3, 3, 0]
        field.layer.add(animation, forKey: "shake")
        field.layer.borderColor = UIColor.systemRed.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 6

        // reset border after a moment
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            field.layer.borderWidth = 0
        }
    }
}
