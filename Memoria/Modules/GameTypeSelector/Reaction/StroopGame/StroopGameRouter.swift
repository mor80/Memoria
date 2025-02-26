import UIKit

protocol StroopGameRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    // Можно добавить методы перехода, например: func showResults(score: Int)
}

class StroopGameRouter: StroopGameRouterProtocol {
    static func createModule() -> UIViewController {
        let view = StroopGameViewController()
        let presenter = StroopGamePresenter()
        let interactor = StroopGameInteractor()
        let router = StroopGameRouter()

        // Связываем
        view.presenter = presenter
        presenter.view = view

        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
