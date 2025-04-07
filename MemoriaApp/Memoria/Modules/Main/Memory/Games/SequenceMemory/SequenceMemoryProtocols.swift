import UIKit

/// Protocol for communication from Presenter to View in the Sequence Memory game.
protocol SequenceMemoryViewProtocol: AnyObject {
    /// Displays the game grid with the specified number of rows and columns.
    /// - Parameters:
    ///   - rows: Number of rows.
    ///   - cols: Number of columns.
    func displayGrid(rows: Int, cols: Int)
    
    /// Animates the sequence for the user to memorize.
    /// - Parameter sequence: List of positions in the sequence.
    func showSequence(_ sequence: [SequencePosition])
    
    /// Highlights a cell for a correct tap.
    /// - Parameters:
    ///   - position: The cell to highlight.
    ///   - color: The highlight color.
    func highlightSelection(at position: SequencePosition, color: UIColor)
    
    /// Shows an animation for an incorrect tap.
    /// - Parameter position: The incorrect cell tapped.
    func showIncorrectSelection(at position: SequencePosition)
    
    /// Updates the displayed score.
    /// - Parameter score: The new score.
    func updateScore(_ score: Int)
    
    /// Displays the Game Over view.
    func showGameOver()
    
    /// Enables or disables user interaction.
    /// - Parameter blocked: A Boolean value indicating if interaction should be blocked.
    func setInteractionBlocked(_ blocked: Bool)
}

/// Protocol defining the interactor's responsibilities in the Sequence Memory game.
protocol SequenceMemoryInteractorProtocol: AnyObject {
    /// Starts a new sequence with given length and grid size.
    /// - Parameters:
    ///   - initialLength: Initial number of elements in the sequence.
    ///   - rows: Number of rows in the grid.
    ///   - cols: Number of columns in the grid.
    func startSequence(initialLength: Int, rows: Int, cols: Int)
    
    /// Adds a new random cell to the current sequence.
    /// - Parameters:
    ///   - rows: Number of rows in the grid.
    ///   - cols: Number of columns in the grid.
    func addRandomCell(rows: Int, cols: Int)
    
    /// The current full sequence.
    var currentSequence: [SequencePosition] { get }
}

/// Protocol for sending interactor output to the presenter.
protocol SequenceMemoryInteractorOutputProtocol: AnyObject {
    
    /// Called when a new sequence has started.
    /// - Parameter sequence: The initial sequence.
    func didStartSequence(_ sequence: [SequencePosition])
    
    /// Called when a new cell has been added to the sequence.
    /// - Parameter cell: The added cell.
    func didAddRandomCell(_ cell: SequencePosition)
}

/// Protocol defining presenter's public interface for Sequence Memory.
protocol SequenceMemoryPresenterProtocol: AnyObject {
    /// Starts the game session.
    func startGame()
    
    /// Handles user's tap on a specific position.
    /// - Parameter position: The tapped cell.
    func userTapped(_ position: SequencePosition)
}

/// Protocol defining navigation and module creation for Sequence Memory.
protocol SequenceMemoryRouterProtocol: AnyObject {
    /// Creates and returns a fully assembled module.
    /// - Returns: The game view controller.
    static func createModule() -> UIViewController
}
