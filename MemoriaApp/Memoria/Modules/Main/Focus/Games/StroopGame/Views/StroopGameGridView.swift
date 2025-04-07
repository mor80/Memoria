import UIKit

/// Grid view with four colored buttons for the Stroop Game.
final class StroopGameGridView: UIView {
    
    // MARK: - Public Properties
    
    /// Called when a button with a specific color is tapped.
    var onColorSelected: ((UIColor) -> Void)?
    
    // MARK: - Constants
    
    private enum Constants {
        static let buttonCornerRadius: CGFloat = 30
        static let buttonSpacing: CGFloat = 8
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset: CGSize = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
        static let aspectRatioPriority: Float = 999
    }
    
    // MARK: - UI Elements
    
    private lazy var redButton: UIButton = createColorButton(color: .red)
    private lazy var greenButton: UIButton = createColorButton(color: .green)
    private lazy var blueButton: UIButton = createColorButton(color: .blue)
    private lazy var purpleButton: UIButton = createColorButton(color: .purple)
    
    private lazy var rowStack1: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [redButton, greenButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Constants.buttonSpacing
        return stack
    }()
    
    private lazy var rowStack2: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [blueButton, purpleButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Constants.buttonSpacing
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rowStack1, rowStack2])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = Constants.buttonSpacing
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGrid()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGrid()
    }
    
    // MARK: - Setup
    
    /// Sets up the layout and constraints for the grid of buttons.
    private func setupGrid() {
        addSubview(mainStack)
        mainStack.pinTop(to: topAnchor)
        mainStack.pinBottom(to: bottomAnchor)
        mainStack.pinLeft(to: leadingAnchor)
        mainStack.pinRight(to: trailingAnchor)
        
        [redButton, greenButton, blueButton, purpleButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            let ratioConstraint = button.heightAnchor.constraint(equalTo: button.widthAnchor)
            ratioConstraint.priority = UILayoutPriority(Constants.aspectRatioPriority)
            ratioConstraint.isActive = true
        }
    }
    
    /// Creates and styles a color button.
    /// - Parameter color: The background color of the button.
    /// - Returns: A configured UIButton instance.
    private func createColorButton(color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.layer.shadowColor = Constants.shadowColor
        button.layer.shadowOffset = Constants.shadowOffset
        button.layer.shadowOpacity = Constants.shadowOpacity
        button.layer.shadowRadius = Constants.shadowRadius
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        onColorSelected?(color)
    }
}
