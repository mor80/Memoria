import UIKit

/// Presenter for the Main module, handling user interactions and communication with the interactor and router.
class MainPresenter: MainPresenterProtocol {
    
    // MARK: - VIPER References
    
    /// View for updating the UI.
    weak var view: MainViewProtocol?
    
    /// Interactor for fetching data.
    var interactor: MainInteractorProtocol?
    
    /// Router for navigation.
    var router: MainRouterProtocol?
    
    // MARK: - State
    
    private var gameTypes: [String] = []
    private var gameDescriptions: [String] = []
    private var gameIcons: [UIImage] = []
    
    // MARK: - MainPresenterProtocol Methods
    
    /// Called when the view has loaded.
    func viewDidLoad() {
        interactor?.fetchGameTypes()
    }
    
    /// Called when a button is selected.
    /// - Parameter index: The index of the selected button.
    func didSelectButton(at index: Int) {
        guard index < gameTypes.count else { return }
        router?.navigateToGameType(gameTypes[index])
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
    
    /// Called when the game types have been fetched.
    /// - Parameters:
    ///   - types: List of game types.
    ///   - descriptions: List of descriptions for each game type.
    ///   - icons: List of icons for each game type.
    func didFetchGameTypes(_ types: [String], _ descriptions: [String], _ icons: [UIImage?]) {
        gameTypes = types
        view?.displayButtons(titles: types, descriptions: descriptions, icons: icons)
    }
}
