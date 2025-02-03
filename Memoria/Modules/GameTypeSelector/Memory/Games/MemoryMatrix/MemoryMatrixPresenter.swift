protocol MemoryMatrixPresenterProtocol: AnyObject {
    func startGame()
    func checkSelection(_ selection: [Position])
}

protocol MemoryMatrixInteractorOutputProtocol: AnyObject {
    func didGenerateSquares(_ squares: [Position])
    func didValidateSelection(isCorrect: Bool, incorrectSquare: Position?)
}

class MemoryMatrixPresenter: MemoryMatrixPresenterProtocol {
    weak var view: MemoryMatrixViewProtocol?
    var interactor: MemoryMatrixInteractorProtocol?
    var router: MemoryMatrixRouterProtocol?

    private var currentGridSize = (rows: 3, cols: 3)
    private var currentLevel = 1
    private var consecutiveWins = 0
    private var mistakes = 0
    private var expectedSquares: [Position] = []

    func startGame() {
        mistakes = 0
        currentGridSize = (3, 3)
        currentLevel = 1
        generateNewRound()
    }

    private func generateNewRound() {
        interactor?.generateSquares(for: currentGridSize)
    }

    func checkSelection(_ selection: [Position]) {
        interactor?.validateSelection(selection, expected: expectedSquares)
    }
}

extension MemoryMatrixPresenter: MemoryMatrixInteractorOutputProtocol {
    func didGenerateSquares(_ squares: [Position]) {
        expectedSquares = squares
        view?.displayGrid(size: currentGridSize)
        view?.highlightSquares(squares)
    }

    func didValidateSelection(isCorrect: Bool, incorrectSquare: Position?) {
        if isCorrect {
            consecutiveWins += 1
            if consecutiveWins == 2 {
                increaseGridSize()
                consecutiveWins = 0
            }
            view?.highlightSquares(expectedSquares) // ✅ Показываем правильные
        } else {
            mistakes += 1
            if mistakes >= 3 {
                view?.showGameOver()
                return
            }
            if let incorrectPosition = incorrectSquare {
                view?.showIncorrectSelection(at: incorrectPosition) // ✅ Показываем ошибку
            }
        }
        view?.updateLevel(level: currentLevel)
        generateNewRound()
    }

    private func increaseGridSize() {
        if currentGridSize.cols == currentGridSize.rows {
            currentGridSize.rows += 1
        } else {
            currentGridSize.cols += 1
        }
        currentLevel += 1
    }
}
