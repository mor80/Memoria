import UIKit

/// Presenter for the Memory Matrix game.
final class MemoryMatrixPresenter: MemoryMatrixPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: MemoryMatrixViewProtocol?
    var interactor: MemoryMatrixInteractorProtocol?
    var router: MemoryMatrixRouterProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let initialGridSize = (rows: 3, cols: 3)
        static let pointsPerCorrectTap = 100
        static let pointsPerBonusSquare = 50
        static let maxMistakes = 3
        static let roundsToGrowGrid = 3
        static let delayAfterAction: TimeInterval = 0.5
    }
    
    // MARK: - State
    
    private var gameStatManager = GameStatManager(gameId: 1)
    
    private var currentGridSize = Constants.initialGridSize
    private var score = 0
    private var consecutiveWins = 0
    private var mistakes = 0
    
    private var expectedSquares: Set<Position> = []
    private var foundSquares: Set<Position> = []
    
    var expectedSquaresCount: Int {
        return expectedSquares.count
    }
    
    // MARK: - Game Flow
    
    /// Starts the game and resets all counters.
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
        
        score = 0
        mistakes = 0
        consecutiveWins = 0
        currentGridSize = Constants.initialGridSize
        expectedSquares.removeAll()
        foundSquares.removeAll()
        
        view?.updateScore(score)
        generateNewRound()
    }
    
    /// Requests a new set of squares and grid.
    private func generateNewRound() {
        foundSquares.removeAll()
        DailyTaskManager.shared.handleNewRound(gameName: "Matrix Memory", category: "Memory")
        interactor?.generateSquares(for: currentGridSize)
    }
    
    /// Handles user tap on a square.
    /// - Parameter position: The tapped position.
    func userTapped(position: Position) {
        if expectedSquares.contains(position) {
            if !foundSquares.contains(position) {
                score += Constants.pointsPerCorrectTap
                view?.updateScore(score)
            }
            foundSquares.insert(position)
            view?.highlightSelection(at: position, color: .systemGreen)
            
            if foundSquares.count == expectedSquares.count {
                view?.setInteractionBlocked(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayAfterAction) {
                    self.handleRoundWin()
                }
            }
        } else {
            mistakes += 1
            view?.setInteractionBlocked(true)
            view?.showIncorrectSelection(at: position)
            
            if mistakes >= Constants.maxMistakes {
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayAfterAction) {
                    self.view?.showGameOver()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayAfterAction) {
                    self.generateNewRound()
                }
            }
        }
    }
    
    /// Called when all correct squares are selected.
    private func handleRoundWin() {
        let bonus = expectedSquares.count * Constants.pointsPerBonusSquare
        score += bonus
        view?.updateScore(score)
        
        DailyTaskManager.shared.handleNewPoints(gameName: "Matrix Memory", category: "Memory", points: Int64(score))
        AchievementManager.shared.notifyMemoryMaster()
        
        gameStatManager.updateScore(newScore: score) { result in
            switch result {
            case .success(let updatedHighScore):
                print("Server high score updated to: \(updatedHighScore)")
            case .failure(let error):
                print("Failed to update high score: \(error.localizedDescription)")
            }
        }
        
        consecutiveWins += 1
        if consecutiveWins == Constants.roundsToGrowGrid {
            increaseGridSize()
            consecutiveWins = 0
        }
        
        view?.highlightSquares(Array(expectedSquares))
        generateNewRound()
    }
    
    /// Increases the size of the grid after successful rounds.
    private func increaseGridSize() {
        if currentGridSize.cols == currentGridSize.rows {
            currentGridSize.rows += 1
        } else {
            currentGridSize.cols += 1
        }
    }
}

// MARK: - MemoryMatrixInteractorOutputProtocol

extension MemoryMatrixPresenter: MemoryMatrixInteractorOutputProtocol {
    
    /// Receives generated square positions from interactor.
    func didGenerateSquares(_ squares: [Position]) {
        expectedSquares = Set(squares)
        view?.displayGrid(size: currentGridSize)
        view?.highlightSquares(squares)
    }
}
