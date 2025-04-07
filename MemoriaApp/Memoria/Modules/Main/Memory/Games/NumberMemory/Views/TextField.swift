import UIKit

/// Custom UITextField with a black bottom line.
final class BlackLineTextField: UITextField {
    
    // MARK: - Constants
    
    private enum Constants {
        static let lineHeight: CGFloat = 2
        static let fontSize: CGFloat = 32
    }
    
    // MARK: - Subviews
    
    private let bottomBorder = CALayer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        borderStyle = .none
        textAlignment = .center
        keyboardType = .default
        font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .bold)
        
        bottomBorder.backgroundColor = UIColor.black.cgColor
        layer.addSublayer(bottomBorder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(
            x: 0,
            y: bounds.height - Constants.lineHeight,
            width: bounds.width,
            height: Constants.lineHeight
        )
    }
}
