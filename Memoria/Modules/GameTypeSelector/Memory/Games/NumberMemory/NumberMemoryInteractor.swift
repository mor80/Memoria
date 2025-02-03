protocol NumberMemoryInteractorProtocol: AnyObject {
    func generateNumber(for length: Int)
    func validateInput(_ input: String, expected: String)
}

class NumberMemoryInteractor: NumberMemoryInteractorProtocol {
    weak var presenter: NumberMemoryInteractorOutputProtocol?

    func generateNumber(for length: Int) {
        let number = String((0..<length).map { _ in String(Int.random(in: 0...9)) }.joined())
        presenter?.didGenerateNewNumber(number)
    }

    func validateInput(_ input: String, expected: String) {
        let isCorrect = input == expected
        presenter?.didValidateNumber(isCorrect: isCorrect)
    }
}
