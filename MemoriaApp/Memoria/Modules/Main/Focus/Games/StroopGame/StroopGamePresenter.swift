import UIKit

/// Presenter for the Stroop Game. Handles game flow and user interaction.
final class StroopGamePresenter: StroopGamePresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: StroopGameViewProtocol?
    var interactor: StroopGameInteractorProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let scorePerCorrectAnswer: Int = 150
        static let delayBeforeNextRound: TimeInterval = 0.25
        static let answerTimeout: TimeInterval = 1.5
        static let gameId: Int = 4
    }
    
    // MARK: - Game State
    
    private var gameStatManager = GameStatManager(gameId: Constants.gameId)
    private var score: Int = 0
    private var answerTimer: Timer?
    private var isInputBlocked: Bool = false
    private var isGameOver: Bool = false
    
    // MARK: - StroopGamePresenterProtocol
    
    /// Starts a new game session and resets all progress.
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

        score = 0
        isGameOver = false
        view?.updateScore(score)

        if let stroopInteractor = interactor as? StroopGameInteractor {
            stroopInteractor.resetGame()
        }

        startRound()
    }
    
    /// Handles user selecting a color.
    /// - Parameter color: The selected color.
    func userSelectedColor(_ color: UIColor) {
        guard !isGameOver, !isInputBlocked else { return }
        isInputBlocked = true

        answerTimer?.invalidate()
        answerTimer = nil

        interactor?.checkAnswer(selectedColor: color)

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayBeforeNextRound) { [weak self] in
            guard let self = self, !self.isGameOver else { return }
            self.startRound()
        }
    }
    
    // MARK: - Internal Logic
    
    /// Starts a new round, generating a word and starting the answer timer.
    private func startRound() {
        DailyTaskManager.shared.handleNewRound(gameName: "Stroop Game", category: "Focus")

        guard !isGameOver else { return }
        isInputBlocked = false
        interactor?.generateNextWord()
        startAnswerTimer()
    }
    
    /// Starts a countdown timer for the current round.
    private func startAnswerTimer() {
        answerTimer?.invalidate()
        answerTimer = Timer.scheduledTimer(withTimeInterval: Constants.answerTimeout, repeats: false) { [weak self] _ in
            guard let self = self, !self.isGameOver else { return }
            if !self.isInputBlocked {
                self.isInputBlocked = true
                self.interactor?.timeOut()
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayBeforeNextRound) {
                    if !self.isGameOver {
                        self.startRound()
                    }
                }
            }
        }
    }
}

// MARK: - StroopGameInteractorOutputProtocol

extension StroopGamePresenter: StroopGameInteractorOutputProtocol {
    
    func didGenerateNextWord(text: String, textColor: UIColor) {
        view?.displayWord(text: text, textColor: textColor)
    }
    
    func didUpdateMistakes(_ mistakes: Int, maxMistakes: Int) {
        view?.updateMistakes(mistakes, maxMistakes: maxMistakes)
    }
    
    func didGameOver(finalMistakes: Int) {
        isGameOver = true
        answerTimer?.invalidate()
        answerTimer = nil
        view?.showGameOver()
    }
    
    func didAnswerCorrect() {
        score += Constants.scorePerCorrectAnswer

        DailyTaskManager.shared.handleNewPoints(gameName: "Stroop Game", category: "Focus", points: Int64(score))
        AchievementManager.shared.notifyFocusChampion()

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
}
