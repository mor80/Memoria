class MemoryGamesInteractor: GameTypeInteractorProtocol {
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    func fetchGames() {
        let games = ["Matrix Memo", "Sequence Memo", "Number Memo"]
        presenter?.didFetchGames(games)
    }
}

