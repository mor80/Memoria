import Foundation

/// Interactor responsible for managing the reaction time game rounds.
final class ReactionTimeInteractor: ReactionTimeInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: ReactionTimeInteractorOutputProtocol?
    
    // MARK: - State
    
    private var isWaitingForGreen = false
    private var isReactionPhase = false
    private var reactionStartTime: Date?
    private var timer: Timer?
    
    // MARK: - Constants
    
    private enum Constants {
        static let delayRange: ClosedRange<Double> = 2.0...5.0
        static let millisecondsMultiplier: Double = 1000
    }
    
    // MARK: - Game Flow
    
    /// Starts a new round by transitioning to the waiting phase.
    func startRound() {
        isWaitingForGreen = true
        isReactionPhase = false
        presenter?.DidStartWaitingPhase()
        
        let delay = Double.random(in: Constants.delayRange)
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.turnGreen()
        }
    }
    
    /// Transitions the game to the reaction phase by turning green.
    @objc private func turnGreen() {
        if isWaitingForGreen {
            isWaitingForGreen = false
            isReactionPhase = true
            reactionStartTime = Date()
            presenter?.DidTurnGreen()
        }
    }
    
    /// Handles the user's tap and measures reaction time or detects early tap.
    func userTapped() {
        // Early tap: user tapped during waiting phase.
        if isWaitingForGreen {
            timer?.invalidate()
            timer = nil
            isWaitingForGreen = false
            presenter?.DidDetectEarlyTap()
        }
        // Valid reaction: measure reaction time.
        else if isReactionPhase {
            guard let startTime = reactionStartTime else { return }
            let reactionTime = Date().timeIntervalSince(startTime) * Constants.millisecondsMultiplier
            isReactionPhase = false
            timer?.invalidate()
            timer = nil
            presenter?.DidRecordReactionTime(Int(reactionTime))
        }
        // If neither phase – do nothing.
    }
    
    /// Resets the current round.
    func resetRound() {
        isWaitingForGreen = false
        isReactionPhase = false
        reactionStartTime = nil
        timer?.invalidate()
        timer = nil
    }
}
