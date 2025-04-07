import UIKit

/// Interactor responsible for managing quick math problems and timer functionality.
final class QuickMathInteractor: QuickMathInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: QuickMathInteractorOutputProtocol?
    
    // MARK: - State
    
    private var currentProblem: QuickMathProblem?
    private var timer: Timer?
    
    // MARK: - Constants
    
    private enum Constants {
        static let answerTimeLimit: TimeInterval = 3.0
        static let leftBound: Int = 1
        static let rightBound: Int = 20
        static let incorrectAnswerOffsetMin: Int = -5
        static let incorrectAnswerOffsetMax: Int = 5
        static let totalAnswersCount: Int = 4
    }
    
    // MARK: - Public Methods
    
    /// Starts a new game by generating a problem.
    func startGame() {
        generateProblem()
    }
    
    /// Generates a new round within the current game.
    func generateNewRound() {
        generateProblem()
    }
    
    /// Validates the given answer against the current problem's answer.
    /// - Parameter answer: The answer to validate.
    func validateAnswer(_ answer: Int) {
        guard let problem = currentProblem else { return }
        cancelTimer()
        
        if answer == problem.answer {
            presenter?.didValidateCorrectAnswer()
        } else {
            presenter?.didFailAnswer()
        }
    }
    
    /// Starts a timer with a preset time limit.
    func startTimer() {
        cancelTimer()
        let newTimer = Timer.scheduledTimer(timeInterval: Constants.answerTimeLimit,
                                            target: self,
                                            selector: #selector(timerFired),
                                            userInfo: nil,
                                            repeats: false)
        timer = newTimer
        RunLoop.current.add(newTimer, forMode: .common)
    }
    
    /// Cancels the currently running timer.
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private Methods
    
    /// Generates a new quick math problem along with possible answers.
    private func generateProblem() {
        // Randomly select an operator.
        guard let op = QuickMathOperator.allCases.randomElement() else { return }
        
        let left = Int.random(in: Constants.leftBound...Constants.rightBound)
        let right = Int.random(in: Constants.leftBound...Constants.rightBound)
        
        // Create a new problem.
        let problem = QuickMathProblem(left: left, right: right, op: op)
        currentProblem = problem
        
        let correct = problem.answer
        var answers = [correct]
        
        // Generate incorrect answers until reaching the total count.
        while answers.count < Constants.totalAnswersCount {
            let offset = Int.random(in: Constants.incorrectAnswerOffsetMin...Constants.incorrectAnswerOffsetMax)
            let wrong = correct + offset
            if wrong != correct, !answers.contains(wrong) {
                answers.append(wrong)
            }
        }
        answers.shuffle()
        
        presenter?.didGenerateProblem(problem, answers: answers)
    }
    
    // MARK: - Timer Callback
    
    /// Called when the timer fires, indicating a timeout.
    @objc private func timerFired() {
        presenter?.didTimeout()
    }
}
