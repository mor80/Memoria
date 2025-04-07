import Foundation

class StatisticsInteractor: StatisticsInteractorProtocol {
    
    // MARK: - VIPER Reference

    weak var presenter: StatisticsInteractorOutputProtocol?

    private let gameService: GameService
    private let statService: StatService
    
    // MARK: - Constants
    
    private enum Constants {
        static let gamesErrorDomain = "GamesError"
        static let gamesErrorCode = -1
    }
    
    // MARK: - Initialization
    
    init(gameService: GameService = GameService(), statService: StatService = StatService()) {
        self.gameService = gameService
        self.statService = statService
    }
    
    // MARK: - Fetch Statistics
    
    /// Fetches user statistics and games from the services and notifies the presenter.
    func fetchStatistics() {
        // Fetch user data from CoreDataManager
        let user = CoreDataManager.shared.fetchUser().dto
        let userId = user.id
        
        let group = DispatchGroup()
        var fetchedGames: [GameDTO]?
        var fetchedStats: [UserGameStatDTO]?
        var fetchError: Error?
        
        group.enter()
        gameService.listGames { result in
            switch result {
            case .success(let games):
                fetchedGames = games
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.enter()
        statService.listUserStats(for: userId) { result in
            switch result {
            case .success(let stats):
                fetchedStats = stats
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                self.presenter?.didFailToFetchStatistics(with: error)
                return
            }
            guard let games = fetchedGames else {
                self.presenter?.didFailToFetchStatistics(with: NSError(domain: Constants.gamesErrorDomain, code: Constants.gamesErrorCode, userInfo: nil))
                return
            }
            var statItems: [StatItem] = []
            for game in games {
                let matchingStat = fetchedStats?.first(where: { $0.game_id == game.id })
                statItems.append(StatItem(game: game, stat: matchingStat))
            }
            self.presenter?.didFetchStatistics(statItems)
        }
    }
}
