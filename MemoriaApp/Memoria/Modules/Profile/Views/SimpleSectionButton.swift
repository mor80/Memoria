import UIKit

final class SimpleSectionButton: UIControl {
    
    // MARK: - Constants
    
    /// Constants used for button configuration and animation.
    private enum Constants {
        // Sizes and paddings
        static let cornerRadius: CGFloat = 30
        static let iconSize: CGFloat = 40
        static let horizontalPadding: CGFloat = 30
        
        // Animation
        static let highlightScale: CGFloat = 0.98
        static let highlightAlpha: CGFloat = 0.8
        static let animationDuration: TimeInterval = 0.1
        
        // Shadow properties (for the button)
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }
    
    // MARK: - Subviews
    
    /// Title label for the button.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black    // Title – black
        return label
    }()
    
    /// Icon image view for the button.
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        // Icon – systemBlue (assuming it's SF Symbol or .alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
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
        // Background color and rounded corners
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        // Shadow properties
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        
        // To prevent shadow clipping
        clipsToBounds = false
        layer.masksToBounds = false
        
        // Adding subviews
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        iconImageView.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false
        
        // Positioning the icon on the right
        iconImageView.pinRight(to: self, Constants.horizontalPadding)
        iconImageView.pinCenterY(to: self)
        iconImageView.setWidth(Constants.iconSize)
        iconImageView.setHeight(Constants.iconSize)
        
        // Positioning the title on the left
        titleLabel.pinLeft(to: self, Constants.horizontalPadding)
        titleLabel.pinCenterY(to: self)
        
        // To prevent text from overlapping the icon, limit it to the right:
        titleLabel.pinRight(to: iconImageView.leadingAnchor, 10)
    }
    
    // MARK: - Public Method for Data Setup
    
    /// Configures the button with title and icon.
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - icon: The icon image for the button.
    func configure(title: String, icon: UIImage?) {
        titleLabel.text = title
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
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
