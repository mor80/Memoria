import Foundation
import UIKit

/// Interactor for the Stroop Game. Handles game logic and mistake tracking.
final class StroopGameInteractor: StroopGameInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: StroopGameInteractorOutputProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let maxMistakes: Int = 3
        static let colorComparisonThreshold: CGFloat = 0.001
    }
    
    // MARK: - Properties
    
    private var mistakes: Int = 0
    private var currentRealColor: UIColor = .red
    private var lastWord: String? = nil
    
    private let baseData: [(name: String, color: UIColor)] = [
        ("RED", .red),
        ("BLUE", .blue),
        ("GREEN", .green),
        ("PURPLE", .purple)
    ]
    
    // MARK: - StroopGameInteractorProtocol
    
    /// Generates a new word-color combination and informs the presenter.
    func generateNextWord() {
        guard !baseData.isEmpty else { return }
        
        var newWord: (name: String, color: UIColor)
        repeat {
            newWord = baseData.randomElement()!
        } while newWord.name == lastWord
        
        lastWord = newWord.name
        let textColorItem = baseData.randomElement()!
        currentRealColor = newWord.color
        
        presenter?.didGenerateNextWord(text: newWord.name, textColor: textColorItem.color)
    }
    
    /// Checks the user's selected color against the correct answer.
    /// - Parameter selectedColor: The color selected by the user.
    func checkAnswer(selectedColor: UIColor) {
        if !colorsAreEqual(selectedColor, currentRealColor) {
            mistakes += 1
            presenter?.didUpdateMistakes(mistakes, maxMistakes: Constants.maxMistakes)
            if mistakes >= Constants.maxMistakes {
                presenter?.didGameOver(finalMistakes: mistakes)
                return
            }
        } else {
            presenter?.didAnswerCorrect()
        }
    }
    
    /// Called when the user fails to respond in time.
    func timeOut() {
        mistakes += 1
        presenter?.didUpdateMistakes(mistakes, maxMistakes: Constants.maxMistakes)
        if mistakes >= Constants.maxMistakes {
            presenter?.didGameOver(finalMistakes: mistakes)
        }
    }
    
    /// Resets game state for a new session.
    func resetGame() {
        mistakes = 0
        lastWord = nil
    }
    
    // MARK: - Helpers
    
    /// Compares two UIColors using RGBA values.
    /// - Parameters:
    ///   - color1: First color.
    ///   - color2: Second color.
    /// - Returns: True if colors are effectively equal.
    private func colorsAreEqual(_ color1: UIColor, _ color2: UIColor) -> Bool {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return abs(r1 - r2) < Constants.colorComparisonThreshold &&
               abs(g1 - g2) < Constants.colorComparisonThreshold &&
               abs(b1 - b2) < Constants.colorComparisonThreshold &&
               abs(a1 - a2) < Constants.colorComparisonThreshold
    }
}
