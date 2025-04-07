import UIKit

/// A custom button resembling a gamepad button with tap animations.
class GamepadButton: UIButton {

    // MARK: - Constants

    private struct Constants {
        static let animationDuration: TimeInterval = 0.1
        static let highlightScale: CGFloat = 0.98
        static let highlightAlpha: CGFloat = 0.8
        static let cornerRadius: CGFloat = 35 // Assumes a button size of 60x60
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    // MARK: - Setup Methods

    /// Configures the button's appearance, including background color, corner radius, and shadow.
    private func setupButton() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false
        
        // Shadow configuration
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        
        // Configure image view content mode for button icons.
        imageView?.contentMode = .scaleAspectFit
        
        // Set tint color for button icons.
        tintColor = .systemBlue
    }
    
    // MARK: - Touch Animations
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                animateDown()
            } else {
                animateUp()
            }
        }
    }
    
    /// Animates the button when pressed.
    private func animateDown() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = CGAffineTransform(scaleX: Constants.highlightScale, y: Constants.highlightScale)
            self.alpha = Constants.highlightAlpha
        }
    }
    
    /// Reverts the button animation when released.
    private func animateUp() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = .identity
            self.alpha = 1
        }
    }
}
