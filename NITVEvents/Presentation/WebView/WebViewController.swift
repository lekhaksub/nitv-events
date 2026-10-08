import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let urlString: String
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private var progressObservation: NSKeyValueObservation?

    init(urlString: String, title: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Back goes through web history first, then leaves the screen
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadTapped))

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = Theme.blue
        view.addSubview(progressView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: guide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.topAnchor.constraint(equalTo: guide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            DispatchQueue.main.async {
                guard let self else { return }
                let progress = Float(webView.estimatedProgress)
                self.progressView.setProgress(progress, animated: true)
                self.progressView.isHidden = progress >= 1
            }
        }

        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else {
            webView.loadHTMLString("<h3 style='font-family:-apple-system;text-align:center;margin-top:40vh'>Invalid ticket link</h3>", baseURL: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func backTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func reloadTapped() {
        webView.reload()
    }
}
