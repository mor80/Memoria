import Foundation

/// Позиция клетки в сетке
public struct SequencePosition: Equatable {
    let row: Int
    let col: Int
}

/// Протокол, через который Presenter обращается к Interactor
protocol SequenceMemoryInteractorProtocol: AnyObject {
    /// Начать новую последовательность заданной начальной длины (очищая старую)
    func startSequence(initialLength: Int, rows: Int, cols: Int)

    /// Добавить одну новую случайную клетку в конец уже имеющейся последовательности
    func addRandomCell(rows: Int, cols: Int)

    /// Текущая последовательность (хранимая в Interactor)
    var currentSequence: [SequencePosition] { get }
}

/// Протокол, через который Interactor сообщает Presenter-у о результатах
protocol SequenceMemoryInteractorOutputProtocol: AnyObject {
    /// Вызывается после генерации начальной последовательности
    func didStartSequence(_ sequence: [SequencePosition])

    /// Вызывается после добавления новой клетки в конец последовательности
    func didAddRandomCell(_ cell: SequencePosition)
}

/// Реализация Interactor'а, которая генерирует и хранит одну «растущую» последовательность
final class SequenceMemoryInteractor: SequenceMemoryInteractorProtocol {

    weak var presenter: SequenceMemoryInteractorOutputProtocol?

    private(set) var currentSequence: [SequencePosition] = []

    // MARK: - Public methods

    func startSequence(initialLength: Int, rows: Int, cols: Int) {
        currentSequence.removeAll()
        for _ in 0..<initialLength {
            currentSequence.append(randomCell(rows: rows, cols: cols))
        }
        presenter?.didStartSequence(currentSequence)
    }

    func addRandomCell(rows: Int, cols: Int) {
        let newCell = randomCell(rows: rows, cols: cols)
        currentSequence.append(newCell)
        presenter?.didAddRandomCell(newCell)
    }

    // MARK: - Private methods

    /// Генерация одной случайной позиции в сетке rows×cols
    private func randomCell(rows: Int, cols: Int) -> SequencePosition {
        let r = Int.random(in: 0..<rows)
        let c = Int.random(in: 0..<cols)
        return SequencePosition(row: r, col: c)
    }
}
