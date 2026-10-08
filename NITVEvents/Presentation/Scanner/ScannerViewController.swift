import UIKit
import AVFoundation

/// Full-screen QR / barcode scanner (AVFoundation).
final class ScannerViewController: UIViewController {
    var onScan: ((String) -> Void)?
    var ticketID: String = ""
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var didFinish = false
    private let hintLabel = makeLabel("Point the camera at a ticket QR code", font: .systemFont(ofSize: 16, weight: .medium),
                                      color: .white, lines: 0, alignment: .center)

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        buildOverlay()
        checkPermissionAndStart()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }

    // MARK: - Overlay
    private func buildOverlay() {
        let frameView = UIView()
        frameView.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 3
        frameView.layer.cornerRadius = 24
        frameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frameView)

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintLabel)

        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "xmark")
        config.baseBackgroundColor = UIColor.black.withAlphaComponent(0.5)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        let close = UIButton(configuration: config)
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        close.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(close)

        NSLayoutConstraint.activate([
            frameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            frameView.widthAnchor.constraint(equalToConstant: 260),
            frameView.heightAnchor.constraint(equalToConstant: 260),
            hintLabel.topAnchor.constraint(equalTo: frameView.bottomAnchor, constant: 24),
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            close.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Camera
    private func checkPermissionAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.configureSession() : self.showMessage("Camera access is needed to scan tickets.", offerSettings: true)
                }
            }
        default:
            showMessage("Camera access is needed to scan tickets. Enable it in Settings.", offerSettings: true)
        }
    }

    private func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            showMessage("Camera is not available on this device.", offerSettings: false)
            return
        }
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        let wanted: [AVMetadataObject.ObjectType] = [.qr, .ean13, .ean8, .code128, .code39, .pdf417, .aztec, .dataMatrix]
        output.metadataObjectTypes = wanted.filter { output.availableMetadataObjectTypes.contains($0) }

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = view.bounds
        view.layer.insertSublayer(preview, at: 0)
        previewLayer = preview

        let session = self.session
        DispatchQueue.global(qos: .userInitiated).async { session.startRunning() }
    }

    private func stopSession() {
        let session = self.session
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { session.stopRunning() }
        }
    }

    private func showMessage(_ message: String, offerSettings: Bool) {
        let alert = UIAlertController(title: "Scanner", message: message, preferredStyle: .alert)
        if offerSettings {
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
            })
        }
        alert.addAction(UIAlertAction(title: "Close", style: .cancel) { [weak self] _ in self?.dismiss(animated: true) })
        present(alert, animated: true)
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    fileprivate func finish(with value: String) {
        guard !didFinish else { return }
        didFinish = true
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        stopSession()
        print("value: \(value)")
        if let data = value.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            
            print(json["ticket_id"] as? String ?? "")
         ticketID = json["ticket_id"] as? String ?? ""
        }
        dismiss(animated: true) { [onScan] in onScan?(self.ticketID) }
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    nonisolated func metadataOutput(_ output: AVCaptureMetadataOutput,
                                    didOutput metadataObjects: [AVMetadataObject],
                                    from connection: AVCaptureConnection) {
        guard let value = (metadataObjects.first as? AVMetadataMachineReadableCodeObject)?.stringValue else { return }
        Task { @MainActor in self.finish(with: value) }
    }
}
