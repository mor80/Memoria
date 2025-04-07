import Foundation

/// Interactor for the Number Memory game logic.
final class NumberMemoryInteractor: NumberMemoryInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: NumberMemoryInteractorOutputProtocol?

    // MARK: - Constants
    
    private enum Constants {
        static let digitRange = 0...9
    }

    // MARK: - NumberMemoryInteractorProtocol

    /// Generates a random numeric string with a given length.
    /// - Parameter length: Number of digits to generate.
    func generateNumber(for length: Int) {
        let number = (0..<length).map { _ in
            String(Int.random(in: Constants.digitRange))
        }.joined()
        
        presenter?.didGenerateNewNumber(number)
    }

    /// Validates if the user's input matches the expected number.
    /// - Parameters:
    ///   - input: User's input.
    ///   - expected: Correct number.
    func validateInput(_ input: String, expected: String) {
        let isCorrect = input == expected
        presenter?.didValidateNumber(isCorrect: isCorrect)
    }
}
