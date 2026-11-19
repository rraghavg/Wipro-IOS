//
//  UserTableViewCell.swift
//  lab-6
//
//  Custom table view cell displaying student directory user cards.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UserTableViewCell"

    private let avatarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()

    private let initialsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemIndigo
        label.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.12)
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.textAlignment = .center
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

        contentView.addSubview(avatarContainer)
        avatarContainer.addSubview(initialsLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(companyLabel)

        NSLayoutConstraint.activate([
            // Avatar
            avatarContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarContainer.widthAnchor.constraint(equalToConstant: 48),
            avatarContainer.heightAnchor.constraint(equalToConstant: 48),

            initialsLabel.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),

            // Name
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: 14),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: companyLabel.leadingAnchor, constant: -8),

            // Email
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            // Company pill badge
            companyLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            companyLabel.heightAnchor.constraint(equalToConstant: 22),
            companyLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])
    }

    func configure(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = "✉️ \(user.email)"
        companyLabel.text = " \(user.company.name) "
        initialsLabel.text = user.initials

        // Tint avatar colors based on id for variety
        let colors: [UIColor] = [.systemBlue, .systemIndigo, .systemTeal, .systemPurple, .systemOrange]
        avatarContainer.backgroundColor = colors[abs(user.id) % colors.count]
    }
}
