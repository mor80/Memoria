import UIKit

/// Router responsible for navigation in the Achievements module.
class AchievementsRouter: AchievementsRouterProtocol {
    
    // MARK: - VIPER Reference
    
    /// Reference to the view controller to perform navigation.
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    
    /// Creates and returns the view controller for the Achievements module.
    /// - Returns: A `UIViewController` instance for the Achievements module.
    static func createModule() -> UIViewController {
        let view = AchievementsViewController()
        let presenter = AchievementsPresenter()
        let interactor = AchievementsInteractor()
        let router = AchievementsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: - Navigation
    
    /// Navigates back to the previous screen.
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
