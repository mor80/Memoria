class ReactionGamesInteractor: GameTypeInteractorProtocol {
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    func fetchGames() {
        let games = ["Stroop Game", "Focus Target", "Number Memo"]
        presenter?.didFetchGames(games)
    }
}
