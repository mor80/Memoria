protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectButton(at index: Int)
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchGameTypes(_ types: [String])
}

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?
    
    private var gameTypes: [String] = []
    
    func viewDidLoad() {
        interactor?.fetchGameTypes()
    }
    
    func didSelectButton(at index: Int) {
        guard index < gameTypes.count else { return }
        router?.navigateToGameType(gameTypes[index])
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
    func didFetchGameTypes(_ types: [String]) {
        gameTypes = types
        view?.displayButtons(titles: types)
    }
}
