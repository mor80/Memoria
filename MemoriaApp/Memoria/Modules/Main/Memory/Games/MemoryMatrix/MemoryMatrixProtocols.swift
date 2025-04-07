import UIKit

// MARK: - View Protocol

/// Interface for the view layer of the Memory Matrix game.
protocol MemoryMatrixViewProtocol: AnyObject {
    /// Displays the grid with given size.
    /// - Parameter size: A tuple with number of rows and columns.
    func displayGrid(size: (rows: Int, cols: Int))
    
    /// Highlights the correct squares.
    /// - Parameter squares: List of positions to highlight.
    func highlightSquares(_ squares: [Position])
    
    /// Hides all highlighted squares.
    func hideSquares()
    
    /// Shows an animation or feedback for incorrect selection.
    /// - Parameter position: Position of incorrect tap.
    func showIncorrectSelection(at position: Position)
    
    /// Highlights a specific square with a given color.
    /// - Parameters:
    ///   - position: The position to highlight.
    ///   - color: The highlight color.
    func highlightSelection(at position: Position, color: UIColor)
    
    /// Blocks or unblocks user interaction with the grid.
    /// - Parameter blocked: `true` to block, `false` to allow interaction.
    func setInteractionBlocked(_ blocked: Bool)
    
    /// Updates the score display.
    /// - Parameter score: Current score value.
    func updateScore(_ score: Int)
    
    /// Displays a game over screen.
    func showGameOver()
}

// MARK: - Interactor Protocol

/// Interface for the interactor to generate game data.
protocol MemoryMatrixInteractorProtocol: AnyObject {
    /// Generates the list of correct squares for the round.
    /// - Parameter size: Grid size to generate squares for.
    func generateSquares(for size: (rows: Int, cols: Int))
}

// MARK: - Presenter Protocol

/// Interface for presenter to handle game logic and user interaction.
protocol MemoryMatrixPresenterProtocol: AnyObject {
    /// Starts the game and initializes state.
    func startGame()
    
    /// Handles user tap on a specific grid position.
    /// - Parameter position: The tapped position.
    func userTapped(position: Position)
    
    /// The total number of squares that need to be found.
    var expectedSquaresCount: Int { get }
}

// MARK: - Interactor Output Protocol

/// Callback interface for interactor to inform presenter.
protocol MemoryMatrixInteractorOutputProtocol: AnyObject {
    /// Called when a new set of squares has been generated.
    /// - Parameter squares: The positions to find.
    func didGenerateSquares(_ squares: [Position])
}

// MARK: - Router Protocol

/// Interface for routing between Memory Matrix modules or external flows.
protocol MemoryMatrixRouterProtocol: AnyObject {
    /// Creates and returns the complete module (view + VIPER stack).
    static func createModule() -> UIViewController
}
