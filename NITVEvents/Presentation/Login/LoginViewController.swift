import UIKit
import Combine

/// Text field with a leading SF Symbol and rounded border.
final class InputField: UITextField {
    init(placeholder: String, icon: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        font = .systemFont(ofSize: 16)
        textColor = Theme.textPrimary
        tintColor = Theme.blue
        backgroundColor = Theme.background
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = Theme.border.cgColor
        autocorrectionType = .no
        autocapitalizationType = .none
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 52).isActive = true

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = Theme.blue
        iconView.contentMode = .center
        iconView.frame = CGRect(x: 0, y: 0, width: 46, height: 52)
        leftView = iconView
        leftViewMode = .always
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class LoginViewController: UIViewController, UITextFieldDelegate {
    var onLoginSuccess: (() -> Void)?

    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = UIScrollView()
    private let emailField = InputField(placeholder: "Email", icon: "envelope.fill")
    private let passwordField = InputField(placeholder: "Password", icon: "lock.fill")
    private let eyeButton = UIButton(type: .system)
    private let errorLabel = makeLabel(font: .systemFont(ofSize: 13), color: .systemRed, lines: 0)
    private let loginButton = UIButton(type: .system)

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }

    // MARK: - UI
    private func buildUI() {
        let background = GradientView()
        view.addSubview(background)
        background.pinEdges(to: view)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])

        // Header
        let logoWrapper = UIView()
        let logo = makeLogoBadge(size: 96)
        logoWrapper.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: logoWrapper.topAnchor),
            logo.bottomAnchor.constraint(equalTo: logoWrapper.bottomAnchor),
            logo.centerXAnchor.constraint(equalTo: logoWrapper.centerXAnchor)
        ])
        let title = makeLabel(font: .systemFont(ofSize: 26, weight: .heavy), color: .white, alignment: .center)
        title.attributedText = NSAttributedString(string: "NITV EVENTS", attributes: [
            .kern: 2, .font: UIFont.systemFont(ofSize: 26, weight: .heavy), .foregroundColor: UIColor.white
        ])
        let tagline = makeLabel("Your tickets, one tap away", font: .systemFont(ofSize: 15),
                                color: UIColor.white.withAlphaComponent(0.8), alignment: .center)

        // Card
        let card = buildCard()

        let stack = UIStackView(arrangedSubviews: [logoWrapper, title, tagline, card])
        stack.axis = .vertical
        stack.spacing = 6
        stack.setCustomSpacing(16, after: logoWrapper)
        stack.setCustomSpacing(32, after: tagline)
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 64),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -24)
        ])
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
    }

    private func buildCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 28
        card.applyCardShadow(opacity: 0.25, radius: 16, offsetY: 8)

        let heading = makeLabel("Welcome back", font: .systemFont(ofSize: 24, weight: .bold))
        let sub = makeLabel("Sign in to continue", font: .systemFont(ofSize: 15), color: Theme.textSecondary)

        emailField.keyboardType = .emailAddress
        emailField.textContentType = .username
        emailField.returnKeyType = .next
        emailField.delegate = self
        emailField.addTarget(self, action: #selector(inputChanged), for: .editingChanged)

        passwordField.isSecureTextEntry = true
        passwordField.textContentType = .password
        passwordField.returnKeyType = .done
        passwordField.delegate = self
        passwordField.addTarget(self, action: #selector(inputChanged), for: .editingChanged)

        eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeButton.tintColor = Theme.textSecondary
        eyeButton.frame = CGRect(x: 0, y: 0, width: 46, height: 52)
        eyeButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        passwordField.rightView = eyeButton
        passwordField.rightViewMode = .always

        errorLabel.isHidden = true

        var config = UIButton.Configuration.filled()
        config.title = "Login"
        config.baseBackgroundColor = Theme.blue
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var attrs = attrs
            attrs.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            return attrs
        }
        loginButton.configuration = config
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

        let inner = UIStackView(arrangedSubviews: [heading, sub, emailField, passwordField, errorLabel, loginButton])
        inner.axis = .vertical
        inner.spacing = 14
        inner.setCustomSpacing(4, after: heading)
        inner.setCustomSpacing(20, after: sub)
        card.addSubview(inner)
        inner.pinEdges(to: card, insets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
        return card
    }

    private func render(_ state: LoginState) {
        errorLabel.text = state.error
        errorLabel.isHidden = state.error == nil
        loginButton.isEnabled = !state.isLoading
        loginButton.configuration?.showsActivityIndicator = state.isLoading
        loginButton.configuration?.title = state.isLoading ? "" : "Login"
    }

    // MARK: - Actions
    @objc private func inputChanged() {
//        viewModel.clearError()
    }

    @objc private func togglePassword() {
        let text = passwordField.text
        let show = passwordField.isSecureTextEntry
        passwordField.isSecureTextEntry = !show
        passwordField.text = nil
        passwordField.text = text   // avoids the text being cleared when toggling secure entry
        eyeButton.setImage(UIImage(systemName: show ? "eye.slash.fill" : "eye.fill"), for: .normal)
    }

    @objc private func loginTapped() {
        view.endEditing(true)
        
        let params: [String: Any] = ["email": /*emailField.text ??*/ "eventadmin@newitventure.com",
                                     "password":/* passwordField.text ??*/ "admin_nitv_6060##"]
        
        viewModel.postLogin(params: params) { status, message, statusCode in
            if status{
                self.onLoginSuccess!()
            }
            else{
                
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField {
            passwordField.becomeFirstResponder()
        } else {
            loginTapped()
        }
        return true
    }
}
