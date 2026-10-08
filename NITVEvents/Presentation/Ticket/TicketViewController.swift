import UIKit
import Combine

final class TicketViewController: UIViewController {
    private let viewModel: TicketViewModel
    private var cancellables = Set<AnyCancellable>()
    private var tickets: [TicketData] = []

    private let searchField = UITextField()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let messageLabel = makeLabel(font: .systemFont(ofSize: 15), color: Theme.textSecondary, lines: 0, alignment: .center)
    private let spinner = UIActivityIndicatorView(style: .medium)

    init(viewModel: TicketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        buildUI()
//        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI
    private func buildUI() {
        let title = makeLabel("Tickets", font: .systemFont(ofSize: 24, weight: .bold))

        searchField.placeholder = "Search name, ticket ID or phone"
        searchField.font = .systemFont(ofSize: 16)
        searchField.textColor = Theme.textPrimary
        searchField.tintColor = Theme.blue
        searchField.backgroundColor = .white
        searchField.layer.cornerRadius = 16
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = Theme.border.cgColor
        searchField.clearButtonMode = .whileEditing
        searchField.returnKeyType = .search
        searchField.autocorrectionType = .no
        searchField.autocapitalizationType = .none
        searchField.delegate = self
//        searchField.addTarget(self, action: #selector(queryChanged), for: .editingChanged)
        let magnifier = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifier.tintColor = Theme.textSecondary
        magnifier.contentMode = .center
        magnifier.frame = CGRect(x: 0, y: 0, width: 44, height: 52)
        searchField.leftView = magnifier
        searchField.leftViewMode = .always
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.heightAnchor.constraint(equalToConstant: 52).isActive = true

        let header = UIStackView(arrangedSubviews: [title, searchField])
        header.axis = .vertical
        header.spacing = 14
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TicketCell.self, forCellReuseIdentifier: TicketCell.reuseId)
        tableView.contentInset.top = 8
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32),

            spinner.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 24),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Binding
//    private func bind() {
//        viewModel.$state
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] state in self?.render(state) }
//            .store(in: &cancellables)
//    }

//    private func render(_ state: TicketState) {
//        // keeps the field in sync when the query is set from outside (e.g. after a scan)
//        if searchField.text != state.query { searchField.text = state.query }
//
//        tickets = state.results
//        tableView.reloadData()
//
//        state.isLoading ? spinner.startAnimating() : spinner.stopAnimating()
//
//        let message: String?
//        if let error = state.error {
//            message = error
//        } else if state.isLoading {
//            message = nil
//        } else if !state.searched {
//            message = "Search by name, ticket ID or phone number"
//        } else if state.results.isEmpty {
//            message = "No tickets found"
//        } else {
//            message = nil
//        }
//        messageLabel.text = message
//        messageLabel.isHidden = message == nil
//    }

    @objc private func queryChanged() {
//        viewModel.onQueryChange(searchField.text ?? "")
        viewModel.fetchSearchList(searchText: searchField.text ?? "") {_,_,_ in 
            self.tickets = self.viewModel.searchList
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table
extension TicketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tickets.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TicketCell.reuseId, for: indexPath) as! TicketCell
        cell.configure(with: tickets[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ticket = tickets[indexPath.row]
        let web = WebViewController(urlString: ticket.url ?? "", title: "Ticket \(ticket.ticketID ?? "")")
        web.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(web, animated: true)
    }
}

extension TicketViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let query = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        queryChanged()      // your API call, whatever it's named
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        viewModel.onQueryChange("")
        return true
    }
    
    
}
