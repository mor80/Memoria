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
        
        switch gameName {
        case "Stroop Game":
            let stroopGame = StroopGameRouter.createModule()
            viewController?.navigationController?.pushViewController(stroopGame, animated: true)
        case "Matrix Memo":
            let memoryMatrix = MemoryMatrixRouter.createModule()
            viewController?.navigationController?.pushViewController(memoryMatrix, animated: true)
        case "Sequence Memo":
            let sequenceMemory = SequenceMemoryRouter.createModule()
            viewController?.navigationController?.pushViewController(sequenceMemory, animated: true)
        default:
            break
        }
    }
}
