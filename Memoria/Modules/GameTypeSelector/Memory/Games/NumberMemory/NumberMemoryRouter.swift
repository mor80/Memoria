import UIKit

protocol NumberMemoryRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class NumberMemoryRouter: NumberMemoryRouterProtocol {
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
