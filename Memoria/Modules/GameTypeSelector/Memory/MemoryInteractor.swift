class MemoryGamesInteractor: GameTypeInteractorProtocol {
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    func fetchGames() {
        let games = ["Matrix Memo", "Chimp Test", "Number Memo"]
        presenter?.didFetchGames(games)
    }
}

