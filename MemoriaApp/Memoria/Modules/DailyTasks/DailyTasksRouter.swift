import UIKit

/// Router responsible for creating the DailyTasks module and handling navigation.
class DailyTasksRouter: DailyTasksRouterProtocol {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    
    /// Creates and wires up the VIPER module for DailyTasks.
    /// - Returns: A fully configured `UIViewController` instance.
    static func createModule() -> UIViewController {
        let view = DailyTasksViewController()
        let presenter = DailyTasksPresenter()
        let interactor = DailyTasksInteractor()
        let router = DailyTasksRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
