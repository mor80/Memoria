import UIKit

/// Router responsible for creating and assembling the Number Memory module.
final class NumberMemoryRouter: NumberMemoryRouterProtocol {
    
    // MARK: - Module Creation
    
    /// Creates and returns the NumberMemory module.
    /// - Returns: Configured UIViewController instance for NumberMemory.
    static func createModule() -> UIViewController {
        let view = NumberMemoryViewController()
        let presenter = NumberMemoryPresenter()
        let interactor = NumberMemoryInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
