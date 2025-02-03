import UIKit

class ReactionGamesRouter: GameTypeRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = ReactionGamesViewController()
        let presenter = ReactionGamesPresenter()
        let interactor = ReactionGamesInteractor()
        let router = ReactionGamesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToGameDetail(gameName: String) {
        print("Navigating to game: \(gameName)")
        // Здесь будет переход на экран конкретной игры
    }
}
