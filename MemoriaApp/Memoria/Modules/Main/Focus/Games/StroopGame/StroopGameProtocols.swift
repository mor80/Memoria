import UIKit

// MARK: - View Protocol

/// Protocol for Stroop Game View. Handles UI updates.
protocol StroopGameViewProtocol: AnyObject {
    /// Displays a word with the given text and color.
    /// - Parameters:
    ///   - text: The word to display.
    ///   - textColor: The color to use for the word.
    func displayWord(text: String, textColor: UIColor)
    
    /// Updates the mistake counter.
    /// - Parameters:
    ///   - mistakes: Current number of mistakes.
    ///   - maxMistakes: Maximum allowed mistakes.
    func updateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Shows the game over screen.
    func showGameOver()
    
    /// Updates the current score.
    /// - Parameter score: The new score.
    func updateScore(_ score: Int)
}

// MARK: - Interactor Protocol

/// Protocol for Stroop Game Interactor. Handles business logic.
protocol StroopGameInteractorProtocol: AnyObject {
    /// Requests generation of the next word-color pair.
    func generateNextWord()
    
    /// Checks the user’s selected color against the correct answer.
    /// - Parameter selectedColor: The color selected by the user.
    func checkAnswer(selectedColor: UIColor)
    
    /// Handles timeout when no answer is given in time.
    func timeOut()
}

// MARK: - Interactor Output Protocol

/// Output protocol for Stroop Game Interactor. Sends results back to the presenter.
protocol StroopGameInteractorOutputProtocol: AnyObject {
    /// Informs that the next word and color have been generated.
    func didGenerateNextWord(text: String, textColor: UIColor)
    
    /// Updates the current mistake count.
    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Signals that the game is over due to too many mistakes.
    func didGameOver(finalMistakes: Int)
    
    /// Called when the user answers correctly.
    func didAnswerCorrect()
}

// MARK: - Presenter Protocol

/// Protocol for Stroop Game Presenter. Handles game flow logic.
protocol StroopGamePresenterProtocol: AnyObject {
    /// Starts a new game.
    func startGame()
    
    /// Called when the user selects a color.
    /// - Parameter color: The selected color.
    func userSelectedColor(_ color: UIColor)
}

// MARK: - Router Protocol

/// Protocol for Stroop Game Router. Handles module creation and navigation.
protocol StroopGameRouterProtocol: AnyObject {
    /// Creates the Stroop Game module.
    /// - Returns: A configured UIViewController.
    static func createModule() -> UIViewController
}
