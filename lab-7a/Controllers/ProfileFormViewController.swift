//
//  ProfileFormViewController.swift
//  lab-7a
//
//  Objective: Build a usable UIKit profile form with responsive Auto Layout constraints,
//  inline validation, accessibility labels, suitable keyboard types, and Dynamic Type.
//

import UIKit

class ProfileFormViewController: UIViewController {

    // MARK: - UI Elements (Auto Layout & Dynamic Type)
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.keyboardDismissMode = .onDrag
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let formCard: UIView = {
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

    // Header Icon & Title
    private let headerImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.crop.circle.badge.plus"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Student Registration"
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 22, weight: .bold))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please fill in your details to complete your student profile."
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14, weight: .regular))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // 1. Full Name Field & Inline Error
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Full Name *"
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 15, weight: .semibold))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        return label
    }()

    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "e.g., Raghav Gupta"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.textContentType = .name
        tf.autocapitalizationType = .words
        tf.returnKeyType = .next
        tf.accessibilityLabel = "Full Name Input Field"
        tf.accessibilityHint = "Enter your first and last name"
        return tf
    }()

    private let nameErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name is required (at least 2 letters)."
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()

    // 2. Email Field & Inline Error
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email Address *"
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 15, weight: .semibold))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        return label
    }()

    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "e.g., raghav.gupta@wipro.com"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        tf.accessibilityLabel = "Email Address Input Field"
        tf.accessibilityHint = "Enter a valid email address"
        return tf
    }()

    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please enter a valid email address (e.g., name@domain.com)."
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()

    // 3. Course Field & Inline Error
    private let courseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Course / Track *"
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 15, weight: .semibold))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        return label
    }()

    private let courseSegmentedControl: UISegmentedControl = {
        let items = ["iOS Swift", "Cloud DevOps", "Java Fullstack"]
        let sc = UISegmentedControl(items: items)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.accessibilityLabel = "Select Course Track"
        return sc
    }()

    private let customCourseTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Or specify custom batch / module (optional)"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
        tf.accessibilityLabel = "Custom Course Track Specification"
        return tf
    }()

    private let courseErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please choose or enter a valid course."
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()

    // 4. Buttons (Submit & Reset)
    private lazy var submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Submit Profile"
        config.image = UIImage(systemName: "checkmark.circle.fill")
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .medium

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityLabel = "Submit Profile Button"
        btn.addTarget(self, action: #selector(handleSubmitTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var resetButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Clear Form"
        config.baseForegroundColor = .secondaryLabel

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityLabel = "Clear Form Fields Button"
        btn.addTarget(self, action: #selector(handleResetTapped), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile Form"
        view.backgroundColor = .systemGroupedBackground

        setupDelegates()
        setupKeyboardDismissal()
        setupLayout()
    }

    private func setupDelegates() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        customCourseTextField.delegate = self

        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    // Dismiss keyboard when tapping anywhere outside
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Auto Layout Constraints (Fully Responsive)
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formCard)

        NSLayoutConstraint.activate([
            // Scroll view pinned to safe area
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            // Content view pinned to scroll view content guide
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // Form card with adaptive margins
            formCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            formCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            formCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            formCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])

        // Build the vertical stack inside formCard
        let stack = UIStackView(arrangedSubviews: [
            headerImageView,
            headerLabel,
            subtitleLabel,
            createDivider(),

            nameLabel,
            nameTextField,
            nameErrorLabel,

            emailLabel,
            emailTextField,
            emailErrorLabel,

            courseLabel,
            courseSegmentedControl,
            customCourseTextField,
            courseErrorLabel,

            createSpacer(height: 8),
            submitButton,
            resetButton
        ])

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.setCustomSpacing(4, after: nameLabel)
        stack.setCustomSpacing(4, after: nameTextField)
        stack.setCustomSpacing(4, after: emailLabel)
        stack.setCustomSpacing(4, after: emailTextField)
        stack.setCustomSpacing(6, after: courseLabel)
        stack.setCustomSpacing(6, after: courseSegmentedControl)
        stack.setCustomSpacing(4, after: customCourseTextField)

        formCard.addSubview(stack)

        NSLayoutConstraint.activate([
            headerImageView.heightAnchor.constraint(equalToConstant: 50),

            stack.topAnchor.constraint(equalTo: formCard.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: formCard.bottomAnchor, constant: -20),

            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            courseSegmentedControl.heightAnchor.constraint(equalToConstant: 34),
            customCourseTextField.heightAnchor.constraint(equalToConstant: 44),
            submitButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    private func createDivider() -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .separator
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }

    private func createSpacer(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }

    // MARK: - Validation Logic
    @objc private func textFieldDidChange() {
        // Clear errors as soon as the user starts correcting their input
        if let name = nameTextField.text, name.trimmingCharacters(in: .whitespaces).count >= 2 {
            nameErrorLabel.isHidden = true
            nameTextField.layer.borderColor = UIColor.clear.cgColor
        }
        if let email = emailTextField.text, isValidEmail(email) {
            emailErrorLabel.isHidden = true
            emailTextField.layer.borderColor = UIColor.clear.cgColor
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private func validateForm() -> Bool {
        var isValid = true

        // 1. Validate Name
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if name.count < 2 {
            nameErrorLabel.isHidden = false
            nameTextField.layer.borderColor = UIColor.systemRed.cgColor
            nameTextField.layer.borderWidth = 1.0
            isValid = false
        } else {
            nameErrorLabel.isHidden = true
            nameTextField.layer.borderWidth = 0.0
        }

        // 2. Validate Email
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !isValidEmail(email) {
            emailErrorLabel.isHidden = false
            emailTextField.layer.borderColor = UIColor.systemRed.cgColor
            emailTextField.layer.borderWidth = 1.0
            isValid = false
        } else {
            emailErrorLabel.isHidden = true
            emailTextField.layer.borderWidth = 0.0
        }

        // 3. Course track
        courseErrorLabel.isHidden = true

        return isValid
    }

    // MARK: - Button Actions
    @objc private func handleSubmitTapped() {
        dismissKeyboard()

        guard validateForm() else {
            // Shake animation on card to provide subtle haptic/visual feedback
            shakeCard()
            return
        }

        // Selected Course
        let defaultCourse = courseSegmentedControl.titleForSegment(at: courseSegmentedControl.selectedSegmentIndex) ?? ""
        let customCourse = customCourseTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let finalCourse = customCourse.isEmpty ? defaultCourse : "\(defaultCourse) (\(customCourse))"

        let studentName = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let studentEmail = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""

        // Show Success Alert
        let alert = UIAlertController(
            title: "Profile Submitted! 🎉",
            message: "Student Details:\n\n• Name: \(studentName)\n• Email: \(studentEmail)\n• Track: \(finalCourse)\n\nAll validation criteria passed successfully.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func handleResetTapped() {
        nameTextField.text = ""
        emailTextField.text = ""
        customCourseTextField.text = ""
        courseSegmentedControl.selectedSegmentIndex = 0

        nameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        courseErrorLabel.isHidden = true

        nameTextField.layer.borderWidth = 0
        emailTextField.layer.borderWidth = 0
        dismissKeyboard()
    }

    private func shakeCard() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-12.0, 12.0, -8.0, 8.0, -4.0, 4.0, 0.0]
        formCard.layer.add(animation, forKey: "shake")
    }
}

// MARK: - UITextFieldDelegate
extension ProfileFormViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            customCourseTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            handleSubmitTapped()
        }
        return true
    }
}
