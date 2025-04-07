import Foundation

/// Interactor responsible for managing and generating a growing sequence of positions.
final class SequenceMemoryInteractor: SequenceMemoryInteractorProtocol {

    // MARK: - VIPER Reference

    weak var presenter: SequenceMemoryInteractorOutputProtocol?

    // MARK: - State

    private(set) var currentSequence: [SequencePosition] = []

    // MARK: - Constants

    private enum Constants {
        static let defaultInitialLength: Int = 0
    }

    // MARK: - Public Methods

    /// Starts a new sequence with a given initial length and grid size.
    /// - Parameters:
    ///   - initialLength: Number of items to generate initially.
    ///   - rows: Number of rows in the grid.
    ///   - cols: Number of columns in the grid.
    func startSequence(initialLength: Int, rows: Int, cols: Int) {
        currentSequence.removeAll()
        for _ in 0..<initialLength {
            currentSequence.append(randomCell(rows: rows, cols: cols))
        }
        presenter?.didStartSequence(currentSequence)
    }

    /// Appends a new random cell to the current sequence.
    /// - Parameters:
    ///   - rows: Number of rows in the grid.
    ///   - cols: Number of columns in the grid.
    func addRandomCell(rows: Int, cols: Int) {
        let newCell = randomCell(rows: rows, cols: cols)
        currentSequence.append(newCell)
        presenter?.didAddRandomCell(newCell)
    }

    // MARK: - Private Methods

    /// Generates a random cell within the grid bounds.
    /// - Parameters:
    ///   - rows: Number of rows in the grid.
    ///   - cols: Number of columns in the grid.
    /// - Returns: A randomly selected `SequencePosition`.
    private func randomCell(rows: Int, cols: Int) -> SequencePosition {
        let r = Int.random(in: Constants.defaultInitialLength..<rows)
        let c = Int.random(in: Constants.defaultInitialLength..<cols)
        return SequencePosition(row: r, col: c)
    }
}
