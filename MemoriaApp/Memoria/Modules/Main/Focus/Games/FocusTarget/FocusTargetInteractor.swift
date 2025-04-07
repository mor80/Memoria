import UIKit

/// Interactor for handling Focus Target game logic.
class FocusTargetInteractor: FocusTargetInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: FocusTargetInteractorOutputProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let maxMistakes = 5
        static let shapeDisplayDuration: TimeInterval = 0.7
        static let scorePerHit = 10
        static let shapeSize = CGSize(width: 80, height: 80)
        static let playableArea = CGRect(x: 0, y: 0, width: 320, height: 500)
    }

    // MARK: - Game State
    
    private var score = 0
    private var combo = 1
    private var mistakes = 0
    
    private var currentShape: FocusTargetShape?
    private var shapeTimer: Timer?
    
    private let shapePool: [(shape: ShapeType, color: UIColor, weight: Int)] = [
        (.circle, .blue, 70),
        (.circle, .red, 5),
        (.circle, .green, 5),
        (.square, .blue, 20),
    ]
    
    // MARK: - FocusTargetInteractorProtocol Methods
    
    /// Starts the game by resetting progress and generating the first shape.
    func startGame() {
        score = 0
        combo = 1
        mistakes = 0
        presenter?.didUpdateScore(score)
        generateNewShape()
    }
    
    /// Called when the user taps on the current shape.
    func checkTap() {
        guard let shape = currentShape else { return }

        if shape.shapeType == .circle && shape.color == .blue {
            score += Constants.scorePerHit * combo
            combo += 1
            presenter?.didUpdateScore(score)
        } else {
            mistakes += 1
            combo = 1
            if mistakes >= Constants.maxMistakes {
                endGame()
                return
            }
        }

        cancelTimerAndHideShape()
        generateNewShape()
    }
    
    /// Called when the shape was missed (timer expired).
    /// - Parameter missedShape: The shape that was not tapped.
    func shapeDidHide(missedShape: FocusTargetShape) {
        if missedShape.shapeType == .circle && missedShape.color == .blue {
            mistakes += 1
            combo = 1
            if mistakes >= Constants.maxMistakes {
                endGame()
                return
            }
        }
        generateNewShape()
    }
    
    // MARK: - Private Methods
    
    /// Generates a new shape and starts the timer.
    private func generateNewShape() {
        let shape = weightedRandomShape()
        currentShape = shape
        presenter?.didGenerateShape(shape)
        
        shapeTimer = Timer.scheduledTimer(withTimeInterval: Constants.shapeDisplayDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let missed = self.currentShape
            self.cancelTimerAndHideShape()
            if let shape = missed {
                self.shapeDidHide(missedShape: shape)
            }
        }
    }

    /// Ends the game and notifies the presenter.
    private func endGame() {
        cancelTimerAndHideShape()
        presenter?.didGameOver(finalScore: score)
    }

    /// Cancels the shape timer and hides the current shape.
    private func cancelTimerAndHideShape() {
        shapeTimer?.invalidate()
        shapeTimer = nil
        currentShape = nil
        presenter?.didGenerateShape(
            FocusTargetShape(shapeType: .circle, color: .clear, frame: .zero)
        )
    }

    /// Selects a random shape using weighted probability.
    /// - Returns: A new `FocusTargetShape` with randomized position and type.
    private func weightedRandomShape() -> FocusTargetShape {
        let totalWeight = shapePool.reduce(0) { $0 + $1.weight }
        let r = Int.random(in: 1...totalWeight)
        
        var sum = 0
        var chosen = shapePool.first!
        for item in shapePool {
            sum += item.weight
            if r <= sum {
                chosen = item
                break
            }
        }

        let maxX = max(0, Constants.playableArea.width - Constants.shapeSize.width)
        let maxY = max(0, Constants.playableArea.height - Constants.shapeSize.height)
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        let origin = CGPoint(x: Constants.playableArea.origin.x + randomX,
                             y: Constants.playableArea.origin.y + randomY)
        let frame = CGRect(origin: origin, size: Constants.shapeSize)

        return FocusTargetShape(shapeType: chosen.shape, color: chosen.color, frame: frame)
    }
}
