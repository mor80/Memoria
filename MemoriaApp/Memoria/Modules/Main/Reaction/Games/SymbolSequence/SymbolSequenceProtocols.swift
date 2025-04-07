import UIKit

// MARK: - Protocols

/// Protocol defining the view interface for the Symbol Sequence game.
protocol SymbolSequenceViewProtocol: AnyObject {
    /// Displays the sequence of symbols with animation.
    /// - Parameter sequence: The sequence to display.
    func displaySequence(_ sequence: [SymbolSequenceSymbol])
    
    /// Updates the score display.
    /// - Parameter score: The current score.
    func updateScore(_ score: Int)
    
    /// Shows the Game Over screen with the final score.
    /// - Parameter score: The final score.
    func showGameOver(with score: Int)
    
    /// Enables or disables user interaction.
    /// - Parameter blocked: Pass `true` to block input; otherwise, `false`.
    func setInteractionBlocked(_ blocked: Bool)
}

/// Protocol defining the interactor interface for the Symbol Sequence game.
protocol SymbolSequenceInteractorProtocol: AnyObject {
    /// Starts the game by resetting state and generating a new sequence.
    func startGame()
    
    /// Generates a new round by creating a new sequence.
    func generateNewRound()
    
    /// Validates the user input symbol.
    /// - Parameter symbol: The symbol input by the user.
    func validateUserInput(_ symbol: SymbolSequenceSymbol)
    
    /// Cancels the input timer if it is running.
    func cancelInputTimer()
}

/// Protocol defining the interactor output interface for communicating with the presenter.
protocol SymbolSequenceInteractorOutputProtocol: AnyObject {
    /// Called when a new sequence is generated.
    /// - Parameter sequence: The generated sequence.
    func didGenerateSequence(_ sequence: [SymbolSequenceSymbol])
    
    /// Called when the user correctly inputs a symbol.
    /// - Parameter index: The index of the correctly input symbol.
    func didValidateCorrectInput(at index: Int)
    
    /// Called when the sequence is completely and correctly entered.
    func didCompleteSequence()
    
    /// Called when the user inputs an incorrect symbol.
    func didFailInput()
    
    /// Called when the input timer expires.
    func didTimeout()
}

/// Protocol defining the presenter interface for the Symbol Sequence game.
protocol SymbolSequencePresenterProtocol: AnyObject {
    /// Starts the game.
    func startGame()
    
    /// Handles the event when a user taps a symbol.
    /// - Parameter symbol: The tapped symbol.
    func userTapped(symbol: SymbolSequenceSymbol)
    
    /// Restarts the game after a Game Over.
    func restartGame()
}

/// Protocol defining the router interface for assembling the Symbol Sequence module.
protocol SymbolSequenceRouterProtocol: AnyObject {
    /// Creates and returns the main view controller of the module.
    /// - Returns: The module's view controller.
    static func createModule() -> UIViewController
}
