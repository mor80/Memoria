import UIKit

/// Interactor for the Pair Game. Handles game logic, rounds, and user interactions.
final class PairGameInteractor: PairGameInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: PairGameInteractorOutputProtocol?
    
    // MARK: - Game State
    
    private var currentCards: [CardEntity] = []
    private var selectedIndices: [Int] = []
    
    private var score: Int = 0
    private var mistakes: Int = 0
    private let maxMistakes: Int = 3
    
    private var selectionTimer: Timer?
    
    // MARK: - Timing
    
    private let selectionDuration: TimeInterval = 2.0
    private let initialRevealDuration: TimeInterval = 4.0
    
    // MARK: - Configuration
    
    private let availableIcons = [
        "star", "heart", "bolt", "flame", "leaf", "moon",
        "sun.max", "cloud", "snow", "wind", "ant", "hare",
        "tortoise", "ladybug", "gear"
    ]
    
    private let gridCount = 16
    
    // MARK: - Public Methods
    
    /// Starts a new game session.
    func startGame() {
        selectionTimer?.invalidate()
        selectionTimer = nil
        score = 0
        mistakes = 0
        presenter?.didUpdateScore(score)
        selectedIndices.removeAll()
        startRound()
    }
    
    /// Starts a new round by generating and revealing cards.
    func startRound() {
        selectedIndices.removeAll()
        currentCards = generateCards()
        presenter?.didGenerateGrid(currentCards)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + initialRevealDuration) { [weak self] in
            guard let self = self else { return }
            self.presenter?.didHideCards()
            self.startSelectionTimer()
        }
    }
    
    /// Handles card selection by user.
    /// - Parameter index: Index of the selected card.
    func userSelectedCard(at index: Int) {
        guard index < currentCards.count, !selectedIndices.contains(index) else { return }
        
        selectionTimer?.invalidate()
        selectionTimer = nil
        
        selectedIndices.append(index)
        let card = currentCards[index]
        presenter?.didRevealCard(card, at: index)
        
        if selectedIndices.count == 2 {
            evaluateSelection()
        } else {
            startSelectionTimer()
        }
    }
    
    // MARK: - Internal Logic
    
    /// Starts a timer that evaluates the selection after a delay.
    private func startSelectionTimer() {
        selectionTimer?.invalidate()
        selectionTimer = Timer.scheduledTimer(withTimeInterval: selectionDuration, repeats: false) { [weak self] _ in
            self?.evaluateSelection()
        }
    }
    
    /// Evaluates whether the selected cards are a correct match.
    private func evaluateSelection() {
        selectionTimer?.invalidate()
        selectionTimer = nil
        
        if selectedIndices.count != 2 {
            mistakes += 1
            if mistakes >= maxMistakes {
                endGame()
                return
            }
            finishRound(correct: false)
            return
        }
        
        let firstCard = currentCards[selectedIndices[0]]
        let secondCard = currentCards[selectedIndices[1]]
        
        let correct = firstCard.isMatching && secondCard.isMatching && (firstCard.icon == secondCard.icon)
        if correct {
            score += 150
            presenter?.didUpdateScore(score)
        } else {
            mistakes += 1
            if mistakes >= maxMistakes {
                endGame()
                return
            }
        }
        
        finishRound(correct: correct)
    }
    
    /// Finishes the round and starts a new one after a short delay.
    /// - Parameter correct: Indicates whether the round was successful.
    private func finishRound(correct: Bool) {
        presenter?.didFinishRound(correct: correct, with: currentCards)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.startRound()
        }
    }
    
    /// Ends the game session.
    private func endGame() {
        selectionTimer?.invalidate()
        selectionTimer = nil
        presenter?.didGameOver(finalScore: score)
    }
    
    /// Generates the card set for a round, including one matching pair and filler cards.
    /// - Returns: Array of shuffled `CardEntity` objects.
    private func generateCards() -> [CardEntity] {
        guard let pairIcon = availableIcons.randomElement() else { return [] }
        
        var remainingIcons = availableIcons.filter { $0 != pairIcon }
        remainingIcons.shuffle()
        
        let uniqueIcons = Array(remainingIcons.prefix(14))
        
        var cards: [CardEntity] = []
        
        let pairCard1 = CardEntity(id: 0, icon: pairIcon, isMatching: true)
        let pairCard2 = CardEntity(id: 1, icon: pairIcon, isMatching: true)
        cards.append(contentsOf: [pairCard1, pairCard2])
        
        for (index, icon) in uniqueIcons.enumerated() {
            let card = CardEntity(id: index + 2, icon: icon, isMatching: false)
            cards.append(card)
        }
        
        while cards.count < gridCount {
            let extraIcon = remainingIcons.randomElement() ?? "questionmark"
            let card = CardEntity(id: cards.count, icon: extraIcon, isMatching: false)
            cards.append(card)
        }
        
        cards.shuffle()
        return cards
    }
}
