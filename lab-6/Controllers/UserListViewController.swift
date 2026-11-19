//
//  UserListViewController.swift
//  lab-6
//
//  Main directory view controller demonstrating async/await network fetching,
//  loading spinners, custom error handling with retry states, and live search.
//

import UIKit

class UserListViewController: UIViewController {

    // MARK: - Properties
    private let userService = UserService()
    private var allUsers: [User] = []
    private var filteredUsers: [User] = []

    // MARK: - UI Components
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 72
        return tv
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let refreshControl = UIRefreshControl()

    // Error / Empty State Container
    private let statusCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.isHidden = true
        return view
    }()

    private let statusIcon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .systemRed
        img.contentMode = .scaleAspectFit
        return img
    }()

    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let statusMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var retryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Retry Request"
        config.image = UIImage(systemName: "arrow.clockwise")
        config.imagePadding = 6
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .capsule

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleRetryTapped), for: .touchUpInside)
        return btn
    }()

    // Extension: Search Controller
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Directory"
        view.backgroundColor = .systemGroupedBackground

        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupStatusCard()
        setupLoadingIndicator()

        // Initial live fetch
        loadUserData()
    }

    // MARK: - UI Setup
    private func setupNavigationBar() {
        // Button to switch simulation modes for grading & screenshots
        let modeButton = UIBarButtonItem(
            title: "Simulate",
            style: .plain,
            target: self,
            action: #selector(showSimulationActionSheet)
        )
        navigationItem.rightBarButtonItem = modeButton
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name, email, or company"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupStatusCard() {
        view.addSubview(statusCard)

        let stack = UIStackView(arrangedSubviews: [statusIcon, statusTitleLabel, statusMessageLabel, retryButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .center

        statusCard.addSubview(stack)

        NSLayoutConstraint.activate([
            statusCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            statusCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            statusCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            statusIcon.widthAnchor.constraint(equalToConstant: 54),
            statusIcon.heightAnchor.constraint(equalToConstant: 54),

            stack.topAnchor.constraint(equalTo: statusCard.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: statusCard.bottomAnchor, constant: -24),

            retryButton.heightAnchor.constraint(equalToConstant: 42),
            retryButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }

    // MARK: - Networking
    private func loadUserData() {
        // 1. Show Loading State
        statusCard.isHidden = true
        if !refreshControl.isRefreshing {
            loadingIndicator.startAnimating()
        }

        // 2. Perform async network request using Swift Concurrency
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let fetchedUsers = try await self.userService.fetchUsers()

                // Success State: Update UI on MainActor
                await MainActor.run {
                    self.loadingIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.allUsers = fetchedUsers
                    self.filteredUsers = fetchedUsers
                    self.tableView.isHidden = false
                    self.statusCard.isHidden = true
                    self.tableView.reloadData()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.handleErrorState(error)
                }
            } catch {
                await MainActor.run {
                    self.handleErrorState(.networkFailure(error.localizedDescription))
                }
            }
        }
    }

    // MARK: - Error & Empty State Display
    private func handleErrorState(_ error: NetworkError) {
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
        tableView.isHidden = true
        statusCard.isHidden = false

        switch error {
        case .emptyData:
            statusIcon.image = UIImage(systemName: "tray.fill")
            statusIcon.tintColor = .systemOrange
            statusTitleLabel.text = "No Users Found"
            statusMessageLabel.text = error.localizedDescription
            retryButton.configuration?.title = "Refresh"

        case .invalidResponse(let code):
            statusIcon.image = UIImage(systemName: "exclamationmark.triangle.fill")
            statusIcon.tintColor = .systemRed
            statusTitleLabel.text = "HTTP \(code) Error"
            statusMessageLabel.text = error.localizedDescription
            retryButton.configuration?.title = "Retry"

        case .decodingError:
            statusIcon.image = UIImage(systemName: "doc.badge.ellipsis")
            statusIcon.tintColor = .systemPurple
            statusTitleLabel.text = "Parsing Failure"
            statusMessageLabel.text = error.localizedDescription
            retryButton.configuration?.title = "Retry"

        case .networkFailure:
            statusIcon.image = UIImage(systemName: "wifi.slash")
            statusIcon.tintColor = .systemRed
            statusTitleLabel.text = "Connection Offline"
            statusMessageLabel.text = error.localizedDescription
            retryButton.configuration?.title = "Try Again"

        default:
            statusIcon.image = UIImage(systemName: "xmark.octagon.fill")
            statusIcon.tintColor = .systemRed
            statusTitleLabel.text = "Request Failed"
            statusMessageLabel.text = error.localizedDescription
            retryButton.configuration?.title = "Retry"
        }
    }

    // MARK: - Actions
    @objc private func handleRetryTapped() {
        loadUserData()
    }

    @objc private func handlePullToRefresh() {
        loadUserData()
    }

    @objc private func showSimulationActionSheet() {
        let alert = UIAlertController(
            title: "Simulate Network State",
            message: "Demonstrate required classroom states (success, 404, 500, decoding error, offline, empty).",
            preferredStyle: .actionSheet
        )

        for mode in NetworkSimulationMode.allCases {
            alert.addAction(UIAlertAction(title: mode.rawValue, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.userService.simulationMode = mode
                self.loadUserData()
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(alert, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserTableViewCell else {
            return UITableViewCell()
        }

        let user = filteredUsers[indexPath.row]
        cell.configure(with: user)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = filteredUsers[indexPath.row]
        let detailVC = UserDetailViewController(user: selectedUser)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchResultsUpdating (Extension Task)
extension UserListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !query.isEmpty else {
            filteredUsers = allUsers
            tableView.reloadData()
            return
        }

        filteredUsers = allUsers.filter { user in
            user.name.localizedCaseInsensitiveContains(query) ||
            user.email.localizedCaseInsensitiveContains(query) ||
            user.company.name.localizedCaseInsensitiveContains(query) ||
            user.username.localizedCaseInsensitiveContains(query)
        }
        tableView.reloadData()
    }
}
