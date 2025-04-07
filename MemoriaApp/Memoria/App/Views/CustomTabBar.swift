import UIKit

/// A custom `UITabBar` with increased height, rounded corners, and shadow.
final class CustomTabBar: UITabBar {
    
    // MARK: - Constants
    
    private enum Constants {
        static let customHeight: CGFloat = 80
        static let horizontalMargin: CGFloat = 20
        static let bottomMargin: CGFloat = 20
        
        static let cornerRadius: CGFloat = 40
        
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset: CGSize = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
        
        static let titleVerticalOffset: CGFloat = -10
    }
    
    // MARK: - Layout
    
    /// Adjusts the tab bar's frame to account for safe area, margins, and rounded design.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }
        
        let safeAreaBottom = window.safeAreaInsets.bottom
        let screenWidth = window.bounds.width
        let screenHeight = window.bounds.height
        let newWidth = screenWidth - (Constants.horizontalMargin * 2)
        let newY = screenHeight - Constants.customHeight - Constants.bottomMargin - safeAreaBottom
        
        frame = CGRect(
            x: Constants.horizontalMargin,
            y: newY,
            width: newWidth,
            height: Constants.customHeight
        )
        
        configureAppearance()
    }
    
    // MARK: - Appearance
    
    /// Configures the tab bar's visual style: rounded corners, shadow, and title offset.
    private func configureAppearance() {
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false
        
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        
        items?.forEach { item in
            item.titlePositionAdjustment = UIOffset(
                horizontal: 0,
                vertical: Constants.titleVerticalOffset
            )
        }
    }
}
