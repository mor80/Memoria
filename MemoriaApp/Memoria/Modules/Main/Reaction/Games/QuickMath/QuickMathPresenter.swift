import UIKit

/// Presenter responsible for managing the Quick Math game logic, score updates, and interaction with the interactor.
final class QuickMathPresenter: QuickMathPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: QuickMathViewProtocol?
    var interactor: QuickMathInteractorProtocol?
    var router: QuickMathRouterProtocol?
    
    // MARK: - State
    
    private var gameStatManager = GameStatManager(gameId: 8)
    private var score: Int = 0
    
    // MARK: - Constants
    
    private enum Constants {
        static let correctAnswerPoints = 150
        static let newRoundDelay: TimeInterval = 1.0
        static let gameName = "Quick Math"
        static let category = "Reaction"
    }
    
    // MARK: - Public Methods
    
    /// Starts a new game session.
    func startGame() {
        AchievementManager.shared.notifyBeginning()
        
        // Notify server that a new session has started.
        gameStatManager.newRound { result in
            switch result {
            case .success(let gamesPlayed):
                print("Games played updated on server: \(gamesPlayed)")
            case .failure(let error):
                print("Failed to update games played: \(error.localizedDescription)")
            }
        }
        
        // Reset score for a new game.
        score = 0
        view?.updateScore(score)
        
        // Start game via interactor.
        interactor?.startGame()
    }
    
    /// Processes the user's answer selection.
    /// - Parameter answer: The answer provided by the user.
    func userSelectedAnswer(_ answer: Int) {
        interactor?.validateAnswer(answer)
    }
    
    /// Restarts the game session after game over.
    func restartGame() {
        startGame()
    }
}

// MARK: - QuickMathInteractorOutputProtocol

extension QuickMathPresenter: QuickMathInteractorOutputProtocol {
    
    /// Called when the interactor has generated a new problem.
    /// - Parameters:
    ///   - problem: The generated quick math problem.
    ///   - answers: An array of possible answers.
    func didGenerateProblem(_ problem: QuickMathProblem, answers: [Int]) {
        DailyTaskManager.shared.handleNewRound(gameName: Constants.gameName, category: Constants.category)
        
        view?.setInteractionBlocked(true)
        view?.displayProblem(question: problem.questionText, answers: answers)
        view?.setInteractionBlocked(false)
        
        // Start the answer timer.
        interactor?.startTimer()
    }
    
    /// Called when the user provided a correct answer.
    func didValidateCorrectAnswer() {
        score += Constants.correctAnswerPoints
        
        DailyTaskManager.shared.handleNewPoints(gameName: Constants.gameName, category: Constants.category, points: Int64(score))
        AchievementManager.shared.notifyLightningReflex()
        
        // Update the server with the new score.
        gameStatManager.updateScore(newScore: score) { result in
            switch result {
            case .success(let updatedHighScore):
                print("Server high score updated to: \(updatedHighScore)")
            case .failure(let error):
                print("Failed to update high score: \(error.localizedDescription)")
            }
        }
        
        // Update UI with new score.
        view?.updateScore(score)
        view?.setInteractionBlocked(true)
        
        // Delay before generating a new problem.
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.newRoundDelay) { [weak self] in
            // Note: Original logic called startGame() to restart the whole game.
            // To start a new round without resetting, you could use generateNewRound().
            self?.interactor?.startGame()
        }
    }
    
    /// Called when the user provided an incorrect answer.
    func didFailAnswer() {
        view?.setInteractionBlocked(true)
        view?.showGameOver(with: score)
    }
    
    /// Called when the timer expires.
    func didTimeout() {
        view?.setInteractionBlocked(true)
        view?.showGameOver(with: score)
    }
}
