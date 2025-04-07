import UIKit

/// A view displayed when the game is over, showing the result and providing a restart option.
final class GameOverView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let highlightScale: CGFloat = 0.98
        static let highlightAlpha: CGFloat = 0.8
        static let animationDuration: TimeInterval = 0.1
        
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }
    
    // MARK: - Callbacks
    
    /// Callback triggered when the restart button is tapped.
    var onRestart: (() -> Void)?
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Game Over"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let restartButton = AnimatedButton(title: "Restart")
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        addSubview(containerView)
        containerView.addSubview(resultLabel)
        containerView.addSubview(restartButton)
        
        // Setup constraints.
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        ])
        
        resultLabel.pinTop(to: containerView.topAnchor, 20)
        resultLabel.pinLeft(to: containerView.leadingAnchor, 20)
        resultLabel.pinRight(to: containerView.trailingAnchor, 20)
        
        restartButton.pinTop(to: resultLabel.bottomAnchor, 20)
        restartButton.pinCenterX(to: containerView.centerXAnchor)
        restartButton.setWidth(120)
        restartButton.setHeight(45)
        restartButton.pinBottom(to: containerView.bottomAnchor, 20)
        
        restartButton.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
    }
    
    /// Handles the restart button tap event.
    @objc private func restartTapped() {
        onRestart?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    /// Sets the result text to display on the Game Over view.
    /// - Parameter text: The result text.
    func setResultText(_ text: String) {
        resultLabel.text = text
    }
}
