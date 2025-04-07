import Foundation

/// Interactor responsible for providing the list of memory games and their descriptions.
final class MemoryGamesInteractor: GameTypeInteractorProtocol {
    
    // MARK: - VIPER Reference

    weak var presenter: GameTypeInteractorOutputProtocol?

    // MARK: - Constants

    private enum Constants {
        static let games = [
            "Matrix Memory",
            "Sequence Memory",
            "Number Memory"
        ]
        static let descriptions = [
            "Remember an increasingly large board",
            "Remember an increasingly long pattern",
            "Remember the longest number"
        ]
    }

    // MARK: - GameTypeInteractorProtocol

    /// Fetches the list of memory games and their descriptions.
    func fetchGames() {
        presenter?.didFetchGames(Constants.games, Constants.descriptions)
    }
}
