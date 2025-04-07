import UIKit

// MARK: - Protocols

/// Protocol for the Quick Math game view.
protocol QuickMathViewProtocol: AnyObject {
    /// Displays the problem and its answer options.
    /// - Parameters:
    ///   - question: The problem's question text.
    ///   - answers: An array of possible answers.
    func displayProblem(question: String, answers: [Int])
    
    /// Updates the displayed score.
    /// - Parameter score: The current score.
    func updateScore(_ score: Int)
    
    /// Shows the Game Over screen with the final score.
    /// - Parameter score: The final score.
    func showGameOver(with score: Int)
    
    /// Enables or disables user interaction.
    /// - Parameter blocked: `true` to block interaction, `false` to allow.
    func setInteractionBlocked(_ blocked: Bool)
}

/// Protocol defining the interactor's responsibilities in the Quick Math game.
protocol QuickMathInteractorProtocol: AnyObject {
    /// Starts a new game.
    func startGame()
    
    /// Generates a new round within the current game.
    func generateNewRound()
    
    /// Validates the provided answer.
    /// - Parameter answer: The answer to validate.
    func validateAnswer(_ answer: Int)
    
    /// Cancels the active timer.
    func cancelTimer()
    
    /// Starts the answer timer.
    func startTimer()
}

/// Protocol for the interactor's output, used to communicate with the presenter.
protocol QuickMathInteractorOutputProtocol: AnyObject {
    /// Called when a new problem has been generated.
    /// - Parameters:
    ///   - problem: The generated math problem.
    ///   - answers: An array of possible answers.
    func didGenerateProblem(_ problem: QuickMathProblem, answers: [Int])
    
    /// Called when the user's answer is correct.
    func didValidateCorrectAnswer()
    
    /// Called when the user's answer is incorrect.
    func didFailAnswer()
    
    /// Called when the timer expires.
    func didTimeout()
}

/// Protocol defining the presenter's public interface for the Quick Math game.
protocol QuickMathPresenterProtocol: AnyObject {
    /// Starts a new game.
    func startGame()
    
    /// Processes the user's selected answer.
    /// - Parameter answer: The selected answer.
    func userSelectedAnswer(_ answer: Int)
    
    /// Restarts the game after a Game Over.
    func restartGame()
}

/// Protocol defining the router's responsibilities for the Quick Math module.
protocol QuickMathRouterProtocol: AnyObject {
    /// Creates and returns the Quick Math module.
    /// - Returns: A configured `UIViewController` instance.
    static func createModule() -> UIViewController
}
