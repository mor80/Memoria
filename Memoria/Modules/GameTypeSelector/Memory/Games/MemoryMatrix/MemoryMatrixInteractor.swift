protocol MemoryMatrixInteractorProtocol: AnyObject {
    func generateSquares(for size: (rows: Int, cols: Int))
    func validateSelection(_ selection: [Position], expected: [Position])
}

struct Position: Hashable {
    let row: Int
    let col: Int
}

class MemoryMatrixInteractor: MemoryMatrixInteractorProtocol {
    weak var presenter: MemoryMatrixInteractorOutputProtocol?

    func generateSquares(for size: (rows: Int, cols: Int)) {
        var positions: Set<Position> = []
        let count = max(2, size.rows * size.cols / 6)

        while positions.count < count {
            let row = Int.random(in: 0..<size.rows)
            let col = Int.random(in: 0..<size.cols)
            positions.insert(Position(row: row, col: col))
        }

        presenter?.didGenerateSquares(Array(positions))
    }

    func validateSelection(_ selection: [Position], expected: [Position]) {
        let incorrectSquare = selection.first { !expected.contains($0) }
        
        let isCorrect = incorrectSquare == nil
        presenter?.didValidateSelection(isCorrect: isCorrect, incorrectSquare: incorrectSquare)
    }
}
