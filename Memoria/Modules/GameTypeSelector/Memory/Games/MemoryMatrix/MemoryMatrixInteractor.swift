import Foundation

protocol MemoryMatrixInteractorProtocol: AnyObject {
    func generateSquares(for size: (rows: Int, cols: Int))
}

struct Position: Hashable {
    let row: Int
    let col: Int
}

class MemoryMatrixInteractor: MemoryMatrixInteractorProtocol {
    weak var presenter: MemoryMatrixInteractorOutputProtocol?

    func generateSquares(for size: (rows: Int, cols: Int)) {
        var positions: Set<Position> = []
        let count = max(2, size.rows * size.cols / 4)

        while positions.count < count {
            let row = Int.random(in: 0..<size.rows)
            let col = Int.random(in: 0..<size.cols)
            positions.insert(Position(row: row, col: col))
        }

        presenter?.didGenerateSquares(Array(positions))
    }
}
