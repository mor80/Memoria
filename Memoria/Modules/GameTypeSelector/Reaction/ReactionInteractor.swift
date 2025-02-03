class ReactionGamesInteractor: GameTypeInteractorProtocol {
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    func fetchGames() {
        let games = ["BlaBla", "Bubu", "Number Memo"]
        presenter?.didFetchGames(games)
    }
}
