class FocusGamesInteractor: GameTypeInteractorProtocol {
    weak var presenter: GameTypeInteractorOutputProtocol?
    
    func fetchGames() {
        let games = ["BlaBla", "Chimp Test", "Number Memo"]
        presenter?.didFetchGames(games)
    }
}
