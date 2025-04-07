import UIKit

// MARK: - View Protocol

/// Protocol defining the interface for the Pair Game view.
protocol PairGameViewProtocol: AnyObject {
    var presenter: PairGamePresenterProtocol? { get set }

    /// Displays the card grid.
    /// - Parameters:
    ///   - cards: Array of cards to show.
    ///   - revealAll: Whether to show all cards initially.
    func displayGrid(cards: [CardEntity], revealAll: Bool)

    /// Hides all cards (flips them face down).
    func hideCards()

    /// Reveals a single card.
    /// - Parameters:
    ///   - card: The revealed card.
    ///   - index: Its index in the grid.
    func revealCard(_ card: CardEntity, at index: Int)

    /// Displays the result of the round with highlighted cards.
    /// - Parameters:
    ///   - correct: Whether the round was successful.
    ///   - cards: All cards in the round.
    func showRoundResult(correct: Bool, cards: [CardEntity])

    /// Updates the score display.
    /// - Parameter score: The new score.
    func updateScore(_ score: Int)

    /// Enables or disables user interaction.
    /// - Parameter blocked: Whether interaction is blocked.
    func setInteractionBlocked(_ blocked: Bool)

    /// Shows the game over screen.
    /// - Parameter score: Final score value.
    func showGameOver(score: Int)
}

// MARK: - Presenter Protocol

/// Protocol defining the interface for the Pair Game presenter.
protocol PairGamePresenterProtocol: AnyObject {
    /// Starts the game.
    func startGame()

    /// Handles user tap on a card.
    /// - Parameter index: Index of the tapped card.
    func userTappedCard(at index: Int)
}

// MARK: - Interactor Protocols

/// Protocol defining the interface for the Pair Game interactor input.
protocol PairGameInteractorProtocol: AnyObject {
    /// Starts the game logic.
    func startGame()

    /// Starts a new round.
    func startRound()

    /// Handles card selection by the user.
    /// - Parameter index: Selected card index.
    func userSelectedCard(at index: Int)
}

/// Protocol defining the interface for interactor-to-presenter communication.
protocol PairGameInteractorOutputProtocol: AnyObject {
    /// Called when a new grid of cards is generated.
    /// - Parameter cards: The card entities to display.
    func didGenerateGrid(_ cards: [CardEntity])

    /// Called when cards should be hidden.
    func didHideCards()

    /// Called when a card is revealed.
    /// - Parameters:
    ///   - card: The revealed card.
    ///   - index: Its index in the grid.
    func didRevealCard(_ card: CardEntity, at index: Int)

    /// Called when the round is finished.
    /// - Parameters:
    ///   - correct: Whether the round was successful.
    ///   - cards: All cards used in the round.
    func didFinishRound(correct: Bool, with cards: [CardEntity])

    /// Called when the score is updated.
    /// - Parameter score: The updated score.
    func didUpdateScore(_ score: Int)

    /// Called when the game ends.
    /// - Parameter finalScore: The final score.
    func didGameOver(finalScore: Int)
}

// MARK: - Router Protocol

/// Protocol defining the interface for routing and module assembly.
protocol PairGameRouterProtocol: AnyObject {
    /// Creates the Pair Game module.
    /// - Returns: A fully configured `UIViewController` instance.
    static func createModule() -> UIViewController
}
