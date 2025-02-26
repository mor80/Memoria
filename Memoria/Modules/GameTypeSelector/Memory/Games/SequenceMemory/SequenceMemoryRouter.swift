import UIKit

protocol SequenceMemoryRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

/// Router отвечает за сборку модуля и переходы (если будут экраны)
final class SequenceMemoryRouter: SequenceMemoryRouterProtocol {
    static func createModule() -> UIViewController {
        let view = SequenceMemoryViewController()
        let presenter = SequenceMemoryPresenter()
        let interactor = SequenceMemoryInteractor()
        let router = SequenceMemoryRouter()

        // Связываем
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        // Важно! Presenter реализует SequenceMemoryInteractorOutputProtocol
        // Поэтому нужно «назначить» его Interactor'у как output
        interactor.presenter = presenter

        return view
    }
}
