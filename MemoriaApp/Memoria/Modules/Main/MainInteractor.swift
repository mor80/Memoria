import UIKit

/// Interactor for fetching game types data.
class MainInteractor: MainInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    /// Presenter to communicate fetched game types data.
    weak var presenter: MainInteractorOutputProtocol?
    
    // MARK: - Fetching Game Types
    
    /// Fetches the game types, descriptions, and icons.
    func fetchGameTypes() {
        let gameTypes = ["Memory", "Focus", "Reaction"]
        let gameDescriptions = ["Train your brain", "Focus on your tasks", "React quickly"]
        let gameIcons = [
            UIImage(systemName: "brain.filled.head.profile"),
            UIImage(systemName: "eyes"),
            UIImage(systemName: "bolt")
        ]
        
        presenter?.didFetchGameTypes(gameTypes, gameDescriptions, gameIcons)
    }
}
