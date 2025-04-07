import UIKit

// MARK: - Router Implementation
/// Router responsible for navigating between the Statistics module screens.
class StatisticsRouter: StatisticsRouterProtocol {
    
    /// A reference to the view controller for navigation.
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    
    /// Creates and returns the complete Statistics module (view + VIPER stack).
    /// - Returns: A `UIViewController` instance representing the statistics module.
    static func createModule() -> UIViewController {
        let view = StatisticsViewController()
        let presenter = StatisticsPresenter()
        let interactor = StatisticsInteractor()
        let router = StatisticsRouter()
        
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
    
    /// Navigates back to the previous screen.
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
