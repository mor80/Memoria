/// Presenter for managing reaction games flow.
final class ReactionGamesPresenter: GameTypePresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: GameTypeViewProtocol?
    var interactor: GameTypeInteractorProtocol?
    var router: GameTypeRouterProtocol?
    
    // MARK: - State
    
    private var games: [String] = []
    
    // MARK: - GameTypePresenterProtocol Methods
    
    /// Called when the view has loaded.
    func viewDidLoad() {
        interactor?.fetchGames()
    }
    
    /// Handles the selection of a game.
    /// - Parameter index: The index of the selected game.
    func didSelectGame(at index: Int) {
        guard index < games.count else { return }
        router?.navigateToGameDetail(gameName: games[index])
    }
}

// MARK: - GameTypeInteractorOutputProtocol

extension ReactionGamesPresenter: GameTypeInteractorOutputProtocol {
    
    /// Receives fetched games and their descriptions from the interactor.
    /// - Parameters:
    ///   - games: An array of game names.
    ///   - descriptions: An array of game descriptions.
    func didFetchGames(_ games: [String], _ descriptions: [String]) {
        self.games = games
        view?.displayGameButtons(titles: games, descriptions: descriptions)
    }
}
