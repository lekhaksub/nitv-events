import UIKit

final class SplashViewController: UIViewController {
    var onFinished: (() -> Void)?

    private let stack = UIStackView()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        let background = GradientView()
        view.addSubview(background)
        background.pinEdges(to: view)

        let title = makeLabel("NITV EVENTS", font: .systemFont(ofSize: 30, weight: .heavy), color: .white, alignment: .center)
        title.attributedText = NSAttributedString(string: "NITV EVENTS", attributes: [
            .kern: 3, .font: UIFont.systemFont(ofSize: 30, weight: .heavy), .foregroundColor: UIColor.white
        ])
        let subtitle = makeLabel("Movies · Shows · Tickets", font: .systemFont(ofSize: 15), color: UIColor.white.withAlphaComponent(0.8), alignment: .center)

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.addArrangedSubview(makeLogoBadge(size: 128))
        stack.setCustomSpacing(24, after: stack.arrangedSubviews[0])
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(subtitle)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        stack.alpha = 0
        stack.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
            self.stack.alpha = 1
            self.stack.transform = .identity
        }
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 2_200_000_000)
            self?.onFinished?()
        }
    }
}
