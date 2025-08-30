import UIKit

final class PulseButton: UIControl {
    enum StateStyle { case idle, recording, processing }

    private let label = UILabel()
    private var pulseLayer: CAShapeLayer?

    var stateStyle: StateStyle = .idle { didSet { applyStyle() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = false
        isExclusiveTouch = true
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        layer.masksToBounds = true

        label.text = "Hold to Speak"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addTarget(self, action: #selector(down), for: [.touchDown])
        addTarget(self, action: #selector(up), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc private func down() { sendActions(for: .primaryActionTriggered) }
    @objc private func up() { sendActions(for: .editingDidEnd) }

    private func applyStyle() {
        switch stateStyle {
        case .idle:
            label.text = "Hold to Speak"
            backgroundColor = .systemGray6
            stopPulse()
        case .recording:
            label.text = "Recording… (release to stop)"
            backgroundColor = .systemRed.withAlphaComponent(0.15)
            startPulse()
        case .processing:
            label.text = "Transcribing…"
            backgroundColor = .systemGray5
            stopPulse()
        }
    }

    private func startPulse() {
        let pulse = CAShapeLayer()
        pulse.frame = bounds
        pulse.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        pulse.fillColor = UIColor.systemRed.withAlphaComponent(0.15).cgColor
        layer.insertSublayer(pulse, below: layer.sublayers?.first)
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0.4
        anim.toValue = 0.9
        anim.duration = 0.8
        anim.autoreverses = true
        anim.repeatCount = .infinity
        pulse.add(anim, forKey: "pulse")
        pulseLayer = pulse
    }

    private func stopPulse() {
        pulseLayer?.removeAllAnimations()
        pulseLayer?.removeFromSuperlayer()
        pulseLayer = nil
    }
}