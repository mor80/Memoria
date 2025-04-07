/// Interactor for fetching the list of Focus games and their descriptions.
final class FocusGamesInteractor: GameTypeInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let games = ["Stroop Game", "Focus Target", "Pair Game"]
        static let descriptions = [
            "Choose the color that matches the word",
            "Press only on the blue circles",
            "Find a sneaky pair among symbols"
        ]
    }
    
    // MARK: - GameTypeInteractorProtocol
    
    /// Fetches a list of focus games and sends them to the presenter.
    func fetchGames() {
        presenter?.didFetchGames(Constants.games, Constants.descriptions)
    }
}
