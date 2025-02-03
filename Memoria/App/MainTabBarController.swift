import UIKit

class MainTabBarController: UITabBarController {
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
            case .dailyTasks: return UINavigationController(rootViewController: DailyTasksViewController())
            case .profile: return UINavigationController(rootViewController: ProfileViewController())
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let tabs: [TabBarItem] = [.main, .dailyTasks, .profile]
        viewControllers = tabs.map { tab in
            let viewController = tab.viewController
            viewController.tabBarItem = UITabBarItem(title: tab.title, image: tab.image, tag: tab.rawValue)
            viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: TabBarConsts.titleOffsetH, vertical: TabBarConsts.titleOffsetV)
            
            viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: SharedConsts.smallFontSize)], for: .normal)
            
            return viewController
        }
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .systemBackground
    }
}

class DailyTasksViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Daily"
    }
}

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"
    }
}
