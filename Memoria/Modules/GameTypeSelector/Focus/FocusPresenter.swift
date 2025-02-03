class FocusGamesPresenter: GameTypePresenterProtocol {
    weak var view: GameTypeViewProtocol?
    var interactor: GameTypeInteractorProtocol?
    var router: GameTypeRouterProtocol?
    
    private var games: [String] = []
    
    func viewDidLoad() {
        interactor?.fetchGames()
    }
    
    func didSelectGame(at index: Int) {
        guard index < games.count else { return }
        router?.navigateToGameDetail(gameName: games[index])
    }
}

extension FocusGamesPresenter: GameTypeInteractorOutputProtocol {
    func didFetchGames(_ games: [String]) {
        self.games = games
        view?.displayGameButtons(titles: games)
    }
}
