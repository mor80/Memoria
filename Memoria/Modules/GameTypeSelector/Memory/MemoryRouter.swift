import UIKit

class MemoryGamesRouter: GameTypeRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = MemoryGamesViewController()
        let presenter = MemoryGamesPresenter()
        let interactor = MemoryGamesInteractor()
        let router = MemoryGamesRouter()
        
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
        case "Number Memo":
            let numberMemory = NumberMemoryRouter.createModule()
            viewController?.navigationController?.pushViewController(numberMemory, animated: true)
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
