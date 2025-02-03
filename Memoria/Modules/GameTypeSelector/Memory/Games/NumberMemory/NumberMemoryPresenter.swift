protocol NumberMemoryPresenterProtocol: AnyObject {
    func startGame()
    func checkNumber(_ input: String)
}

protocol NumberMemoryInteractorOutputProtocol: AnyObject {
    func didGenerateNewNumber(_ number: String)
    func didValidateNumber(isCorrect: Bool)
}

class NumberMemoryPresenter: NumberMemoryPresenterProtocol {
    weak var view: NumberMemoryViewProtocol?
    var interactor: NumberMemoryInteractorProtocol?
    var router: NumberMemoryRouterProtocol?
    
    private var currentNumber: String = ""
    private var currentLength: Int = 3
    private var mistakes: Int = 0
    
    func startGame() {
        mistakes = 0
        currentLength = 3
        generateNewNumber()
    }
    
    func generateNewNumber() {
        interactor?.generateNumber(for: currentLength) // Асинхронный вызов
    }
    
    func checkNumber(_ input: String) {
        interactor?.validateInput(input, expected: currentNumber) // Асинхронный вызов
    }
}

// **Добавляем реализацию протокола InteractorOutput**
extension NumberMemoryPresenter: NumberMemoryInteractorOutputProtocol {
    func didGenerateNewNumber(_ number: String) {
        currentNumber = number
        view?.showNumber(currentNumber)
    }
    
    func didValidateNumber(isCorrect: Bool) {
        if isCorrect {
            currentLength += 1
        } else {
            mistakes += 1
            currentLength = max(3, currentLength - 1)
            if mistakes >= 3 {
                view?.showGameOver()
                return
            }
        }
        view?.updateAttempts(remaining: mistakes)
        generateNewNumber()
    }
}
