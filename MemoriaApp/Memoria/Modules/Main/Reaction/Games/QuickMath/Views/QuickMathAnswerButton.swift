import UIKit

/// A custom button used for quick math answers with tap animations.
class QuickMathAnswerButton: UIButton {
    
    // MARK: - Constants
    
    private struct Constants {
        static let animationDuration: TimeInterval = 0.1
        static let highlightScale: CGFloat = 0.98
        static let highlightAlpha: CGFloat = 0.8
        static let cornerRadius: CGFloat = 35 // For a 70x70 button
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
    
    /// Configures the button's appearance and style.
    private func setupButton() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false
        
        // Shadow settings
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
