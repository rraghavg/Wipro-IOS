//
//  CourseDetailViewController.swift
//  lab-7b
//
//  Detail screen receiving the selected Course model via dependency injection.
//  Avoids global variables and avoids force-unwrapping.
//

import UIKit

class CourseDetailViewController: UIViewController {

    // MARK: - Safe Dependency Injection (No Global Variables)
    private let course: Course?

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()

    // Initializer with direct model passing
    init(course: Course?) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        // Safe fallback in case initialized without model
        self.course = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .never

        setupLayout()
        populateCourseDetailsSafely()
    }

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
    }

    // MARK: - Safe Data Binding (Task 5: Avoid Force-Unwrapping)
    private func populateCourseDetailsSafely() {
        guard let course = self.course else {
            // Defensive handling if model was somehow not passed
            showMissingDataFallback()
            return
        }

        title = course.title

        // 1. Header Hero Card
        let headerCard = createCardView()
        let iconView = UIImageView(image: UIImage(systemName: course.iconSystemName))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44)
        ])

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.text = course.title

        let categoryBadge = UILabel()
        categoryBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        categoryBadge.textColor = .systemBlue
        categoryBadge.text = "Track: \(course.category)"

        let descLabel = UILabel()
        descLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 0
        descLabel.text = course.description

        let headerStack = UIStackView(arrangedSubviews: [iconView, categoryBadge, titleLabel, descLabel])
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .vertical
        headerStack.spacing = 10
        headerStack.alignment = .leading

        headerCard.addSubview(headerStack)
        pinToCard(stack: headerStack, card: headerCard)
        contentStack.addArrangedSubview(headerCard)

        // 2. Instructor & Metadata Card
        let metaCard = createCardView()
        let metaTitle = createSectionTitle("Course Details")
        let instructorRow = createRow(title: "Lead Instructor", value: course.instructor, icon: "person.fill")
        let durationRow = createRow(title: "Estimated Duration", value: course.duration, icon: "clock.fill")
        let levelRow = createRow(title: "Target Skill Level", value: course.level.rawValue, icon: "chart.bar.fill")

        let metaStack = UIStackView(arrangedSubviews: [metaTitle, instructorRow, durationRow, levelRow])
        metaStack.translatesAutoresizingMaskIntoConstraints = false
        metaStack.axis = .vertical
        metaStack.spacing = 12

        metaCard.addSubview(metaStack)
        pinToCard(stack: metaStack, card: metaCard)
        contentStack.addArrangedSubview(metaCard)

        // 3. Syllabus Modules Card
        let syllabusCard = createCardView()
        let syllabusTitle = createSectionTitle("Syllabus Curriculum")
        var syllabusRows: [UIView] = [syllabusTitle]

        for (index, module) in course.syllabus.enumerated() {
            let row = createModuleRow(index: index + 1, title: module)
            syllabusRows.append(row)
        }

        let syllabusStack = UIStackView(arrangedSubviews: syllabusRows)
        syllabusStack.translatesAutoresizingMaskIntoConstraints = false
        syllabusStack.axis = .vertical
        syllabusStack.spacing = 10

        syllabusCard.addSubview(syllabusStack)
        pinToCard(stack: syllabusStack, card: syllabusCard)
        contentStack.addArrangedSubview(syllabusCard)

        // 4. Navigation Actions (Task 3: Navigation Controller Pop demonstration)
        let actionsCard = createCardView()
        let popButton = UIButton(type: .system)
        var popConfig = UIButton.Configuration.filled()
        popConfig.title = "Back to Course List (Pop)"
        popConfig.image = UIImage(systemName: "arrow.left.circle")
        popConfig.imagePadding = 6
        popConfig.baseBackgroundColor = .systemGray
        popButton.configuration = popConfig
        popButton.addTarget(self, action: #selector(handlePopNavigation), for: .touchUpInside)

        let enrollButton = UIButton(type: .system)
        var enrollConfig = UIButton.Configuration.filled()
        enrollConfig.title = "Enroll in Course"
        enrollConfig.image = UIImage(systemName: "checkmark.seal.fill")
        enrollConfig.imagePadding = 6
        enrollConfig.baseBackgroundColor = .systemBlue
        enrollButton.configuration = enrollConfig
        enrollButton.addTarget(self, action: #selector(handleEnrollTapped), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [enrollButton, popButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .vertical
        buttonStack.spacing = 12

        actionsCard.addSubview(buttonStack)
        pinToCard(stack: buttonStack, card: actionsCard)
        contentStack.addArrangedSubview(actionsCard)
    }

    private func showMissingDataFallback() {
        let label = UILabel()
        label.text = "No course details available. Selected item is missing."
        label.textColor = .systemRed
        label.textAlignment = .center
        contentStack.addArrangedSubview(label)
    }

    // MARK: - Navigation Controller Actions (Task 3)
    @objc private func handlePopNavigation() {
        // Demonstrating explicit navigation controller pop
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleEnrollTapped() {
        guard let course = course else { return }
        let alert = UIAlertController(
            title: "Enrollment Confirmed!",
            message: "You have successfully enrolled in '\(course.title)' with \(course.instructor).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Great", style: .default))
        present(alert, animated: true)
    }

    // MARK: - UI Helpers
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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBlue
        label.text = title
        return label
    }

    private func createRow(title: String, value: String, icon: String) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        let tLabel = UILabel()
        tLabel.font = .systemFont(ofSize: 14, weight: .medium)
        tLabel.textColor = .secondaryLabel
        tLabel.text = title

        let vLabel = UILabel()
        vLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        vLabel.textColor = .label
        vLabel.textAlignment = .right
        vLabel.text = value

        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(tLabel)
        stack.addArrangedSubview(vLabel)
        return stack
    }

    private func createModuleRow(index: Int, title: String) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top

        let badge = UILabel()
        badge.font = .systemFont(ofSize: 12, weight: .bold)
        badge.textColor = .white
        badge.backgroundColor = .systemBlue
        badge.textAlignment = .center
        badge.layer.cornerRadius = 11
        badge.clipsToBounds = true
        badge.text = "\(index)"
        badge.widthAnchor.constraint(equalToConstant: 22).isActive = true
        badge.heightAnchor.constraint(equalToConstant: 22).isActive = true

        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.text = title

        stack.addArrangedSubview(badge)
        stack.addArrangedSubview(label)
        return stack
    }

    private func pinToCard(stack: UIStackView, card: UIView) {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
        ])
    }
}
