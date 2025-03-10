import UIKit

// MARK: - View
protocol FocusTargetViewProtocol: AnyObject {
    var presenter: FocusTargetPresenterProtocol? { get set }
    
    /// Показать заданную фигуру на экране
    func displayShape(_ shape: FocusTargetShape)
    
    /// Удалить текущую фигуру с экрана (если висит)
    func removeShape()
    
    /// Обновить счёт
    func updateScore(_ score: Int)
    
    /// Обновить количество ошибок
    func updateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Показать, что игра окончена
    func showGameOver(score: Int)
}

// MARK: - Presenter
protocol FocusTargetPresenterProtocol: AnyObject {
    /// Запустить игру
    func startGame()
    
    /// Пользователь нажал на фигуру
    func userTappedShape()
    
    /// Пользователь нажал не на фигуру (если нужно)
    /// (Необязательно, если предполагается, что пользователь нажимает только по фигуре)
}

// MARK: - Interactor
protocol FocusTargetInteractorProtocol: AnyObject {
    /// Начать игру (обнулить счёт, ошибки, запустить таймер/генерацию фигур)
    func startGame()
    
    /// Пользователь нажал на текущую фигуру
    func checkTap()
    
    /// Вызывается, если таймер истёк/фигура скрывается
    func shapeDidHide()
}

protocol FocusTargetInteractorOutputProtocol: AnyObject {
    /// Сообщить Presenter-у о сгенерированной фигуре
    func didGenerateShape(_ shape: FocusTargetShape)
    
    /// Сообщить Presenter-у о новом счёте
    func didUpdateScore(_ score: Int)
    
    /// Сообщить Presenter-у о новых ошибках
    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Игра завершена
    func didGameOver(finalScore: Int)
}

// MARK: - Router
protocol FocusTargetRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    // Тут могут быть методы переходов, например, showResults(score:)
}
