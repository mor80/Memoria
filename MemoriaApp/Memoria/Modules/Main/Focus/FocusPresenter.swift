/// Presenter for the Focus games module.
final class FocusGamesPresenter: GameTypePresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: GameTypeViewProtocol?
    var interactor: GameTypeInteractorProtocol?
    var router: GameTypeRouterProtocol?
    
    // MARK: - State
    
    private var games: [String] = []
    
    // MARK: - GameTypePresenterProtocol
    
    /// Called when the view is loaded. Requests game data from the interactor.
    func viewDidLoad() {
        interactor?.fetchGames()
    }
    
    /// Handles game selection and navigates to the corresponding screen.
    /// - Parameter index: Index of the selected game.
    func didSelectGame(at index: Int) {
        guard index < games.count else { return }
        router?.navigateToGameDetail(gameName: games[index])
    }
}

// MARK: - GameTypeInteractorOutputProtocol

extension FocusGamesPresenter: GameTypeInteractorOutputProtocol {
    
    /// Called when games and their descriptions have been fetched.
    func didFetchGames(_ games: [String], _ descriptions: [String]) {
        self.games = games
        view?.displayGameButtons(titles: games, descriptions: descriptions)
    }
}
