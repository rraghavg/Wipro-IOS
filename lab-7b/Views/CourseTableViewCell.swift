//
//  CourseTableViewCell.swift
//  lab-7b
//
//  Reusable custom table view cell displaying course catalog items.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CourseTableViewCell"

    // Icon Container
    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // Labels & Badges
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    private let instructorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private let levelBadge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tertiaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        accessoryType = .disclosureIndicator

        contentView.addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(instructorLabel)
        contentView.addSubview(levelBadge)
        contentView.addSubview(durationLabel)

        NSLayoutConstraint.activate([
            // Icon
            iconBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 44),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 44),

            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Instructor
            instructorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            instructorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            instructorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // Badges bottom row
            levelBadge.topAnchor.constraint(equalTo: instructorLabel.bottomAnchor, constant: 8),
            levelBadge.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            levelBadge.heightAnchor.constraint(equalToConstant: 20),
            levelBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            levelBadge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            durationLabel.centerYAnchor.constraint(equalTo: levelBadge.centerYAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: levelBadge.trailingAnchor, constant: 10),
            durationLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with course: Course) {
        titleLabel.text = course.title
        instructorLabel.text = "Instructor: \(course.instructor)"
        durationLabel.text = "⏱ \(course.duration)"
        iconImageView.image = UIImage(systemName: course.iconSystemName)

        // Style level badge
        levelBadge.text = " \(course.level.rawValue) "
        switch course.level {
        case .beginner:
            levelBadge.textColor = .systemGreen
            levelBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
            iconBackgroundView.backgroundColor = .systemGreen
        case .intermediate:
            levelBadge.textColor = .systemBlue
            levelBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
            iconBackgroundView.backgroundColor = .systemBlue
        case .advanced:
            levelBadge.textColor = .systemPurple
            levelBadge.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.12)
            iconBackgroundView.backgroundColor = .systemPurple
        }
    }
}
