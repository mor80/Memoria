import UIKit

/// Protocol defining the interactor's responsibilities in the game module.
protocol GameTypeInteractorProtocol: AnyObject {
    /// Fetches the list of games.
    func fetchGames()
}

/// Protocol defining the presenter's responsibilities in the game module.
protocol GameTypePresenterProtocol: AnyObject {
    /// Called when the view is loaded.
    func viewDidLoad()
    
    /// Called when a game is selected from the list.
    /// - Parameter index: The index of the selected game.
    func didSelectGame(at index: Int)
}

/// Protocol for the interactor's output. It handles the result of fetching games.
protocol GameTypeInteractorOutputProtocol: AnyObject {
    /// Called when the games have been fetched.
    /// - Parameters:
    ///   - games: A list of game names.
    ///   - descriptions: A list of descriptions for the games.
    func didFetchGames(_ games: [String], _ descriptions: [String])
}

/// Protocol defining the router's responsibilities in the game module.
protocol GameTypeRouterProtocol: AnyObject {
    /// Navigates to the detail view of the selected game.
    /// - Parameter gameName: The name of the game to navigate to.
    func navigateToGameDetail(gameName: String)
    
    /// Creates and returns the game module view controller.
    /// - Returns: A `UIViewController` for the game module.
    static func createModule() -> UIViewController
}

/// Protocol defining the view's responsibilities in the game module.
protocol GameTypeViewProtocol: AnyObject {
    /// Displays the game buttons with their titles and descriptions.
    /// - Parameters:
    ///   - titles: A list of game titles.
    ///   - descriptions: A list of descriptions for the games.
    func displayGameButtons(titles: [String], descriptions: [String])
}
