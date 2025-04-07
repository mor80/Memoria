import UIKit

class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: StatisticsViewProtocol?
    var interactor: StatisticsInteractorProtocol?
    var router: StatisticsRouterProtocol?
    
    // MARK: - View Lifecycle
    
    /// Called when the view is loaded, it triggers the fetching of statistics from the interactor.
    func viewDidLoad() {
        interactor?.fetchStatistics()
    }
}

extension StatisticsPresenter: StatisticsInteractorOutputProtocol {
    
    // MARK: - StatisticsInteractorOutputProtocol
    
    /// Handles the successful fetching of statistics and prepares the data to be displayed.
    /// - Parameter statItems: A list of statistics items to display.
    func didFetchStatistics(_ statItems: [StatItem]) {
        let displayItems = statItems.map { item -> StatDisplayItem in
            let gamesPlayed = item.stat != nil ? "\(item.stat!.games_played)" : "0"
            let bestScore = item.stat != nil ? "\(item.stat!.high_score)" : "0"
            return StatDisplayItem(gameName: item.game.name,
                                   gamesPlayed: gamesPlayed,
                                   bestScore: bestScore)
        }
        view?.displayStatistics(displayItems)
    }
    
    /// Handles failure to fetch statistics and passes the error to the view for display.
    /// - Parameter error: The error encountered while fetching statistics.
    func didFailToFetchStatistics(with error: Error) {
        view?.displayError(error)
    }
}
