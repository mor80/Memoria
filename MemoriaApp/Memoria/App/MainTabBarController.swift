import UIKit

/// The main `UITabBarController` of the app with a custom tab bar and fade transition animation.
final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Constants
    
    private enum TabBarConsts {
        static let mainName: String = "Main"
        static let dailyName: String = "Daily"
        static let profileName: String = "Profile"
        
        static let titleOffsetHorizontal: CGFloat = 0
        static let titleOffsetVertical: CGFloat = 5
        
        static let tabBarFontSize: CGFloat = 14
        static let selectedColor: UIColor = .systemBlue
        static let unselectedColor: UIColor = .gray
        static let backgroundColor: UIColor = .systemBackground
    }
    
    // MARK: - Tab Items
    
    /// Represents the available tab items in the app.
    enum TabBarItem: Int {
        case main
        case dailyTasks
        case profile
        
        var title: String {
            switch self {
            case .main: return TabBarConsts.mainName
            case .dailyTasks: return TabBarConsts.dailyName
            case .profile: return TabBarConsts.profileName
            }
        }
        
        var image: UIImage? {
            switch self {
            case .main: return UIImage(named: TabBarConsts.mainName)
            case .dailyTasks: return UIImage(named: TabBarConsts.dailyName)
            case .profile: return UIImage(named: TabBarConsts.profileName)
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .main: return MainRouter.createModule()
            case .dailyTasks: return DailyTasksRouter.createModule()
            case .profile: return ProfileRouter.createModule()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setValue(CustomTabBar(), forKey: "tabBar")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        delegate = self
    }
    
    // MARK: - Setup
    
    /// Configures the tab bar and its items.
    private func setupTabBar() {
        let tabs: [TabBarItem] = [.main, .dailyTasks, .profile]
        
        viewControllers = tabs.map { tab in
            let viewController = tab.viewController
            viewController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: tab.image,
                tag: tab.rawValue
            )
            viewController.tabBarItem.titlePositionAdjustment = UIOffset(
                horizontal: TabBarConsts.titleOffsetHorizontal,
                vertical: TabBarConsts.titleOffsetVertical
            )
            viewController.tabBarItem.setTitleTextAttributes(
                [.font: UIFont.systemFont(ofSize: TabBarConsts.tabBarFontSize)],
                for: .normal
            )
            return viewController
        }
        
        tabBar.tintColor = TabBarConsts.selectedColor
        tabBar.unselectedItemTintColor = TabBarConsts.unselectedColor
        tabBar.backgroundColor = TabBarConsts.backgroundColor
    }
    
    // MARK: - UITabBarControllerDelegate
    
    /// Returns a custom animator for transitions between tabs.
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator()
    }
}

// MARK: - FadeAnimator

/// A custom animator with fade transition for switching between tabs.
final class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Constants
    
    private enum Constants {
        static let animationDuration: TimeInterval = 0.2
    }
    
    /// The duration of the transition animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.animationDuration
    }
    
    /// Performs the fade animation during the transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let container = transitionContext.containerView
        container.addSubview(toView)
        toView.alpha = 0

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.alpha = 1
                fromView.alpha = 0
            }, completion: { finished in
                fromView.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
