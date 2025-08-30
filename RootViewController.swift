import UIKit

final class RootViewController: UIViewController {
    private let field = UITextField()
    private let save = UIButton(type: .system)
    private let status = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        field.placeholder = "Paste Groq API Key"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.text = SecretsStore.shared.loadGroqKey()

        save.setTitle("Save", for: .normal)
        save.addTarget(self, action: #selector(onSave), for: .touchUpInside)

        status.textColor = .secondaryLabel
        status.numberOfLines = 0
        status.text = "Saved key is shared with the keyboard via App Group."

        let stack = UIStackView(arrangedSubviews: [field, save, status])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func onSave() {
        SecretsStore.shared.saveGroqKey(field.text ?? "")
        let alert = UIAlertController(title: "Saved", message: "Your Groq API key is now available to the keyboard extension.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}