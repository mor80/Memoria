protocol MainInteractorProtocol: AnyObject {
    func fetchGameTypes()
}

class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainInteractorOutputProtocol?
    
    func fetchGameTypes() {
        let gameTypes = ["Memory", "Focus", "Reaction"]
        presenter?.didFetchGameTypes(gameTypes)
    }
}
