import UIKit

// MARK: - View

protocol NumberMemoryViewProtocol: AnyObject {
    /// Displays the generated number for the player to memorize.
    func showNumber(_ number: String)

    /// Hides the number before the player enters their guess.
    func hideNumber()

    /// Updates the score label with the current score.
    func updateScore(_ score: Int)

    /// Displays the game over screen when the game ends.
    func showGameOver()
}

// MARK: - Interactor

protocol NumberMemoryInteractorProtocol: AnyObject {
    /// Generates a new number with the specified digit length.
    /// - Parameter length: The length of the number to generate.
    func generateNumber(for length: Int)

    /// Validates the user input against the expected number.
    /// - Parameters:
    ///   - input: The number entered by the player.
    ///   - expected: The correct number to compare against.
    func validateInput(_ input: String, expected: String)
}

protocol NumberMemoryInteractorOutputProtocol: AnyObject {
    /// Called when a new number is successfully generated.
    /// - Parameter number: The generated number string.
    func didGenerateNewNumber(_ number: String)

    /// Called after the input is validated.
    /// - Parameter isCorrect: Whether the player's input was correct.
    func didValidateNumber(isCorrect: Bool)
}

// MARK: - Presenter

protocol NumberMemoryPresenterProtocol: AnyObject {
    /// Starts a new game session.
    func startGame()

    /// Checks the number entered by the player.
    /// - Parameter input: The string input from the player.
    func checkNumber(_ input: String)
}

// MARK: - Router

protocol NumberMemoryRouterProtocol: AnyObject {
    /// Creates and returns the fully wired NumberMemory module.
    static func createModule() -> UIViewController
}
