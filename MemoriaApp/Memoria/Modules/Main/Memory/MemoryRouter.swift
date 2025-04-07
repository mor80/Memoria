import UIKit

/// Router responsible for assembling the Memory Games module and handling navigation to specific games.
final class MemoryGamesRouter: GameTypeRouterProtocol {
    
    // MARK: - VIPER Reference

    weak var viewController: UIViewController?

    // MARK: - Constants

    private enum Constants {
        static let numberMemory = "Number Memory"
        static let matrixMemory = "Matrix Memory"
        static let sequenceMemory = "Sequence Memory"
    }

    // MARK: - GameTypeRouterProtocol

    /// Assembles and returns the Memory Games module.
    /// - Returns: A configured `UIViewController` instance.
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

    /// Navigates to the selected game module based on game name.
    /// - Parameter gameName: Name of the selected game.
    func navigateToGameDetail(gameName: String) {
        print("Navigating to game: \(gameName)")

        switch gameName {
        case Constants.numberMemory:
            let numberMemory = NumberMemoryRouter.createModule()
            viewController?.navigationController?.pushViewController(numberMemory, animated: true)
            
        case Constants.matrixMemory:
            let memoryMatrix = MemoryMatrixRouter.createModule()
            viewController?.navigationController?.pushViewController(memoryMatrix, animated: true)
            
        case Constants.sequenceMemory:
            let sequenceMemory = SequenceMemoryRouter.createModule()
            viewController?.navigationController?.pushViewController(sequenceMemory, animated: true)
            
        default:
            break
        }
    }
}
