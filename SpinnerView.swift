import UIKit

final class SpinnerView: UIView {
    private let ai = UIActivityIndicatorView(style: .large)
    override init(frame: CGRect) {
        super.init(frame: frame)
        ai.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ai)
        NSLayoutConstraint.activate([
            ai.centerXAnchor.constraint(equalTo: centerXAnchor),
            ai.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        ai.startAnimating()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}