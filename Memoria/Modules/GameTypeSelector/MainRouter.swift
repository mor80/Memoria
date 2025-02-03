import UIKit

protocol MainRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToGameType(_ type: String)
}

class MainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let router = MainRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToGameType(_ type: String) {
        print("Navigating to \(type)")
        
        switch type {
        case "Memory":
            let memoryGamesModule = MemoryGamesRouter.createModule()
            viewController?.navigationController?.pushViewController(memoryGamesModule, animated: true)
        case "Focus":
            let focusGamesModule = FocusGamesRouter.createModule()
            viewController?.navigationController?.pushViewController(focusGamesModule, animated: true)
        case "Reaction":
            let reactionGamesModule = ReactionGamesRouter.createModule()
            viewController?.navigationController?.pushViewController(reactionGamesModule, animated: true)
        default:
            break
        }
    }
}
