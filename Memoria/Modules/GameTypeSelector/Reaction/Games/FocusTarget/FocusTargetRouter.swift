import UIKit

class FocusTargetRouter: FocusTargetRouterProtocol {
    static func createModule() -> UIViewController {
        let view = FocusTargetViewController()
        let presenter = FocusTargetPresenter()
        let interactor = FocusTargetInteractor()
        let router = FocusTargetRouter()
        
        // Связываем
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }
}
