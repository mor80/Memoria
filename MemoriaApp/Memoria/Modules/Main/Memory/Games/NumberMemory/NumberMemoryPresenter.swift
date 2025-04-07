import UIKit

/// Presenter for the Number Memory game.
final class NumberMemoryPresenter: NumberMemoryPresenterProtocol {
    
    // MARK: - VIPER Reference
    
    weak var view: NumberMemoryViewProtocol?
    var interactor: NumberMemoryInteractorProtocol?
    var router: NumberMemoryRouterProtocol?
    
    // MARK: - Dependencies
    
    private var gameStatManager = GameStatManager(gameId: 3)
    
    // MARK: - Game State
    
    private var currentNumber: String = ""
    private var currentLength: Int = Constants.startingLength
    private var mistakes: Int = 0
    private var score: Int = 0
    
    // MARK: - Constants
    
    private enum Constants {
        static let startingLength = 3
        static let maxMistakes = 3
        static let basePoints = 200
        static let perDigitPoints = 10
        static let gameName = "Number Memory"
        static let categoryName = "Memory"
    }

    // MARK: - NumberMemoryPresenterProtocol
    
    /// Starts a new game session.
    func startGame() {
        AchievementManager.shared.notifyBeginning()
        
        gameStatManager.newRound { result in
            switch result {
            case .success(let gamesPlayed):
                print("Games played updated on server: \(gamesPlayed)")
            case .failure(let error):
                print("Failed to update games played: \(error.localizedDescription)")
            }
        }
        
        mistakes = 0
        currentLength = Constants.startingLength
        score = 0
        view?.updateScore(score)
        generateNewNumber()
    }
    
    /// Requests generation of a new number to memorize.
    func generateNewNumber() {
        DailyTaskManager.shared.handleNewRound(
            gameName: Constants.gameName,
            category: Constants.categoryName
        )
        interactor?.generateNumber(for: currentLength)
    }
    
    /// Checks the user's input against the generated number.
    /// - Parameter input: User's input string.
    func checkNumber(_ input: String) {
        interactor?.validateInput(input, expected: currentNumber)
    }
}

// MARK: - NumberMemoryInteractorOutputProtocol

extension NumberMemoryPresenter: NumberMemoryInteractorOutputProtocol {
    
    func didGenerateNewNumber(_ number: String) {
        currentNumber = number
        view?.showNumber(currentNumber)
    }
    
    func didValidateNumber(isCorrect: Bool) {
        if isCorrect {
            score += Constants.basePoints + Constants.perDigitPoints * currentLength
            currentLength += 1
            
            DailyTaskManager.shared.handleNewPoints(
                gameName: Constants.gameName,
                category: Constants.categoryName,
                points: Int64(score)
            )
            AchievementManager.shared.notifyMemoryMaster()
            
            gameStatManager.updateScore(newScore: score) { result in
                switch result {
                case .success(let updatedHighScore):
                    print("Server high score updated to: \(updatedHighScore)")
                case .failure(let error):
                    print("Failed to update high score: \(error.localizedDescription)")
                }
            }
        } else {
            mistakes += 1
            currentLength = max(Constants.startingLength, currentLength - 1)
            
            if mistakes >= Constants.maxMistakes {
                view?.showGameOver()
                return
            }
        }
        
        view?.updateScore(score)
        generateNewNumber()
    }
}
