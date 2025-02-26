import UIKit

/// Протокол, который использует View, чтобы «общаться» с Presenter (например, при нажатии)
protocol SequenceMemoryPresenterProtocol: AnyObject {
    func startGame()
    func userTapped(_ position: SequencePosition)
}

/// Presenter управляет логикой игры, счётчиками, ошибками
final class SequenceMemoryPresenter: SequenceMemoryPresenterProtocol {

    weak var view: SequenceMemoryViewProtocol?
    var interactor: SequenceMemoryInteractorProtocol?
    var router: SequenceMemoryRouterProtocol?

    private var currentLevel = 1
    private var mistakes = 0
    private let maxMistakes = 3

    // Какой элемент последовательности сейчас ожидаем
    private var currentStepIndex = 0

    // Начальная длина последовательности (можно сделать константой или конфиг)
    private let initialSequenceLength = 2

    func startGame() {
        mistakes = 0
        currentLevel = 1
        currentStepIndex = 0

        view?.updateMistakesLeft(maxMistakes - mistakes)
        view?.updateLevel(currentLevel)

        // Запрашиваем у Interactor стартовую последовательность
        // (допустим, 2 клетки)
        interactor?.startSequence(initialLength: initialSequenceLength,
                                  rows: 3,
                                  cols: 3)
    }

    func userTapped(_ position: SequencePosition) {
        // Смотрим, что сейчас хранит Interactor
        guard let sequence = interactor?.currentSequence else { return }

        let expectedPosition = sequence[currentStepIndex]
        if position == expectedPosition {
            // Верный клик
            view?.highlightSelection(at: position, color: .cyan)
            currentStepIndex += 1

            // Если дошли до конца последовательности
            if currentStepIndex >= sequence.count {
                handleRoundWin()
            }
        } else {
            // Ошибка
            mistakes += 1
            view?.updateMistakesLeft(maxMistakes - mistakes)
            view?.showIncorrectSelection(at: position)

            if mistakes >= maxMistakes {
                view?.showGameOver()
            } else {
                // Начинаем тот же уровень заново (повторяем последовательность)
                restartCurrentRound()
            }
        }
    }

    // MARK: - Private methods

    private func handleRoundWin() {
        // Увеличиваем уровень
        currentLevel += 1
        view?.updateLevel(currentLevel)

        // Просим Interactor добавить новую клетку
        interactor?.addRandomCell(rows: 3, cols: 3)
    }

    /// Отменяем текущие клики, заново показываем ту же последовательность
    private func restartCurrentRound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showSequence()
        }
    }

    /// Показываем View текущую последовательность Interactor-а
    private func showSequence() {
        currentStepIndex = 0
        guard let sequence = interactor?.currentSequence else { return }
        view?.displayGrid(rows: 3, cols: 3)
        view?.showSequence(sequence)
    }
}

// MARK: - Interactor Output
extension SequenceMemoryPresenter: SequenceMemoryInteractorOutputProtocol {
    func didStartSequence(_ sequence: [SequencePosition]) {
        // Только что Interactor сформировал новую последовательность
        currentStepIndex = 0
        // Показываем сетку и анимацию
        view?.displayGrid(rows: 3, cols: 3)
        view?.showSequence(sequence)
    }

    func didAddRandomCell(_ cell: SequencePosition) {
        // К существующей последовательности прибавилась одна клетка
        currentStepIndex = 0
        guard let sequence = interactor?.currentSequence else { return }
        view?.displayGrid(rows: 3, cols: 3)
        view?.showSequence(sequence)
    }
}
