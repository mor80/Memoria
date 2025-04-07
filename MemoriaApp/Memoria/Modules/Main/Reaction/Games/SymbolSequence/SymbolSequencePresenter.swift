import UIKit

/// Presenter for the Symbol Sequence game.
final class SymbolSequencePresenter: SymbolSequencePresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: SymbolSequenceViewProtocol?
    var interactor: SymbolSequenceInteractorProtocol?
    var router: SymbolSequenceRouterProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let gameId = 9
        static let pointsPerCorrectInput = 10
        static let bonusPoints = 125
        static let newRoundDelay: TimeInterval = 1.0
    }
    
    // MARK: - State
    
    private var gameStatManager = GameStatManager(gameId: Constants.gameId)
    private var score: Int = 0
    
    // MARK: - SymbolSequencePresenterProtocol Methods
    
    /// Starts a new game.
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
        view?.updateScore(score)
        interactor?.startGame()
    }
    
    /// Processes the user's tapped symbol.
    /// - Parameter symbol: The symbol tapped by the user.
    func userTapped(symbol: SymbolSequenceSymbol) {
        interactor?.validateUserInput(symbol)
    }
    
    /// Restarts the game.
    func restartGame() {
        startGame()
    }
}

// MARK: - SymbolSequenceInteractorOutputProtocol

extension SymbolSequencePresenter: SymbolSequenceInteractorOutputProtocol {
    
    /// Called when a new sequence is generated.
    /// - Parameter sequence: The generated sequence.
    func didGenerateSequence(_ sequence: [SymbolSequenceSymbol]) {
        DailyTaskManager.shared.handleNewRound(gameName: "Symbol Sequence", category: "Reaction")
        view?.setInteractionBlocked(true)
        view?.displaySequence(sequence)
        view?.setInteractionBlocked(false)
        if let interactor = self.interactor as? SymbolSequenceInteractor {
            interactor.startInputTimer()
        }
    }
    
    /// Called when the user's input is correct.
    /// - Parameter index: The current input index.
    func didValidateCorrectInput(at index: Int) {
        score += Constants.pointsPerCorrectInput
        view?.updateScore(score)
    }
    
    /// Called when the sequence is successfully completed.
    func didCompleteSequence() {
        score += Constants.bonusPoints
        DailyTaskManager.shared.handleNewPoints(gameName: "Symbol Sequence", category: "Reaction", points: Int64(score))
        AchievementManager.shared.notifyLightningReflex()
        
        gameStatManager.updateScore(newScore: score) { result in
            switch result {
            case .success(let updatedHighScore):
                print("Server high score updated to: \(updatedHighScore)")
            case .failure(let error):
                print("Failed to update high score: \(error.localizedDescription)")
            }
        }
        
        view?.updateScore(score)
        view?.setInteractionBlocked(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.newRoundDelay) { [weak self] in
            self?.interactor?.generateNewRound()
        }
    }
    
    /// Called when the user's input is incorrect.
    func didFailInput() {
        view?.setInteractionBlocked(true)
        view?.showGameOver(with: score)
    }
    
    /// Called when the input timer expires.
    func didTimeout() {
        view?.setInteractionBlocked(true)
        view?.showGameOver(with: score)
    }
}
