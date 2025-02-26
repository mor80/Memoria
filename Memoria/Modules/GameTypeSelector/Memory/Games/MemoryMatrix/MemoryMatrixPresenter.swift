import UIKit

protocol MemoryMatrixPresenterProtocol: AnyObject {
    func startGame()
    func userTapped(position: Position)
    var expectedSquaresCount: Int { get }
}

protocol MemoryMatrixInteractorOutputProtocol: AnyObject {
    func didGenerateSquares(_ squares: [Position])
}

class MemoryMatrixPresenter: MemoryMatrixPresenterProtocol {
    weak var view: MemoryMatrixViewProtocol?
    var interactor: MemoryMatrixInteractorProtocol?
    var router: MemoryMatrixRouterProtocol?

    private var currentGridSize = (rows: 3, cols: 3)
    private var currentLevel = 1
    private var consecutiveWins = 0
    private var mistakes = 0

    private let maxMistakes = 3
    // Набор клеток, которые нужно найти
    private var expectedSquares: Set<Position> = []
    // Клетки, которые уже угаданы правильно
    private var foundSquares: Set<Position> = []

    var expectedSquaresCount: Int {
        return expectedSquares.count
    }

    func startGame() {
        mistakes = 0
        consecutiveWins = 0
        currentLevel = 1
        currentGridSize = (3, 3)
        expectedSquares.removeAll()
        foundSquares.removeAll()

        view?.updateMistakesLeft(maxMistakes - mistakes)
        view?.updateLevel(level: currentLevel)
        generateNewRound()
    }

    private func generateNewRound() {
        foundSquares.removeAll()
        interactor?.generateSquares(for: currentGridSize)
    }

    func userTapped(position: Position) {
        // Проверяем, верная ли клетка
        if expectedSquares.contains(position) {
            // Верная — подсвечиваем выбранный квадрат любым цветом (например, .cyan)
            foundSquares.insert(position)
            view?.highlightSelection(at: position, color: .cyan)

            // Если все нужные квадраты уже найдены — победа в раунде
            if foundSquares.count == expectedSquares.count {
                handleRoundWin()
            }
        } else {
            // Неверная клетка — сразу ошибка
            mistakes += 1
            view?.updateMistakesLeft(maxMistakes - mistakes)
            view?.showIncorrectSelection(at: position)

            if mistakes >= maxMistakes {
                // Конец игры
                view?.showGameOver()
            } else {
                // Переходим к новому раунду с задержкой
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.view?.updateLevel(level: self.currentLevel)
                    self.generateNewRound()
                }
            }
        }
    }

    private func handleRoundWin() {
        consecutiveWins += 1

        // Можно ещё раз подсветить все верные клетки
        view?.highlightSquares(Array(expectedSquares))

        // Каждые 2 победы подряд — увеличиваем матрицу
        if consecutiveWins == 2 {
            increaseGridSize()
            consecutiveWins = 0
        }

        // Задержка, чтобы показать результат
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.view?.updateLevel(level: self.currentLevel)
            self.generateNewRound()
        }
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

extension MemoryMatrixPresenter: MemoryMatrixInteractorOutputProtocol {
    func didGenerateSquares(_ squares: [Position]) {
        expectedSquares = Set(squares)
        // Отображаем новую сетку
        view?.displayGrid(size: currentGridSize)
        // Подсвечиваем с учётом 0.3 * кол-во клеток
        view?.highlightSquares(squares)
    }
}
