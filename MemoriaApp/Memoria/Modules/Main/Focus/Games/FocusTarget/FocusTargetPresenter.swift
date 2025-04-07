import UIKit

/// Presenter for the Focus Target game module.
class FocusTargetPresenter: FocusTargetPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: FocusTargetViewProtocol?
    var interactor: FocusTargetInteractorProtocol?
    var router: FocusTargetRouterProtocol?
    
    // MARK: - Properties
    
    private var gameStatManager = GameStatManager(gameId: 5)
    
    // MARK: - FocusTargetPresenterProtocol
    
    /// Starts a new game session.
    func startGame() {
        AchievementManager.shared.notifyBeginning()
        DailyTaskManager.shared.handleNewRound(gameName: "Focus Target", category: "Focus")
        
        gameStatManager.newRound { result in
            switch result {
            case .success(let gamesPlayed):
                print("Games played updated on server: \(gamesPlayed)")
            case .failure(let error):
                print("Failed to update games played: \(error.localizedDescription)")
            }
        }
        
        interactor?.startGame()
    }
    
    /// Handles user interaction with a shape.
    func userTappedShape() {
        interactor?.checkTap()
    }
}

// MARK: - FocusTargetInteractorOutputProtocol

extension FocusTargetPresenter: FocusTargetInteractorOutputProtocol {
    
    /// Called when a new shape is generated.
    /// - Parameter shape: The generated shape to display or remove.
    func didGenerateShape(_ shape: FocusTargetShape) {
        if shape.color == .clear || shape.frame == .zero {
            view?.removeShape()
        } else {
            view?.displayShape(shape)
        }
    }
    
    /// Called when the score is updated.
    /// - Parameter score: The new score value.
    func didUpdateScore(_ score: Int) {
        DailyTaskManager.shared.handleNewPoints(gameName: "Focus Target", category: "Focus", points: Int64(score))
        
        gameStatManager.updateScore(newScore: score) { result in
            switch result {
            case .success(let updatedHighScore):
                print("Server high score updated to: \(updatedHighScore)")
            case .failure(let error):
                print("Failed to update high score: \(error.localizedDescription)")
            }
        }
        
        view?.updateScore(score)
    }
    
    /// Called when mistakes are updated.
    /// - Parameters:
    ///   - mistakes: Current mistake count.
    ///   - maxMistakes: Maximum allowed mistakes.
    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int) {
        view?.updateMistakes(mistakes, maxMistakes: maxMistakes)
    }
    
    /// Called when the game is over.
    /// - Parameter finalScore: The final score of the game.
    func didGameOver(finalScore: Int) {
        AchievementManager.shared.notifyFocusChampion()
        view?.showGameOver(score: finalScore)
    }
}
