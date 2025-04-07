import UIKit

/// A custom animated button that scales and changes opacity when highlighted.
final class AnimatedButton: UIButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let highlightScale: CGFloat = 0.98
        static let highlightAlpha: CGFloat = 0.8
        static let animationDuration: TimeInterval = 0.1
        
        // Shadow properties
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
        
        static let cornerRadius: CGFloat = 8
        static let titleFontSize: CGFloat = 18
    }
    
    // MARK: - Initializers
    
    /// Initializes the animated button with a custom title.
    /// - Parameter title: The title to display on the button.
    init(title: String) {
        super.init(frame: .zero)
        setupStyle(title)
    }
    
    /// Initializes the animated button with a frame, using a default title.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle("Restart")
    }
    
    /// Initializes the animated button from a storyboard or nib.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle("Restart")
    }
    
    // MARK: - Private Methods
    
    /// Configures the button's style.
    /// - Parameter title: The title to display on the button.
    private func setupStyle(_ title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        setTitleColor(.white, for: .normal)
        
        backgroundColor = .systemBlue
        layer.cornerRadius = Constants.cornerRadius
        
        // Configure shadow
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        clipsToBounds = false
        layer.masksToBounds = false
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Highlight Animation
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                animateDown()
            } else {
                animateUp()
            }
        }
    }
    
    /// Animates the button to a highlighted state.
    private func animateDown() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = CGAffineTransform(scaleX: Constants.highlightScale,
                                               y: Constants.highlightScale)
            self.alpha = Constants.highlightAlpha
        }
    }
    
    /// Animates the button back to its normal state.
    private func animateUp() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = .identity
            self.alpha = 1
        }
    }
}
