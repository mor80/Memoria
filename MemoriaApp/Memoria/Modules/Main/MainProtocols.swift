import UIKit

/// Protocol defining the interactor's responsibilities in the Main module.
protocol MainInteractorProtocol: AnyObject {
    /// Fetches the game types and their related data.
    func fetchGameTypes()
}

/// Protocol defining the presenter's responsibilities in the Main module.
protocol MainPresenterProtocol: AnyObject {
    /// Called when the view is loaded.
    func viewDidLoad()
    
    /// Called when a game type button is selected.
    /// - Parameter index: The index of the selected game type.
    func didSelectButton(at index: Int)
}

/// Protocol for the interactor's output, which handles the result of fetching game types.
protocol MainInteractorOutputProtocol: AnyObject {
    /// Called when the game types, descriptions, and icons have been fetched.
    /// - Parameters:
    ///   - types: A list of game types.
    ///   - descriptions: A list of descriptions for the game types.
    ///   - icons: A list of icons associated with the game types.
    func didFetchGameTypes(_ types: [String], _ descriptions: [String], _ icons: [UIImage?])
}

/// Protocol defining the router's responsibilities in the Main module.
protocol MainRouterProtocol: AnyObject {
    /// Creates and returns the main view controller of the module.
    /// - Returns: A `UIViewController` instance for the main module.
    static func createModule() -> UIViewController
    
    /// Navigates to the game type screen.
    /// - Parameter type: The name of the selected game type.
    func navigateToGameType(_ type: String)
}

/// Protocol defining the view's responsibilities in the Main module.
protocol MainViewProtocol: AnyObject {
    /// Displays the buttons for each game type.
    /// - Parameters:
    ///   - titles: A list of titles for the buttons.
    ///   - descriptions: A list of descriptions for the buttons.
    ///   - icons: A list of icons for the buttons.
    func displayButtons(titles: [String], descriptions: [String], icons: [UIImage?])
}
