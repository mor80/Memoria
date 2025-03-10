import UIKit

class FocusTargetPresenter: FocusTargetPresenterProtocol {
    weak var view: FocusTargetViewProtocol?
    var interactor: FocusTargetInteractorProtocol?
    var router: FocusTargetRouterProtocol?
    
    // MARK: - FocusTargetPresenterProtocol
    func startGame() {
        interactor?.startGame()
    }
    
    func userTappedShape() {
        interactor?.checkTap()
    }
}

// MARK: - FocusTargetInteractorOutputProtocol
extension FocusTargetPresenter: FocusTargetInteractorOutputProtocol {
    func didGenerateShape(_ shape: FocusTargetShape) {
        // Если color == .clear, или frame = .zero, можно интерпретировать как «удалить фигуру»
        if shape.color == .clear || shape.frame == .zero {
            view?.removeShape()
        } else {
            view?.displayShape(shape)
        }
    }
    
    func didUpdateScore(_ score: Int) {
        view?.updateScore(score)
    }
    
    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int) {
        view?.updateMistakes(mistakes, maxMistakes: maxMistakes)
    }
    
    func didGameOver(finalScore: Int) {
        view?.showGameOver(score: finalScore)
    }
}
