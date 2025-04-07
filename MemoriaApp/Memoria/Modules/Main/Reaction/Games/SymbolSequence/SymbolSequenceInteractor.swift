import UIKit

/// Interactor responsible for managing the symbol sequence game logic.
final class SymbolSequenceInteractor: SymbolSequenceInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    /// Reference to the presenter output.
    weak var presenter: SymbolSequenceInteractorOutputProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let sequenceLength: Int = 4
        static let timeLimit: TimeInterval = 3.0
        static let availableSymbols: [SymbolSequenceSymbol] = [.triangle, .circle, .cross, .square]
    }
    
    // MARK: - State
    
    private(set) var correctSequence: [SymbolSequenceSymbol] = []
    private var userInputIndex: Int = 0
    private var inputTimer: Timer?
    
    // MARK: - SymbolSequenceInteractorProtocol Methods
    
    /// Starts the game by generating a new symbol sequence.
    func startGame() {
        generateSequence()
    }
    
    /// Generates a new round by creating a new symbol sequence.
    func generateNewRound() {
        generateSequence()
    }
    
    /// Generates a random sequence of symbols and notifies the presenter.
    private func generateSequence() {
        correctSequence = (0..<Constants.sequenceLength).map { _ in
            Constants.availableSymbols.randomElement()!
        }
        userInputIndex = 0
        presenter?.didGenerateSequence(correctSequence)
    }
    
    /// Validates the user's input against the correct sequence.
    /// - Parameter symbol: The symbol input by the user.
    func validateUserInput(_ symbol: SymbolSequenceSymbol) {
        guard userInputIndex < correctSequence.count else { return }
        if symbol == correctSequence[userInputIndex] {
            userInputIndex += 1
            presenter?.didValidateCorrectInput(at: userInputIndex)
            if userInputIndex == correctSequence.count {
                cancelInputTimer()
                presenter?.didCompleteSequence()
            }
        } else {
            cancelInputTimer()
            presenter?.didFailInput()
        }
    }
    
    /// Starts the timer that limits the user's input time.
    func startInputTimer() {
        cancelInputTimer()
        inputTimer = Timer.scheduledTimer(timeInterval: Constants.timeLimit,
                                          target: self,
                                          selector: #selector(timerFired),
                                          userInfo: nil,
                                          repeats: false)
    }
    
    /// Cancels the current input timer.
    func cancelInputTimer() {
        inputTimer?.invalidate()
        inputTimer = nil
    }
    
    /// Called when the input timer fires, notifying the presenter about the timeout.
    @objc private func timerFired() {
        presenter?.didTimeout()
    }
}
