//
//  UserDetailViewController.swift
//  lab-6
//
//  Detail screen showing full user profile, contact info, company and address.
//

import UIKit

class UserDetailViewController: UIViewController {

    private let user: User

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

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.name
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .never

        setupLayout()
        populateData()
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

    private func populateData() {
        // 1. Header Card (Avatar + Names)
        let headerCard = createCardView()
        let avatarView = UIView()
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.backgroundColor = .systemBlue
        avatarView.layer.cornerRadius = 35
        avatarView.clipsToBounds = true

        let initials = UILabel()
        initials.translatesAutoresizingMaskIntoConstraints = false
        initials.font = .systemFont(ofSize: 26, weight: .bold)
        initials.textColor = .white
        initials.text = user.initials
        avatarView.addSubview(initials)

        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.text = user.name
        nameLabel.textAlignment = .center

        let usernameLabel = UILabel()
        usernameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        usernameLabel.textColor = .secondaryLabel
        usernameLabel.text = "@\(user.username)"
        usernameLabel.textAlignment = .center

        let headerStack = UIStackView(arrangedSubviews: [avatarView, nameLabel, usernameLabel])
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.alignment = .center

        headerCard.addSubview(headerStack)
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            initials.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            initials.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            headerStack.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 18),
            headerStack.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),
            headerStack.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -18),
        ])
        contentStack.addArrangedSubview(headerCard)

        // 2. Contact Information Card
        let contactCard = createCardView()
        let contactTitle = createSectionTitle("Contact Details")
        let emailRow = createInfoRow(icon: "envelope.fill", title: "Email", value: user.email)
        let phoneRow = createInfoRow(icon: "phone.fill", title: "Phone", value: user.phone)
        let websiteRow = createInfoRow(icon: "globe", title: "Website", value: user.website)

        let contactStack = UIStackView(arrangedSubviews: [contactTitle, emailRow, phoneRow, websiteRow])
        contactStack.translatesAutoresizingMaskIntoConstraints = false
        contactStack.axis = .vertical
        contactStack.spacing = 14

        contactCard.addSubview(contactStack)
        pinToCard(stack: contactStack, card: contactCard)
        contentStack.addArrangedSubview(contactCard)

        // 3. Company Card
        let companyCard = createCardView()
        let companyTitle = createSectionTitle("Company")
        let compNameRow = createInfoRow(icon: "building.2.fill", title: "Name", value: user.company.name)
        let catchRow = createInfoRow(icon: "quote.opening", title: "Catchphrase", value: "\"\(user.company.catchPhrase)\"")
        let bsRow = createInfoRow(icon: "briefcase.fill", title: "Focus", value: user.company.bs)

        let companyStack = UIStackView(arrangedSubviews: [companyTitle, compNameRow, catchRow, bsRow])
        companyStack.translatesAutoresizingMaskIntoConstraints = false
        companyStack.axis = .vertical
        companyStack.spacing = 14

        companyCard.addSubview(companyStack)
        pinToCard(stack: companyStack, card: companyCard)
        contentStack.addArrangedSubview(companyCard)

        // 4. Address Card
        let addressCard = createCardView()
        let addressTitle = createSectionTitle("Address")
        let fullAddrRow = createInfoRow(icon: "mappin.and.ellipse", title: "Street & Suite", value: "\(user.address.street), \(user.address.suite)")
        let cityRow = createInfoRow(icon: "location.fill", title: "City & Zip", value: "\(user.address.city), \(user.address.zipcode)")
        let geoRow = createInfoRow(icon: "map.fill", title: "Coordinates", value: "Lat: \(user.address.geo.lat), Lng: \(user.address.geo.lng)")

        let addressStack = UIStackView(arrangedSubviews: [addressTitle, fullAddrRow, cityRow, geoRow])
        addressStack.translatesAutoresizingMaskIntoConstraints = false
        addressStack.axis = .vertical
        addressStack.spacing = 14

        addressCard.addSubview(addressStack)
        pinToCard(stack: addressStack, card: addressCard)
        contentStack.addArrangedSubview(addressCard)
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

    private func createInfoRow(icon: String, title: String, value: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .top

        let imgView = UIImageView(image: UIImage(systemName: icon))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = .systemBlue
        imgView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: 20),
            imgView.heightAnchor.constraint(equalToConstant: 20)
        ])

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title

        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 15, weight: .regular)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 0
        valueLabel.text = value

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(valueLabel)

        row.addArrangedSubview(imgView)
        row.addArrangedSubview(textStack)
        return row
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
