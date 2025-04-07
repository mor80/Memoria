import UIKit

final class SectionButton: UIControl {
    
    // MARK: - Constants
    
    private enum Constants {
        // Sizes and paddings
        static let cornerRadius: CGFloat = 30
        static let iconSize: CGFloat = 60
        static let horizontalPadding: CGFloat = 30
        static let interLabelSpacing: CGFloat = 2
        
        // Animation
        static let highlightScale: CGFloat = 0.98
        static let highlightAlpha: CGFloat = 0.8
        static let animationDuration: TimeInterval = 0.1
        
        // Shadow
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }
    
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    /// Stack to hold title and description labels
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = Constants.interLabelSpacing
        return stack
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Appearance
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        // Shadow
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        clipsToBounds = false
        layer.masksToBounds = false
        
        // Add subviews
        addSubview(iconImageView)
        addSubview(textStack)
        
        iconImageView.isUserInteractionEnabled = false
        textStack.isUserInteractionEnabled = false
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        
        iconImageView.pinRight(to: self, Constants.horizontalPadding)
        iconImageView.pinCenterY(to: self)
        iconImageView.setWidth(Constants.iconSize)
        iconImageView.setHeight(Constants.iconSize)
        
        textStack.pinLeft(to: self, Constants.horizontalPadding)
        textStack.pinCenterY(to: self)
        
        textStack.pinRight(to: iconImageView.leadingAnchor, 10)
    }
    
    // MARK: - Public Method for Setting Data
    
    func configure(title: String, description: String, icon: UIImage?) {
        titleLabel.text = title
        descriptionLabel.text = description
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
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
    
    private func animateDown() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = CGAffineTransform(
                scaleX: Constants.highlightScale,
                y: Constants.highlightScale
            )
            self.alpha = Constants.highlightAlpha
        }
    }
    
    private func animateUp() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.transform = .identity
            self.alpha = 1
        }
    }
}
