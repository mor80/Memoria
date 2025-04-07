import UIKit

/// Overlay view that displays a start button covering the entire screen.
final class GameStartOverlay: UIView {
    
    // MARK: - Callbacks
    
    /// Callback triggered when the start button is tapped.
    var onStart: (() -> Void)?
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "START"
        static let titleFontSize: CGFloat = 32
        static let titleColor: UIColor = .black
        static let backgroundAlpha: CGFloat = 0.3
    }
    
    // MARK: - UI Elements
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        button.setTitleColor(Constants.titleColor, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(Constants.backgroundAlpha)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add and constrain the start button to cover the entire view.
        addSubview(startButton)
        startButton.pinLeft(to: leadingAnchor)
        startButton.pinRight(to: trailingAnchor)
        startButton.pinTop(to: topAnchor)
        startButton.pinBottom(to: bottomAnchor)
        
        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
    }
    
    /// Handles the start button tap event.
    @objc private func didTapStart() {
        onStart?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
