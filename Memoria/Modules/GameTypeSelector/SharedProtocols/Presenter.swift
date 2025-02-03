protocol GameTypePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectGame(at index: Int)
}

protocol GameTypeInteractorOutputProtocol: AnyObject {
    func didFetchGames(_ games: [String])
}

