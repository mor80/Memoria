import UIKit

/// Presenter for the Pair Game module.
final class PairGamePresenter: PairGamePresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: PairGameViewProtocol?
    var interactor: PairGameInteractorProtocol?
    var router: PairGameRouterProtocol?
    
    // MARK: - Properties
    
    private var gameStatManager = GameStatManager(gameId: 6)
    
    // MARK: - PairGamePresenterProtocol
    
    /// Starts a new game session.
    func startGame() {
        AchievementManager.shared.notifyBeginning()
        
        gameStatManager.newRound { result in
            switch result {
            case .success(let gamesPlayed):
                print("Games played updated on server: \(gamesPlayed)")
            case .failure(let error):
                print("Failed to update games played: \(error.localizedDescription)")
            }
        }
        
        interactor?.startGame()
    }
    
    /// Called when the user taps a card.
    /// - Parameter index: Index of the tapped card.
    func userTappedCard(at index: Int) {
        interactor?.userSelectedCard(at: index)
    }
}

// MARK: - PairGameInteractorOutputProtocol

extension PairGamePresenter: PairGameInteractorOutputProtocol {
    
    /// Called when the game grid is generated.
    /// - Parameter cards: Array of generated `CardEntity` items.
    func didGenerateGrid(_ cards: [CardEntity]) {
        view?.displayGrid(cards: cards, revealAll: true)
    }
    
    /// Called when it's time to hide all cards.
    func didHideCards() {
        view?.hideCards()
        view?.setInteractionBlocked(false)
    }
    
    /// Called when a card is revealed.
    /// - Parameters:
    ///   - card: The revealed card.
    ///   - index: The index of the card.
    func didRevealCard(_ card: CardEntity, at index: Int) {
        view?.revealCard(card, at: index)
    }
    
    /// Called when the round ends and results are ready to be displayed.
    /// - Parameters:
    ///   - correct: Whether the match was correct.
    ///   - cards: All cards used in the round.
    func didFinishRound(correct: Bool, with cards: [CardEntity]) {
        DailyTaskManager.shared.handleNewRound(gameName: "Pair Game", category: "Focus")
        
        view?.showRoundResult(correct: correct, cards: cards)
        view?.setInteractionBlocked(true)
    }
    
    /// Called when the score is updated.
    /// - Parameter score: The new score value.
    func didUpdateScore(_ score: Int) {
        AchievementManager.shared.notifyFocusChampion()
        DailyTaskManager.shared.handleNewPoints(gameName: "Pair Game", category: "Focus", points: Int64(score))
        
        gameStatManager.updateScore(newScore: score) { result in
            switch result {
            case .success(let updatedHighScore):
                print("Server high score updated to: \(updatedHighScore)")
            case .failure(let error):
                print("Failed to update high score: \(error.localizedDescription)")
            }
        }
        
        view?.updateScore(score)
    }
    
    /// Called when the game session ends.
    /// - Parameter finalScore: The final score value.
    func didGameOver(finalScore: Int) {
        view?.showGameOver(score: finalScore)
    }
}
