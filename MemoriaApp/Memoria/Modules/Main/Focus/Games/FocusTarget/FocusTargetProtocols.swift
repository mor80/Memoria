import UIKit

// MARK: - View

/// Protocol for the Focus Target view layer.
protocol FocusTargetViewProtocol: AnyObject {
    var presenter: FocusTargetPresenterProtocol? { get set }
    
    /// Displays the specified shape on screen.
    /// - Parameter shape: The shape to be displayed.
    func displayShape(_ shape: FocusTargetShape)
    
    /// Removes the currently displayed shape, if any.
    func removeShape()
    
    /// Updates the score label.
    /// - Parameter score: The new score to display.
    func updateScore(_ score: Int)
    
    /// Updates the mistakes indicator.
    /// - Parameters:
    ///   - mistakes: Number of current mistakes.
    ///   - maxMistakes: Maximum allowed mistakes.
    func updateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Displays the game over state.
    /// - Parameter score: Final score of the session.
    func showGameOver(score: Int)
}

// MARK: - Presenter

/// Protocol for the Focus Target presenter layer.
protocol FocusTargetPresenterProtocol: AnyObject {
    /// Starts the game session.
    func startGame()
    
    /// Called when the user taps on a shape.
    func userTappedShape()
}

// MARK: - Interactor

/// Protocol for business logic in Focus Target.
protocol FocusTargetInteractorProtocol: AnyObject {
    /// Starts the game logic: score reset, shape generation, etc.
    func startGame()
    
    /// Called when user taps on a shape.
    func checkTap()
    
    /// Called when the shape disappears without being tapped.
    /// - Parameter missedShape: The shape that was missed.
    func shapeDidHide(missedShape: FocusTargetShape)
}

/// Protocol for sending game updates from Interactor to Presenter.
protocol FocusTargetInteractorOutputProtocol: AnyObject {
    /// Notifies presenter that a shape was generated.
    /// - Parameter shape: The shape to show or remove.
    func didGenerateShape(_ shape: FocusTargetShape)
    
    /// Notifies presenter of score update.
    /// - Parameter score: The updated score.
    func didUpdateScore(_ score: Int)
    
    /// Notifies presenter of mistake updates.
    /// - Parameters:
    ///   - mistakes: Current mistake count.
    ///   - maxMistakes: Maximum allowed.
    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Notifies presenter that the game is over.
    /// - Parameter finalScore: The score at the end of the game.
    func didGameOver(finalScore: Int)
}

// MARK: - Router

/// Protocol for routing and navigation in Focus Target module.
protocol FocusTargetRouterProtocol: AnyObject {
    /// Creates and returns a configured Focus Target module.
    /// - Returns: A `UIViewController` containing the game.
    static func createModule() -> UIViewController
}
