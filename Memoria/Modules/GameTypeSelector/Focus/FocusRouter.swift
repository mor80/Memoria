import UIKit

class FocusGamesRouter: GameTypeRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = FocusGamesViewController()
        let presenter = FocusGamesPresenter()
        let interactor = FocusGamesInteractor()
        let router = FocusGamesRouter()
        
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
