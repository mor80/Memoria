/// Interactor for fetching reaction games data.
final class ReactionGamesInteractor: GameTypeInteractorProtocol {
    
    // MARK: - VIPER References
    
    /// Presenter for communicating fetched game data.
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    // MARK: - Game Data Fetching
    
    /// Fetches the list of reaction games and their descriptions.
    func fetchGames() {
        let games = ["Reaction Time", "Quick Math", "Symbol Sequence"]
        let descriptions = [
            "Show them who is the fastest",
            "Train your math skills",
            "Recreate the sequence"
        ]
        presenter?.didFetchGames(games, descriptions)
    }
}
