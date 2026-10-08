import UIKit

final class HomeViewController: UIViewController {
    var onScanned: ((String) -> Void)?
    var onLogout: (() -> Void)?

    private let scrollView = UIScrollView()
    private let scanButton = UIButton(type: .system)
    let viewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        buildUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI
    private func buildUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset.bottom = 96   // room for the floating button
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Header: logo + app name
        let logo = UIImageView(image: UIImage(named: "NitvLogo"))
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: 36),
            logo.heightAnchor.constraint(equalToConstant: 36)
        ])
        let appName = makeLabel("NITV EVENTS", font: .systemFont(ofSize: 17, weight: .heavy), color: Theme.blue)
        let header = UIStackView(arrangedSubviews: [logo, appName, UIView(), makeLogoutButton()])
        header.axis = .horizontal
        header.spacing = 8
        header.alignment = .center

        let nowShowing = makeLabel("Now showing · movie", font: .systemFont(ofSize: 14, weight: .semibold), color: Theme.pink)

        let content = UIStackView(arrangedSubviews: [header, nowShowing, buildMovieCard()])
        content.axis = .vertical
        content.spacing = 12
        content.setCustomSpacing(20, after: header)
        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            content.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16)
        ])
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true

        buildScanButton()
    }

    // MARK: - Logout (top-right of header)
    private func makeLogoutButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        button.tintColor = Theme.pink
        button.backgroundColor = Theme.pink.withAlphaComponent(0.1)
        button.layer.cornerRadius = 18
        button.accessibilityLabel = "Log out"
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 36),
            button.heightAnchor.constraint(equalToConstant: 36)
        ])
        return button
    }

    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Log out?",
                                      message: "You will need to sign in again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive) { [weak self] _ in
            self?.onLogout?()
        })
        present(alert, animated: true)
    }

    /// Poster on top, details below, all inside one rounded card.
    private func buildMovieCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.applyCardShadow(opacity: 0.14, radius: 14, offsetY: 6)

        let clip = UIView()
        clip.layer.cornerRadius = 24
        clip.clipsToBounds = true
        card.addSubview(clip)
        clip.pinEdges(to: card)

        // Poster
        let poster = UIImageView(image: UIImage(named: "PensionPattaPoster"))
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        poster.translatesAutoresizingMaskIntoConstraints = false
        let ratio = (poster.image?.size.height ?? 1232) / (poster.image?.size.width ?? 1100)
        poster.heightAnchor.constraint(equalTo: poster.widthAnchor, multiplier: ratio).isActive = true
        poster.isAccessibilityElement = true
        poster.accessibilityLabel = "Pension Patta poster"

        // Details
        let title = makeLabel("Pension Patta", font: .systemFont(ofSize: 24, weight: .bold))

        let star = UIImageView(image: UIImage(systemName: "star.fill"))
        star.tintColor = UIColor(hex: 0xFFB300)
        let clock = UIImageView(image: UIImage(systemName: "clock"))
        clock.tintColor = Theme.textPrimary
        let meta = UIStackView(arrangedSubviews: [
            clock, makeLabel("2h 10m", font: .systemFont(ofSize: 15)),
            dot(), makeLabel("Nepali", font: .systemFont(ofSize: 15)), UIView()
        ])
        meta.axis = .horizontal
        meta.spacing = 4
        meta.alignment = .center

        let genres = UIStackView(arrangedSubviews: [pill("Comedy"), pill("Drama"), UIView()])
        genres.axis = .horizontal
        genres.spacing = 8

        let divider = UIView()
        divider.backgroundColor = Theme.border
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

