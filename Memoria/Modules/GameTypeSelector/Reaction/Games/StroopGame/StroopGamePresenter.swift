import UIKit

protocol StroopGamePresenterProtocol: AnyObject {
    /// Запустить игру (обнуление ошибок и т.д.)
    func startGame()

    /// Пользователь выбрал цвет
    func userSelectedColor(_ color: UIColor)
}

class StroopGamePresenter: StroopGamePresenterProtocol {
    weak var view: StroopGameViewProtocol?
    var interactor: StroopGameInteractorProtocol?
    var router: StroopGameRouterProtocol?

    func startGame() {
        // Обнулим состояние (ошибки) в Interactor
        if let stroopInteractor = interactor as? StroopGameInteractor {
            stroopInteractor.resetGame()
        }
        
        // Обновим отображение нуля ошибок (0/maxMistakes)
        // Хотя правильнее это делать через output-протокол Interactor-а (но для краткости здесь)
        view?.updateMistakes(0, maxMistakes: 3)
        
        // Сгенерируем первое задание
        interactor?.generateNextWord()
    }

    func userSelectedColor(_ color: UIColor) {
        // Проверяем ответ
        interactor?.checkAnswer(selectedColor: color)
        // Если не gameOver, просим следующее слово
        interactor?.generateNextWord()
    }
}

// MARK: - StroopGameInteractorOutputProtocol
extension StroopGamePresenter: StroopGameInteractorOutputProtocol {
    func didGenerateNextWord(text: String, textColor: UIColor) {
        // Показываем во View
        view?.displayWord(text: text, textColor: textColor)
    }

    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int) {
        // Обновляем во View
        view?.updateMistakes(mistakes, maxMistakes: maxMistakes)
    }

    func didGameOver(finalMistakes: Int) {
        // View показывает alert/окно завершения
        view?.showGameOver(mistakes: finalMistakes)
    }
}
