class ReactionGamesInteractor: GameTypeInteractorProtocol {
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    func fetchGames() {
        let games = ["Stroop Game", "Bubu", "Number Memo"]
        presenter?.didFetchGames(games)
    }
}
