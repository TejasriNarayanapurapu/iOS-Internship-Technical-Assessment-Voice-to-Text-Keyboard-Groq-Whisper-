import UIKit
import AVFoundation

final class KeyboardViewController: UIInputViewController {
    private let button = PulseButton()
    private let spinner = SpinnerView()
    private let recorder = AudioRecorder()

    private var whisper: GroqWhisperService {
        let key = UserDefaults(suiteName: Shared.appGroupId)?.string(forKey: Shared.Keys.groqApiKey)
        return GroqWhisperService(apiKey: key)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        button.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.isHidden = true

        view.addSubview(button)
        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 220),

            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 80),

            spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinner.topAnchor.constraint(equalTo: view.topAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        button.addTarget(self, action: #selector(onHoldDown), for: .primaryActionTriggered)
        button.addTarget(self, action: #selector(onHoldUp), for: .editingDidEnd)
    }

    @objc private func onHoldDown() {
        Task { @MainActor in
            button.stateStyle = .recording
            do {
                try recorder.beginRecording()
            } catch {
                self.presentToast("Mic error: \(error.localizedDescription)")
                self.button.stateStyle = .idle
            }
        }
    }

    @objc private func onHoldUp() {
        recorder.endRecording()
        button.stateStyle = .processing
        spinner.isHidden = false

        guard let url = recorder.currentFileURL else {
            self.presentToast("No audio captured.")
            self.resetUI()
            return
        }

        Task {
            do {
                let text = try await whisper.transcribe(fileURL: url, language: nil)
                await MainActor.run {
                    self.textDocumentProxy.insertText(text)
                    self.presentToast("Inserted transcription")
                    self.resetUI()
                }
            } catch {
                await MainActor.run {
                    self.presentToast(error.localizedDescription)
                    self.resetUI()
                }
            }
        }
    }

    private func resetUI() {
        spinner.isHidden = true
        button.stateStyle = .idle
    }
}

extension UIInputViewController {
    func presentToast(_ message: String) {
        let label = UILabel()
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -12)
        ])

        UIView.animate(withDuration: 0.25, animations: { label.alpha = 1 }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.25, animations: { label.alpha = 0 }) { _ in label.removeFromSuperview() }
            }
        }
    }
}