import UIKit

final class AuthButton: UIControl {
    
    // MARK: - Constants
    
    /// Constants used for button configuration and animation.
    private enum Constants {
        static let cornerRadius: CGFloat = 30
        static let highlightScale: CGFloat = 0.98
        static let highlightAlpha: CGFloat = 0.8
        static let animationDuration: TimeInterval = 0.1
        
        // Shadow properties
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }
    
    // MARK: - State
    
    /// Represents the state of the button (Login or Register).
    private var isLogin = true
    
    // MARK: - Subviews (only title in the center)
    
    /// Title label displayed in the center of the button.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    /// Initializes the button with a frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// Initializes the button from the coder.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - UI Setup
    
    /// Configures the appearance of the button.
    private func setupView() {
        layer.cornerRadius = Constants.cornerRadius
        
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        
        clipsToBounds = false
        layer.masksToBounds = false
        
        // Initial state
        backgroundColor = .systemGreen
        
        addSubview(titleLabel)
        // Centering titleLabel within the button
        titleLabel.pinCenter(to: self)
    }
    
    // MARK: - Public Configuration
    
    /// Configures the button with a title and state (Login or Register).
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - isLogin: A boolean indicating if the button is for login or not.
    func configure(title: String, isLogin: Bool) {
        self.isLogin = isLogin
        titleLabel.text = title
        backgroundColor = isLogin ? .systemGreen : .systemRed
    }
    
    /// Public getter to know the current state (Login or Register).
    /// - Returns: Boolean value representing if the button is for login.
    func isLoginButton() -> Bool {
        return isLogin
    }
    
    // MARK: - Highlight Animation
    
    /// Handles the animation when the button is highlighted (pressed).
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                animateDown()
            } else {
                animateUp()
            }
        }
    }
    
    /// Animates the button when it is pressed down.
    private func animateDown() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = CGAffineTransform(
                scaleX: Constants.highlightScale,
                y: Constants.highlightScale
            )
            self.alpha = Constants.highlightAlpha
        }
    }
    
    /// Animates the button when it is released (up).
    private func animateUp() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = .identity
            self.alpha = 1
        }
    }
}
