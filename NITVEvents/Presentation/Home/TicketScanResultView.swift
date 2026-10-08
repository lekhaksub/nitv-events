import UIKit

final class TicketScanResultView: UIView {

    // MARK: - Scan Result

    enum ScanResult {
        case success
        case failure
    }

    // MARK: - Properties

    private let result: ScanResult

    var onDismiss: (() -> Void)?

    // MARK: - UI Components

    private let containerView = UIView()

    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()

    private let titleLabel = UILabel()
    private let statusLabel = UILabel()

    private let ticketIDLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()

    private let dismissButton = UIButton(type: .system)

    // MARK: - Init

    init(
        result: ScanResult,
        message: String,
        ticketID: String,
        name: String,
        email: String,
        phone: String
    ) {

        self.result = result

        super.init(frame: .zero)

        setupUI(
            message: message,
            ticketID: ticketID,
            name: name,
            email: email,
            phone: phone
        )

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI(
        message: String,
        ticketID: String,
        name: String,
        email: String,
        phone: String
    ) {

        // MARK: Background

        backgroundColor = UIColor.black.withAlphaComponent(0.60)

        // MARK: Container

        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 28
        containerView.clipsToBounds = true

        addSubview(containerView)

        // MARK: Icon Container

        iconContainerView.layer.cornerRadius = 30

        containerView.addSubview(iconContainerView)

        // MARK: Icon

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white

        iconContainerView.addSubview(iconImageView)

        // MARK: Result State

        switch result {

        case .success:

            iconContainerView.backgroundColor = .systemGreen

            iconImageView.image = UIImage(
                systemName: "checkmark"
            )

            titleLabel.text = "Ticket scanned"
            titleLabel.textColor = .systemGreen


        case .failure:

            iconContainerView.backgroundColor = .systemRed

            iconImageView.image = UIImage(
                systemName: "xmark"
            )

            titleLabel.text = "Ticket scan failed"
            titleLabel.textColor = .systemRed

        }

        // MARK: Title

        titleLabel.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )

        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        containerView.addSubview(titleLabel)

        // MARK: Status

        statusLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )

        statusLabel.textColor = .black
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center   
        containerView.addSubview(statusLabel)

        // MARK: Information Labels

        ticketIDLabel.text = "Ticket ID: \(ticketID)"
        nameLabel.text = "Name: \(name)"
        emailLabel.text = "Email: \(email)"
        phoneLabel.text = "Phone: \(phone)"
        statusLabel.text = message
        
        let informationLabels = [
            ticketIDLabel,
            nameLabel,
            emailLabel,
            phoneLabel
        ]

        informationLabels.forEach { label in

            label.font = .systemFont(
                ofSize: 16,
                weight: .regular
            )

            label.textColor = .black
            label.numberOfLines = 0

            containerView.addSubview(label)
        }

        // MARK: Dismiss Button

        dismissButton.setTitle(
            "Dismiss",
            for: .normal
        )

        dismissButton.titleLabel?.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )

        dismissButton.addTarget(
            self,
            action: #selector(dismissTapped),
            for: .touchUpInside
        )

        containerView.addSubview(dismissButton)
    }

    // MARK: - Constraints

    private func setupConstraints() {

        let views = [
            containerView,
            iconContainerView,
            iconImageView,
            titleLabel,
            statusLabel,
            ticketIDLabel,
            nameLabel,
            emailLabel,
            phoneLabel,
            dismissButton
        ]

        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([

            // MARK: Container

            containerView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),

            containerView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),

            containerView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.72
            ),

            // MARK: Icon Container - 60 x 60

            iconContainerView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 30
            ),

            iconContainerView.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor
            ),

            iconContainerView.widthAnchor.constraint(
                equalToConstant: 60
            ),

            iconContainerView.heightAnchor.constraint(
                equalToConstant: 60
            ),

            // MARK: Icon - 36 x 36

            iconImageView.centerXAnchor.constraint(
                equalTo: iconContainerView.centerXAnchor
            ),

            iconImageView.centerYAnchor.constraint(
                equalTo: iconContainerView.centerYAnchor
            ),

            iconImageView.widthAnchor.constraint(
                equalToConstant: 36
            ),

            iconImageView.heightAnchor.constraint(
                equalToConstant: 36
            ),

            // MARK: Title

            titleLabel.topAnchor.constraint(
                equalTo: iconContainerView.bottomAnchor,
                constant: 22
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 20
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -20
            ),

            // MARK: Status

            statusLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 22
            ),

            statusLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 24
            ),

            statusLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -24
            ),

            // MARK: Ticket ID

            ticketIDLabel.topAnchor.constraint(
                equalTo: statusLabel.bottomAnchor,
                constant: 10
            ),

            ticketIDLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 24
            ),

            ticketIDLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -24
            ),

            // MARK: Name

            nameLabel.topAnchor.constraint(
                equalTo: ticketIDLabel.bottomAnchor,
                constant: 8
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: ticketIDLabel.leadingAnchor
            ),

            nameLabel.trailingAnchor.constraint(
                equalTo: ticketIDLabel.trailingAnchor
            ),

            // MARK: Email

            emailLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 8
            ),

            emailLabel.leadingAnchor.constraint(
                equalTo: ticketIDLabel.leadingAnchor
            ),

            emailLabel.trailingAnchor.constraint(
                equalTo: ticketIDLabel.trailingAnchor
            ),

            // MARK: Phone

            phoneLabel.topAnchor.constraint(
                equalTo: emailLabel.bottomAnchor,
                constant: 8
            ),

            phoneLabel.leadingAnchor.constraint(
                equalTo: ticketIDLabel.leadingAnchor
            ),

            phoneLabel.trailingAnchor.constraint(
                equalTo: ticketIDLabel.trailingAnchor
            ),

            // MARK: Dismiss

            dismissButton.topAnchor.constraint(
                equalTo: phoneLabel.bottomAnchor,
                constant: 28
            ),

            dismissButton.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -24
            ),

            dismissButton.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -28
            ),

            dismissButton.heightAnchor.constraint(
                equalToConstant: 36
            )
        ])
    }

    // MARK: - Action

    @objc private func dismissTapped() {
        onDismiss?()
    }
}
