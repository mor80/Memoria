import Foundation

/// Interactor responsible for generating highlighted square positions for the Memory Matrix game.
final class MemoryMatrixInteractor: MemoryMatrixInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: MemoryMatrixInteractorOutputProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let minimumSquareCount: Int = 2
        static let densityDivider: Int = 4
    }
    
    // MARK: - MemoryMatrixInteractorProtocol
    
    /// Generates a set of random unique positions to be highlighted on the grid.
    /// - Parameter size: A tuple with number of rows and columns.
    func generateSquares(for size: (rows: Int, cols: Int)) {
        var positions: Set<Position> = []
        let count = max(Constants.minimumSquareCount, size.rows * size.cols / Constants.densityDivider)
        
        while positions.count < count {
            let row = Int.random(in: 0..<size.rows)
            let col = Int.random(in: 0..<size.cols)
            positions.insert(Position(row: row, col: col))
        }
        
        presenter?.didGenerateSquares(Array(positions))
    }
}
