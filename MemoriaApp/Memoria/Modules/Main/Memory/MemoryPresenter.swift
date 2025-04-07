import Foundation

/// Presenter responsible for handling the logic of the Memory Games screen.
final class MemoryGamesPresenter: GameTypePresenterProtocol {
    
    // MARK: - VIPER References

    weak var view: GameTypeViewProtocol?
    var interactor: GameTypeInteractorProtocol?
    var router: GameTypeRouterProtocol?

    // MARK: - State

    private var games: [String] = []

    // MARK: - Constants

    private enum Constants {
        static let defaultIndex = 0
    }

    // MARK: - GameTypePresenterProtocol

    /// Called when the view has loaded. Requests the list of games from the interactor.
    func viewDidLoad() {
        interactor?.fetchGames()
    }

    /// Handles game selection from the view.
    /// - Parameter index: The index of the selected game.
    func didSelectGame(at index: Int) {
        guard index < games.count else { return }
        router?.navigateToGameDetail(gameName: games[index])
    }
}

// MARK: - GameTypeInteractorOutputProtocol

extension MemoryGamesPresenter: GameTypeInteractorOutputProtocol {
    
    /// Called by the interactor when the list of games is fetched.
    /// - Parameters:
    ///   - games: Array of game titles.
    ///   - descriptions: Array of game descriptions.
    func didFetchGames(_ games: [String], _ descriptions: [String]) {
        self.games = games
        view?.displayGameButtons(titles: games, descriptions: descriptions)
    }
}
