import UIKit

enum Theme {
    static let blue = UIColor(hex: 0x1E88E5)
    static let deepBlue = UIColor(hex: 0x0B3C6F)
    static let pink = UIColor(hex: 0xF72585)
    static let background = UIColor(hex: 0xF5F8FC)
    static let primaryContainer = UIColor(hex: 0xDCEBFA)
    static let border = UIColor(hex: 0xD6DEE8)
    static let textPrimary = UIColor(hex: 0x15202B)
    static let textSecondary = UIColor(hex: 0x6B7785)
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
}

/// Vertical gradient background.
final class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }

    init(top: UIColor = Theme.deepBlue, bottom: UIColor = Theme.blue) {
        super.init(frame: .zero)
        let gradient = layer as! CAGradientLayer
        gradient.colors = [top.cgColor, bottom.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

/// Label with content insets (used for genre pills).
final class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}

extension UIView {
    func applyCardShadow(opacity: Float = 0.12, radius: CGFloat = 12, offsetY: CGFloat = 4) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: offsetY)
    }

    func pinEdges(to other: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom)
        ])
    }
}

func makeLabel(_ text: String = "", font: UIFont, color: UIColor = Theme.textPrimary, lines: Int = 1, alignment: NSTextAlignment = .natural) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = color
    label.numberOfLines = lines
    label.textAlignment = alignment
    return label
}

/// White circle holding the NITV logo.
func makeLogoBadge(size: CGFloat) -> UIView {
    let circle = UIView()
    circle.backgroundColor = .white
    circle.layer.cornerRadius = size / 2
    circle.applyCardShadow(opacity: 0.25, radius: 10, offsetY: 4)
    circle.translatesAutoresizingMaskIntoConstraints = false

    let imageView = UIImageView(image: UIImage(named: "NitvLogo"))
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    circle.addSubview(imageView)

    let inset = size * 0.2
    NSLayoutConstraint.activate([
        circle.widthAnchor.constraint(equalToConstant: size),
        circle.heightAnchor.constraint(equalToConstant: size),
        imageView.topAnchor.constraint(equalTo: circle.topAnchor, constant: inset),
        imageView.bottomAnchor.constraint(equalTo: circle.bottomAnchor, constant: -inset),
        imageView.leadingAnchor.constraint(equalTo: circle.leadingAnchor, constant: inset),
        imageView.trailingAnchor.constraint(equalTo: circle.trailingAnchor, constant: -inset)
    ])
    return circle
}
