import Foundation
import UIKit

protocol StroopGameInteractorProtocol: AnyObject {
    /// Запросить генерацию следующего слова и цвета
    func generateNextWord()
    
    /// Проверить ответ пользователя
    func checkAnswer(selectedColor: UIColor)
}

protocol StroopGameInteractorOutputProtocol: AnyObject {
    /// Сообщает Presenter об очередной сгенерированной паре (текст, цвет)
    func didGenerateNextWord(text: String, textColor: UIColor)
    
    /// Сообщает Presenter о текущем количестве ошибок (для отображения во View)
    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Игра должна завершиться
    func didGameOver(finalMistakes: Int)
}

class StroopGameInteractor: StroopGameInteractorProtocol {
    weak var presenter: StroopGameInteractorOutputProtocol?
    
    // Количество ошибок и максимальное их число
    private var mistakes: Int = 0
    private let maxMistakes = 3

    // Текущий реальный цвет (для проверки)
    private var currentRealColor: UIColor = .black
    
    // Набор вариантов (цвет и его название) — 6 шт.
    private let baseData: [(name: String, color: UIColor)] = [
        ("КРАСНЫЙ", .red),
        ("СИНИЙ",   .blue),
        ("ЗЕЛЁНЫЙ", .green),
        ("ЖЁЛТЫЙ",  .yellow),
        ("ЧЁРНЫЙ",  .black),
        ("БЕЛЫЙ",   .white)
    ]
    
    func generateNextWord() {
        guard !baseData.isEmpty else { return }
        
        // Случайно выбираем "реальное" слово
        let real = baseData.randomElement()!
        // Случайно выбираем цвет текста (он может совпадать с реальным цветом, так тоже бывает)
        let textColorItem = baseData.randomElement()!
        
        currentRealColor = real.color
        
        // Сообщаем Presenter об очередной паре
        presenter?.didGenerateNextWord(text: real.name, textColor: textColorItem.color)
    }
    
    func checkAnswer(selectedColor: UIColor) {
        // Сравниваем выбранный цвет с реальным
        if !colorsAreEqual(selectedColor, currentRealColor) {
            // Неправильный ответ — увеличиваем счётчик ошибок
            mistakes += 1
            
            // Обновляем Presenter
            presenter?.didUpdateMistakes(mistakes, maxMistakes: maxMistakes)
            
            // Если ошибок >= maxMistakes, завершаем игру
            if mistakes >= maxMistakes {
                presenter?.didGameOver(finalMistakes: mistakes)
                return
            }
        }
        // Если ответ верный — ничего не делаем, игра продолжается
    }
    
    /// Утилитная функция сравнения цветов (с учётом RGBA)
    private func colorsAreEqual(_ color1: UIColor, _ color2: UIColor) -> Bool {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return abs(r1 - r2) < 0.001 &&
               abs(g1 - g2) < 0.001 &&
               abs(b1 - b2) < 0.001 &&
               abs(a1 - a2) < 0.001
    }
    
    // Можно добавить метод обнуления ошибок, если нужно при новом старте игры
    func resetGame() {
        mistakes = 0
    }
}
