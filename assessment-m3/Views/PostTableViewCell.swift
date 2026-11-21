//
//  PostTableViewCell.swift
//  assessment-m3
//
//  Created by Raghav Gupta
//  Custom table view cell for showing a post in the list
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let reuseID = "PostTableViewCell"

    // circle with the post number
    private let numberCircle: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBlue
        v.layer.cornerRadius = 20
        return v
    }()

    private let numberLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 2
        return l
    }()

    private let previewLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(numberCircle)
        numberCircle.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(previewLabel)

        NSLayoutConstraint.activate([
            numberCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            numberCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberCircle.widthAnchor.constraint(equalToConstant: 40),
            numberCircle.heightAnchor.constraint(equalToConstant: 40),

            numberLabel.centerXAnchor.constraint(equalTo: numberCircle.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: numberCircle.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: numberCircle.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            previewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            previewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            previewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    func configure(with post: Post) {
        numberLabel.text = "\(post.id)"
        titleLabel.text = post.title.capitalized
        previewLabel.text = post.body.replacingOccurrences(of: "\n", with: " ")
    }
}
