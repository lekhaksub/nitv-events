import UIKit

final class TicketCell: UITableViewCell {
    static let reuseId = "TicketCell"

    private let card = UIView()
    private let nameLabel = makeLabel(font: .systemFont(ofSize: 17, weight: .bold))
    private let idLabel = makeLabel(font: .systemFont(ofSize: 15))
    private let phoneLabel = makeLabel(font: .systemFont(ofSize: 13), color: Theme.textSecondary)
    private let showLabel = makeLabel(font: .systemFont(ofSize: 12, weight: .medium), color: Theme.pink)
    private let statusLabel = makeLabel(font: .systemFont(ofSize: 12, weight: .semibold), color: Theme.blue)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        buildUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func buildUI() {
        card.backgroundColor = .white
        card.layer.cornerRadius = 18
        card.applyCardShadow(opacity: 0.1, radius: 8, offsetY: 3)
        contentView.addSubview(card)
        card.pinEdges(to: contentView, insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))

        let iconBg = UIView()
        iconBg.backgroundColor = Theme.primaryContainer
        iconBg.layer.cornerRadius = 24
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImageView(image: UIImage(systemName: "ticket.fill"))
        icon.tintColor = Theme.blue
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(icon)
        NSLayoutConstraint.activate([
            iconBg.widthAnchor.constraint(equalToConstant: 48),
            iconBg.heightAnchor.constraint(equalToConstant: 48),
            icon.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24)
        ])

        let texts = UIStackView(arrangedSubviews: [nameLabel, idLabel, phoneLabel, showLabel])
        texts.axis = .vertical
        texts.spacing = 2
        texts.setCustomSpacing(6, after: phoneLabel)

        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = Theme.textSecondary
        chevron.setContentHuggingPriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [iconBg, texts, statusLabel, chevron])
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center
        card.addSubview(row)
        row.pinEdges(to: card, insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }

    func configure(with ticket: TicketData) {
        nameLabel.text = ticket.name
        idLabel.text = "ID: \(ticket.ticketID ?? "")"
        phoneLabel.text = ticket.phone
//        showLabel.text = ticket.show.isEmpty ? nil : "\(ticket.event) · \(ticket.show)"
        showLabel.isHidden = true
        statusLabel.text = ticket.status
    }
}
