//
//  PostListViewController.swift
//  assessment-m3
//
//  Created by Raghav Gupta
//  R2: Decode JSON into Codable models and render a list
//  R3: Show loading, empty, and failure states
//  R4: Navigate from list to detail screen
//
//  Uses JSONPlaceholder /posts as the data source.
//  Has a "Simulate" button in the nav bar so the teacher can see
//  all the error/empty states without needing to break the network.
//

import UIKit

class PostListViewController: UIViewController {

    // MARK: - Properties
    private let service = PostService()
    private var posts: [Post] = []

    // MARK: - UI Components

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseID)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 70
        return tv
    }()

    private let spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(style: .large)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.hidesWhenStopped = true
        return s
    }()

    private let loadingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Loading posts..."
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    // R3: status card for empty / error states
    private let statusCard: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondarySystemGroupedBackground
        v.layer.cornerRadius = 14
        v.isHidden = true
        return v
    }()

    private let statusIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemRed
        return iv
    }()

    private let statusTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 17, weight: .bold)
        l.textAlignment = .center
        return l
    }()

    private let statusMessage: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private lazy var retryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Retry"
        config.image = UIImage(systemName: "arrow.clockwise")
        config.imagePadding = 6
        config.cornerStyle = .capsule
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return btn
    }()

    private let refreshControl = UIRefreshControl()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post Directory"
        view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupTableView()
        setupSpinner()
        setupStatusCard()
        loadPosts()
    }

    // MARK: - Layout Setup

    private func setupNavBar() {
        let simBtn = UIBarButtonItem(title: "Simulate",
                                     style: .plain,
                                     target: self,
                                     action: #selector(showSimulateMenu))
        navigationItem.rightBarButtonItem = simBtn
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(retryTapped), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupSpinner() {
        view.addSubview(spinner)
        view.addSubview(loadingLabel)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            loadingLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 12),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func setupStatusCard() {
        view.addSubview(statusCard)
        statusCard.addSubview(statusIcon)
        statusCard.addSubview(statusTitle)
        statusCard.addSubview(statusMessage)
        statusCard.addSubview(retryButton)

        NSLayoutConstraint.activate([
            statusCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusCard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            statusCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            statusIcon.topAnchor.constraint(equalTo: statusCard.topAnchor, constant: 24),
            statusIcon.centerXAnchor.constraint(equalTo: statusCard.centerXAnchor),
            statusIcon.widthAnchor.constraint(equalToConstant: 48),
            statusIcon.heightAnchor.constraint(equalToConstant: 48),

            statusTitle.topAnchor.constraint(equalTo: statusIcon.bottomAnchor, constant: 12),
            statusTitle.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 16),
            statusTitle.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -16),

            statusMessage.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 6),
            statusMessage.leadingAnchor.constraint(equalTo: statusTitle.leadingAnchor),
            statusMessage.trailingAnchor.constraint(equalTo: statusTitle.trailingAnchor),

            retryButton.topAnchor.constraint(equalTo: statusMessage.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: statusCard.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: statusCard.bottomAnchor, constant: -20),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    // MARK: - State Transitions

    private func showLoadingState() {
        tableView.isHidden = true
        statusCard.isHidden = true
        loadingLabel.isHidden = false
        spinner.startAnimating()
    }

    private func showSuccessState() {
        spinner.stopAnimating()
        loadingLabel.isHidden = true
        statusCard.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    private func showEmptyState() {
        spinner.stopAnimating()
        loadingLabel.isHidden = true
        tableView.isHidden = true
        refreshControl.endRefreshing()

        statusCard.isHidden = false
        statusIcon.image = UIImage(systemName: "tray")
        statusIcon.tintColor = .systemOrange
        statusTitle.text = "No Posts Found"
        statusMessage.text = "The server returned an empty list. Try a different simulation mode."
    }

    private func showErrorState(message: String) {
        spinner.stopAnimating()
        loadingLabel.isHidden = true
        tableView.isHidden = true
        refreshControl.endRefreshing()

        statusCard.isHidden = false
        statusIcon.image = UIImage(systemName: "exclamationmark.triangle.fill")
        statusIcon.tintColor = .systemRed
        statusTitle.text = "Something Went Wrong"
        statusMessage.text = message
    }

    // MARK: - Networking

    private func loadPosts() {
        showLoadingState()

        Task {
            do {
                let fetched = try await service.fetchPosts()
                self.posts = fetched
                showSuccessState()
            } catch let error as PostServiceError where error.errorDescription == PostServiceError.noResults.errorDescription {
                self.posts = []
                showEmptyState()
            } catch {
                self.posts = []
                showErrorState(message: error.localizedDescription)
            }
        }
    }

    // MARK: - Actions

    @objc private func retryTapped() {
        service.mode = .live
        loadPosts()
    }

    @objc private func showSimulateMenu() {
        let sheet = UIAlertController(title: "Simulate Network State",
                                      message: "Pick a scenario to test",
                                      preferredStyle: .actionSheet)
        for mode in SimulationMode.allCases {
            let action = UIAlertAction(title: mode.rawValue, style: .default) { [weak self] _ in
                self?.service.mode = mode
                self?.loadPosts()
            }
            // put a checkmark next to the currently active mode
            if mode == service.mode {
                action.setValue(true, forKey: "checked")
            }
            sheet.addAction(action)
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // iPad popover support
        if let popover = sheet.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(sheet, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseID, for: indexPath)
                as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }

    // R4: navigate to detail screen when user taps a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PostDetailViewController(post: posts[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
