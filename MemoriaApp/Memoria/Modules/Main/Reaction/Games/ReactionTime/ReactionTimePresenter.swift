import UIKit

/// Presenter responsible for handling the game logic for the Reaction Time game.
final class ReactionTimePresenter: ReactionTimePresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: ReactionTimeViewProtocol?
    var interactor: ReactionTimeInteractorProtocol?
    var router: ReactionTimeRouterProtocol?
    
    // MARK: - State
    
    private var gameStatManager = GameStatManager(gameId: 7)
    private var isRoundActive: Bool = false
    
    // MARK: - Constants
    
    private enum Constants {
        static let startButtonTitle = "START"
        static let initialScoreText = "Score: 0"
        static let tooSoonTitle = "Too soon!\nSTART"
        static let resetDelay: TimeInterval = 1.0
    }
    
    // MARK: - Game Flow
    
    /// Starts the game by notifying achievements, resetting game state, and updating the view.
    func startGame() {
        AchievementManager.shared.notifyBeginning()
        AchievementManager.shared.notifyLightningReflex()
        
        gameStatManager.newRound { result in
            switch result {
            case .success(let gamesPlayed):
                print("Games played updated on server: \(gamesPlayed)")
            case .failure(let error):
                print("Failed to update games played: \(error.localizedDescription)")
            }
        }
        
        isRoundActive = false
        view?.updateReactionButton(backgroundColor: .systemBlue, title: Constants.startButtonTitle)
        view?.updateScore(Constants.initialScoreText)
        view?.setReactionButtonEnabled(true)
        interactor?.resetRound()
    }
    
    /// Processes the reaction button tap event.
    func reactionButtonTapped() {
        if !isRoundActive {
            isRoundActive = true
            interactor?.startRound()
        } else {
            interactor?.userTapped()
        }
    }
}

// MARK: - ReactionTimeInteractorOutputProtocol

extension ReactionTimePresenter: ReactionTimeInteractorOutputProtocol {
    
    /// Called when the waiting phase starts.
    func DidStartWaitingPhase() {
        view?.updateReactionButton(backgroundColor: .red, title: "Wait for green")
    }
    
    /// Called when the reaction phase begins (green light).
    func DidTurnGreen() {
        view?.updateReactionButton(backgroundColor: .systemGreen, title: "Tap!")
    }
    
    /// Called when an early tap is detected during the waiting phase.
    func DidDetectEarlyTap() {
        view?.updateReactionButton(backgroundColor: .systemBlue, title: Constants.tooSoonTitle)
        view?.updateScore(Constants.initialScoreText)
        view?.setReactionButtonEnabled(false)
        isRoundActive = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.resetDelay) { [weak self] in
            self?.startGame()
        }
    }
    
    /// Called when the reaction time has been recorded.
    /// - Parameter reactionTime: The measured reaction time in milliseconds.
    func DidRecordReactionTime(_ reactionTime: Int) {
        DailyTaskManager.shared.handleNewRound(gameName: "Reaction Time", category: "Reaction")
        
        gameStatManager.updateScore(newScore: reactionTime) { result in
            switch result {
            case .success(let updatedHighScore):
                print("Server high score updated to: \(updatedHighScore)")
            case .failure(let error):
                print("Failed to update high score: \(error.localizedDescription)")
            }
        }
        
        view?.updateScore("Score: \(reactionTime) ms")
        view?.resetReactionButton()
        isRoundActive = false
    }
}
