import UIKit

/// A utility class for creating common UI elements.
final class CommonViews {
    
    // MARK: - Constants
    
    private enum Constants {
        static let defaultStackSpacing: CGFloat = 20
        
        static let titleFontSize: CGFloat = 32
        static let scoreFontSize: CGFloat = 24
        static let startButtonFontSize: CGFloat = 24
        static let startButtonCornerRadius: CGFloat = 10
        static let gamepadButtonCornerRadius: CGFloat = 30
        
        static let titleFontWeight: UIFont.Weight = .bold
        static let scoreFontWeight: UIFont.Weight = .bold
        static let startButtonFontWeight: UIFont.Weight = .bold
        
        static let defaultTitleColor: UIColor = .black
        static let startButtonBackgroundColor: UIColor = .systemBlue
        static let startButtonTitleColor: UIColor = .white
        static let gamepadButtonBackgroundColor: UIColor = .systemGray
        
        static let startButtonTitle: String = "start"
    }
    
    // MARK: - Stack Views
    
    /// Creates a vertical `UIStackView` with optional spacing.
    /// - Parameter spacing: The spacing between arranged subviews. Default is 20.
    /// - Returns: A configured vertical `UIStackView`.
    static func makeVerticalStackView(spacing: CGFloat = Constants.defaultStackSpacing) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    // MARK: - Labels
    
    /// Creates a title `UILabel` with optional text.
    /// - Parameter text: The text to display in the label.
    /// - Returns: A configured title `UILabel`.
    static func makeTitleLabel(text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: Constants.titleFontWeight)
        label.textColor = Constants.defaultTitleColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    /// Creates a bold score `UILabel`.
    /// - Parameter text: The text to display in the label.
    /// - Returns: A configured score `UILabel`.
    static func makeScoreLabel(text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: Constants.scoreFontSize, weight: Constants.scoreFontWeight)
        label.textAlignment = .center
        return label
    }
    
    // MARK: - Buttons
    
    /// Creates a standard "Start" button used in games.
    /// - Returns: A configured `UIButton`.
    static func makeStartButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.startButtonBackgroundColor
        button.setTitle(Constants.startButtonTitle, for: .normal)
        button.setTitleColor(Constants.startButtonTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.startButtonFontSize)
        button.layer.cornerRadius = Constants.startButtonCornerRadius
        return button
    }
    
    /// Creates a round gamepad-style button with a system image.
    /// - Parameter symbol: A `SymbolSequenceSymbol` representing the SF Symbol name.
    /// - Returns: A configured `UIButton`.
    static func makeGamepadButton(symbol: SymbolSequenceSymbol) -> UIButton {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: symbol.sfSymbolName)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = Constants.gamepadButtonBackgroundColor
        button.layer.cornerRadius = Constants.gamepadButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
