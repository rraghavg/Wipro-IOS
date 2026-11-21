//
//  PostDetailViewController.swift
//  assessment-m3
//
//  Created by Raghav Gupta
//  R4: Detail screen reached by navigation push from the list
//
//  Receives a Post model object via initializer injection
//  (no global variables used for data passing).
//

import UIKit

class PostDetailViewController: UIViewController {

    // the post is passed in through the initializer — not a global
    private let post: Post

    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let card: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondarySystemGroupedBackground
        v.layer.cornerRadius = 14
        return v
    }()

    private let idBadge: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 12, weight: .bold)
        l.textColor = .white
        l.backgroundColor = .systemBlue
        l.textAlignment = .center
        l.layer.cornerRadius = 12
        l.layer.masksToBounds = true
        return l
    }()

    private let userBadge: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 12)
        l.textColor = .secondaryLabel
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 20, weight: .bold)
        l.textColor = .label
        l.numberOfLines = 0
        return l
    }()

    private let divider: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .separator
        return v
    }()

    private let bodyLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 15)
        l.textColor = .label
        l.numberOfLines = 0
        return l
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post #\(post.id)"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        populateData()
    }

    // MARK: - Layout (all Auto Layout, no fixed coordinates)

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(card)
        card.addSubview(idBadge)
        card.addSubview(userBadge)
        card.addSubview(titleLabel)
        card.addSubview(divider)
        card.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            card.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            card.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),

            idBadge.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            idBadge.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            idBadge.widthAnchor.constraint(equalToConstant: 48),
            idBadge.heightAnchor.constraint(equalToConstant: 24),

            userBadge.centerYAnchor.constraint(equalTo: idBadge.centerYAnchor),
            userBadge.leadingAnchor.constraint(equalTo: idBadge.trailingAnchor, constant: 8),

            titleLabel.topAnchor.constraint(equalTo: idBadge.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),

            divider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),

            bodyLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 14),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
        ])
    }

    private func populateData() {
        idBadge.text = "# \(post.id)"
        userBadge.text = "User \(post.userId)"
        titleLabel.text = post.title.capitalized
        bodyLabel.text = post.body
    }
}
