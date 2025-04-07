import UIKit

class ProfileRouter: ProfileRouterProtocol {
    
    // MARK: - VIPER References
    
    /// A reference to the view controller for navigation.
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    
    /// Creates and returns the complete Profile module (view + VIPER stack).
    /// - Returns: A `UIViewController` instance representing the Profile module.
    static func createModule() -> UIViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor()
        let router = ProfileRouter()
        
        // Setting up VIPER connections
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: - Navigation
    
    /// Navigates to a specific profile section.
    /// - Parameters:
    ///   - section: The selected profile section to navigate to.
    ///   - view: The view from which to navigate.
    func navigateToSection(_ section: ProfileSection, from view: ProfileViewProtocol) {
        // Implement navigation to the selected profile section (e.g., achievements, statistics)
        print("Navigating to: \(section.rawValue)")
        
        switch section {
        case .achievements:
            let achievements = AchievementsRouter.createModule()
            viewController?.navigationController?.pushViewController(achievements, animated: true)
        case .statistics:
            let statistics = StatisticsRouter.createModule()
            viewController?.navigationController?.pushViewController(statistics, animated: true)
        }
    }
    
    /// Navigates to the authentication screen (login or logout).
    /// - Parameters:
    ///   - view: The view from which to navigate.
    func navigateToAuth(from view: ProfileViewProtocol) {
        let authVC = AuthRouter.createModule(delegate: view as? AuthModuleDelegate)
        viewController?.present(authVC, animated: true, completion: nil)
    }
}
