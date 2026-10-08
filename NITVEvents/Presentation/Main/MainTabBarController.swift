import UIKit

/// Bottom navigation: Home | Ticket
final class MainTabBarController: UITabBarController {

    /// Called when the user confirms logout on Home. AppRouter handles the rest.
    var onLogout: (() -> Void)?

    init(container: AppContainer) {
        super.init(nibName: nil, bundle: nil)

        let ticketViewModel = container.makeTicketViewModel()

        let home = HomeViewController()
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.setNavigationBarHidden(true, animated: false)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let ticket = TicketViewController(viewModel: ticketViewModel)
        let ticketNav = UINavigationController(rootViewController: ticket)
        ticketNav.setNavigationBarHidden(true, animated: false)
        ticketNav.tabBarItem = UITabBarItem(title: "Ticket", image: UIImage(systemName: "ticket"), selectedImage: UIImage(systemName: "ticket.fill"))

        // A scanned code becomes the ticket search text
//        home.onScanned = { [weak self, weak ticketViewModel] value in
//            ticketViewModel?.onQueryChange(value)
//            self?.selectedIndex = 1
//        }

        // Logout tapped on Home -> pass it up to AppRouter
        home.onLogout = { [weak self] in self?.onLogout?() }

        viewControllers = [homeNav, ticketNav]
        tabBar.tintColor = Theme.blue
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
