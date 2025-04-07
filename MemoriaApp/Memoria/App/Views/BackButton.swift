import UIKit

/// A custom back button with a system icon.
final class BackButton: UIButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let iconName = "chevron.left"
        static let iconPointSize: CGFloat = 24
        static let iconWeight: UIImage.SymbolWeight = .bold
        static let iconTintColor: UIColor = .systemBlue
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Private Methods
    
    /// Configures the button appearance and sets the icon image.
    private func setupButton() {
        let config = UIImage.SymbolConfiguration(
            pointSize: Constants.iconPointSize,
            weight: Constants.iconWeight
        )
        let image = UIImage(systemName: Constants.iconName, withConfiguration: config)
        setImage(image, for: .normal)
        tintColor = Constants.iconTintColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