//        let price = UIStackView(arrangedSubviews: [
//            makeLabel("Tickets from", font: .systemFont(ofSize: 15)),
//            makeLabel("¥ 3000", font: .systemFont(ofSize: 18, weight: .heavy), color: Theme.pink),
//            UIView()
//        ])
//        price.axis = .horizontal
//        price.spacing = 6
//        price.alignment = .firstBaseline

        let pin = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        pin.tintColor = Theme.pink
        pin.contentMode = .scaleAspectFit
        pin.translatesAutoresizingMaskIntoConstraints = false
        pin.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pin.heightAnchor.constraint(equalToConstant: 24).isActive = true
        let venue = UIStackView(arrangedSubviews: [
            makeLabel("Meguro Kumin Centre", font: .systemFont(ofSize: 15, weight: .semibold)),
            makeLabel("2-4-36 Meguro, Meguro-ku", font: .systemFont(ofSize: 13), color: Theme.textSecondary)
        ])
        venue.axis = .vertical
        venue.spacing = 2
        let location = UIStackView(arrangedSubviews: [pin, venue])
        location.axis = .horizontal
        location.spacing = 8
        location.alignment = .top

        let details = UIStackView(arrangedSubviews: [title, meta, genres, divider, location])
        details.axis = .vertical
        details.spacing = 12
        let detailsContainer = UIView()
        detailsContainer.addSubview(details)
        details.pinEdges(to: detailsContainer, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))

        let column = UIStackView(arrangedSubviews: [poster, detailsContainer])
        column.axis = .vertical
        clip.addSubview(column)
        column.pinEdges(to: clip)
        return card
    }

    private func dot() -> UILabel {
        makeLabel("·", font: .systemFont(ofSize: 15, weight: .bold), color: Theme.textSecondary)
    }

    private func pill(_ text: String) -> UILabel {
        let label = PaddingLabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = Theme.deepBlue
        label.backgroundColor = Theme.primaryContainer
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }

    // MARK: - Floating "Scan me" button
    private func buildScanButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Scan me"
        config.image = UIImage(systemName: "qrcode.viewfinder")
        config.imagePadding = 8
        config.baseBackgroundColor = Theme.pink
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 22)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var attrs = attrs
            attrs.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            return attrs
        }
        scanButton.configuration = config
        scanButton.applyCardShadow(opacity: 0.3, radius: 10, offsetY: 5)
        scanButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanButton)
        NSLayoutConstraint.activate([
            scanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func scanTapped() {
        let scanner = ScannerViewController()
        scanner.modalPresentationStyle = .fullScreen
        scanner.onScan = { [weak self] value in
            self?.performScanTicket(ticketID: value)
        }
        present(scanner, animated: true)
    }
    
    func performScanTicket(ticketID: String) {

        let params: [String: Any] = [
            "ticket_id": ticketID
        ]

        viewModel.fetchScannedTicketData(params: params) { [weak self] status, message,_ in

            guard let self = self else { return }

//            DispatchQueue.main.async {

                if status {
                    if self.viewModel.model?.data?.isValid == false {
                       
                        // Show failure popup
                        self.showTicketScanResult(
                            result: .failure,
                            message: self.viewModel.model?.message ?? "",
                            ticketID: ticketID,
                            name: self.viewModel.model?.data?.name ?? "",
                            email: self.viewModel.model?.data?.email ?? "",
                            phone: self.viewModel.model?.data?.phone ?? ""
                        )
                    } else {
                        
                        // Show success popup
                        self.showTicketScanResult(
                            result: .success,
                            message: self.viewModel.model?.message ?? "",
                            ticketID: ticketID,
                            name: self.viewModel.model?.data?.name ?? "",
                            email: self.viewModel.model?.data?.email ?? "",
                            phone: self.viewModel.model?.data?.phone ?? ""
                        )
                    }

                } else {

                    // Show failure popup
                    self.showTicketScanResult(
                        result: .failure,
                        message: self.viewModel.model?.message ?? "",
                        ticketID: ticketID,
                        name: "",
                        email: "",
                        phone: ""
                    )
                }
//            }
        }
    }
    
    private func showTicketScanResult(
        result: TicketScanResultView.ScanResult,
        message: String,
        ticketID: String,
        name: String,
        email: String,
        phone: String
    ) {

        let popup = TicketScanResultView(
            result: result,
            message: message,
            ticketID: ticketID,
            name: name,
            email: email,
            phone: phone
        )

        popup.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(popup)

        NSLayoutConstraint.activate([
            popup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popup.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popup.topAnchor.constraint(equalTo: view.topAnchor),
            popup.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        popup.onDismiss = { [weak popup] in
            popup?.removeFromSuperview()
        }
    }
}
