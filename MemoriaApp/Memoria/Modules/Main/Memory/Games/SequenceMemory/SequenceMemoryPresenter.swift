import UIKit

/// Presenter responsible for managing the game logic and score tracking in the Sequence Memory game.
final class SequenceMemoryPresenter: SequenceMemoryPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: SequenceMemoryViewProtocol?
    var interactor: SequenceMemoryInteractorProtocol?
    var router: SequenceMemoryRouterProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let gameId = 2
        static let gridSize = (rows: 3, cols: 3)
        static let maxMistakes = 3
        static let initialSequenceLength = 2
        static let correctTapPoints = 100
        static let sequenceBonusPoints = 50
        static let winDelay: TimeInterval = 1.0
        static let mistakeDelay: TimeInterval = 0.5
        static let restartDelay: TimeInterval = 1.5
    }
    
    // MARK: - State
    
    private var gameStatManager = GameStatManager(gameId: Constants.gameId)
    private var currentLevel = 1
    private var mistakes = 0
    private var currentStepIndex = 0
    private var score = 0
    
    // MARK: - Game Flow
    
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
        currentLevel = 1
        currentStepIndex = 0
        score = 0
        view?.updateScore(score)
        
        interactor?.startSequence(
            initialLength: Constants.initialSequenceLength,
            rows: Constants.gridSize.rows,
            cols: Constants.gridSize.cols
        )
    }
    
    /// Handles user tap on a specific cell.
    /// - Parameter position: The tapped position.
    func userTapped(_ position: SequencePosition) {
        guard let sequence = interactor?.currentSequence else { return }
        let expectedPosition = sequence[currentStepIndex]
        
        if position == expectedPosition {
            score += Constants.correctTapPoints
            view?.updateScore(score)
            view?.highlightSelection(at: position, color: .systemGreen)
            currentStepIndex += 1
            
            if currentStepIndex >= sequence.count {
                view?.setInteractionBlocked(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.winDelay) {
                    self.handleRoundWin()
                }
            }
        } else {
            mistakes += 1
            view?.setInteractionBlocked(true)
            view?.showIncorrectSelection(at: position)
            
            if mistakes >= Constants.maxMistakes {
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.mistakeDelay) {
                    self.view?.showGameOver()
                }
            } else {
                restartCurrentRound()
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Handles a completed round and updates score/level.
    private func handleRoundWin() {
        currentLevel += 1
        let bonus = (interactor?.currentSequence.count ?? 0) * Constants.sequenceBonusPoints
        score += bonus
        
        DailyTaskManager.shared.handleNewPoints(
            gameName: "Sequence Memory",
            category: "Memory",
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
        
        view?.updateScore(score)
        interactor?.addRandomCell(rows: Constants.gridSize.rows, cols: Constants.gridSize.cols)
    }
    
    /// Restarts the current round after a short delay.
    private func restartCurrentRound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.restartDelay) {
            self.showSequence()
        }
    }
    
    /// Displays the current sequence on the view.
    private func showSequence() {
        currentStepIndex = 0
        guard let sequence = interactor?.currentSequence else { return }
        view?.displayGrid(rows: Constants.gridSize.rows, cols: Constants.gridSize.cols)
        view?.showSequence(sequence)
    }
}

// MARK: - SequenceMemoryInteractorOutputProtocol

extension SequenceMemoryPresenter: SequenceMemoryInteractorOutputProtocol {
    
    /// Called when the sequence is initialized.
    func didStartSequence(_ sequence: [SequencePosition]) {
        DailyTaskManager.shared.handleNewRound(gameName: "Sequence Memory", category: "Memory")
        currentStepIndex = 0
        view?.displayGrid(rows: Constants.gridSize.rows, cols: Constants.gridSize.cols)
        view?.showSequence(sequence)
    }
    
    /// Called when a new random cell is added to the sequence.
    func didAddRandomCell(_ cell: SequencePosition) {
        DailyTaskManager.shared.handleNewRound(gameName: "Sequence Memory", category: "Memory")
        currentStepIndex = 0
        guard let sequence = interactor?.currentSequence else { return }
        view?.displayGrid(rows: Constants.gridSize.rows, cols: Constants.gridSize.cols)
        view?.showSequence(sequence)
    }
}
