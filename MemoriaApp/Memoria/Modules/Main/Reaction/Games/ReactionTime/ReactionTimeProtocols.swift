import UIKit

// MARK: - View

/// Protocol for the Reaction Time game view.
protocol ReactionTimeViewProtocol: AnyObject {
    /// Updates the reaction button's appearance with the specified background color and title.
    /// - Parameters:
    ///   - backgroundColor: The new background color.
    ///   - title: The new title text.
    func updateReactionButton(backgroundColor: UIColor, title: String)
    
    /// Updates the score display (shows reaction time in milliseconds).
    /// - Parameter score: The score text.
    func updateScore(_ score: String)
    
    /// Resets the reaction button to its initial state (blue background, "start" title).
    func resetReactionButton()
    
    /// Enables or disables the reaction button.
    /// - Parameter enabled: `true` to enable the button, `false` to disable it.
    func setReactionButtonEnabled(_ enabled: Bool)
}

// MARK: - Interactor

/// Protocol defining the interactor's responsibilities in the Reaction Time game.
protocol ReactionTimeInteractorProtocol: AnyObject {
    /// Starts a new round by transitioning to the waiting phase.
    func startRound()
    
    /// Processes the user's tap during the round.
    func userTapped()
    
    /// Resets the round's state to its initial conditions.
    func resetRound()
}

/// Protocol for sending interactor output to the presenter.
protocol ReactionTimeInteractorOutputProtocol: AnyObject {
    /// Notifies that the waiting phase has started (button becomes red with "Wait for green" text).
    func DidStartWaitingPhase()
    
    /// Notifies that the reaction phase has begun (button turns green with "Tap!" text).
    func DidTurnGreen()
    
    /// Notifies that the user tapped too early (during the waiting phase).
    func DidDetectEarlyTap()
    
    /// Notifies that the user's reaction time (in milliseconds) has been recorded.
    /// - Parameter reactionTime: The recorded reaction time in milliseconds.
    func DidRecordReactionTime(_ reactionTime: Int)
}

// MARK: - Presenter

/// Protocol defining the presenter's public interface for the Reaction Time game.
protocol ReactionTimePresenterProtocol: AnyObject {
    /// Initializes or resets the game.
    func startGame()
    
    /// Handles the reaction button tap.
    func reactionButtonTapped()
}

// MARK: - Router

/// Protocol defining the router's responsibilities for the Reaction Time module.
protocol ReactionTimeRouterProtocol: AnyObject {
    /// Assembles and returns the Reaction Time module.
    /// - Returns: A configured `UIViewController` instance.
    static func createModule() -> UIViewController
}
