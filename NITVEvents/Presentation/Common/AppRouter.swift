import UIKit

/// Owns the root view controller: Splash -> Login -> Main.
@MainActor
final class AppRouter {
    private let window: UIWindow
    private let container: AppContainer

    init(window: UIWindow, container: AppContainer) {
        self.window = window
        self.container = container
    }

    func start() {
        showSplash()
    }

    private func showSplash() {
        let splash = SplashViewController()
        splash.onFinished = { [weak self] in
            if let token = UserProfile().getToken(), token.isEmpty == false {
                self?.showMain()
            } else {
                self?.showLogin()
            }
        }
        setRoot(splash, animated: false)
    }

    private func showLogin() {
        let login = LoginViewController(viewModel: container.makeLoginViewModel())
        login.onLoginSuccess = { [weak self] in self?.showMain() }
        setRoot(login, animated: true)
    }

    private func showMain() {
        let main = MainTabBarController(container: container)
        main.onLogout = { [weak self] in self?.logout() }
        setRoot(MainTabBarController(container: container), animated: true)
    }
    
    private func logout() {
        container.logout()          // clear token / session (see step 3)
        showLogin()                 // swaps the root back to Login with the cross-dissolve
    }
    

    private func setRoot(_ viewController: UIViewController, animated: Bool) {
        guard animated else {
            window.rootViewController = viewController
            return
        }
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
            self.window.rootViewController = viewController
        }
    }
}
