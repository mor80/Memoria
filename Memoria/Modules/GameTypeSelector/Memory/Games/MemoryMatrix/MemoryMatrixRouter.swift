import UIKit

protocol MemoryMatrixRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class MemoryMatrixRouter: MemoryMatrixRouterProtocol {
    static func createModule() -> UIViewController {
        let view = MemoryMatrixViewController()
        let presenter = MemoryMatrixPresenter()
        let interactor = MemoryMatrixInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = MemoryMatrixRouter()
        interactor.presenter = presenter

        return view
    }
}
