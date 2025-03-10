import UIKit

class FocusTargetInteractor: FocusTargetInteractorProtocol {
    weak var presenter: FocusTargetInteractorOutputProtocol?

    private var score = 0
    private var mistakes = 0
    private let maxMistakes = 5

    private var currentShape: FocusTargetShape?
    private var shapeTimer: Timer?

    private let shapeDisplayDuration: TimeInterval = 0.7

    /// Взвешенное распределение вероятностей:
    /// — 60%: круг + синий,
    /// — 10%: круг + красный,
    /// — 10%: круг + зелёный,
    /// — 5% : квадрат + синий,
    /// — 5% : квадрат + чёрный,
    /// — 10%: квадрат + жёлтый.
    /// Общая сумма весов = 100.
    private let shapePool: [(shape: ShapeType, color: UIColor, weight: Int)] = [
        (.circle, .blue, 65),
        (.circle, .red, 5),
        (.circle, .green, 5),
        (.square, .blue, 15),
        (.square, .black, 5),
        (.square, .yellow, 5)
    ]

    // Для генерации координат. В реальном проекте лучше принимать размеры
    // из ViewController, чтобы точно знать границы gameAreaView.
    private var playableArea: CGRect = CGRect(x: 0, y: 0, width: 300, height: 500)
    private let shapeSize = CGSize(width: 80, height: 80)

    // MARK: - FocusTargetInteractorProtocol

    func startGame() {
        score = 0
        mistakes = 0
        presenter?.didUpdateScore(score)
        presenter?.didUpdateMistakes(mistakes, maxMistakes: maxMistakes)

        generateNewShape()
    }

    func checkTap() {
        guard let shape = currentShape else { return }

        // Проверяем, нажали ли на «правильную» цель (синий круг)
        let isBlueCircle = (shape.shapeType == .circle && shape.color == .blue)
        if isBlueCircle {
            score += 1
            presenter?.didUpdateScore(score)
        } else {
            mistakes += 1
            presenter?.didUpdateMistakes(mistakes, maxMistakes: maxMistakes)

            if mistakes >= maxMistakes {
                endGame()
                return
            }
        }

        // После нажатия убираем текущую фигуру и генерируем новую
        cancelTimerAndHideShape()
        generateNewShape()
    }

    func shapeDidHide() {
        // Если это был синий круг, но пользователь не нажал — ошибка за пропуск
        if let shape = currentShape,
           shape.shapeType == .circle,
           shape.color == .blue {
            mistakes += 1
            presenter?.didUpdateMistakes(mistakes, maxMistakes: maxMistakes)

            if mistakes >= maxMistakes {
                endGame()
                return
            }
        }

        // Генерируем следующую фигуру
        generateNewShape()
    }

    // MARK: - Private

    private func generateNewShape() {
        let shape = weightedRandomShape()
        currentShape = shape

        // Сообщаем Presenter, что появилась новая фигура
        presenter?.didGenerateShape(shape)

        // Запускаем таймер, по истечении которого фигура исчезнет
        shapeTimer = Timer.scheduledTimer(withTimeInterval: shapeDisplayDuration, repeats: false) { [weak self] _ in
            self?.cancelTimerAndHideShape()
            self?.shapeDidHide()
        }
    }

    private func endGame() {
        cancelTimerAndHideShape()
        presenter?.didGameOver(finalScore: score)
    }

    private func cancelTimerAndHideShape() {
        shapeTimer?.invalidate()
        shapeTimer = nil
        currentShape = nil

        // Сообщаем Presenter, что фигура исчезла (чтобы View убрала её)
        presenter?.didGenerateShape(FocusTargetShape(
            shapeType: .circle,  // значение неважно
            color: .clear,       // укажем .clear, чтобы View удалила
            frame: .zero
        ))
    }

    /// Выбираем (shapeType, color) из shapePool с учётом веса,
    /// затем генерируем случайные координаты в пределах playableArea.
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

        // Генерируем позицию и размер
        let width = playableArea.width - shapeSize.width
        let height = playableArea.height - shapeSize.height

        let randomX = CGFloat.random(in: 0 ... max(0, width))
        let randomY = CGFloat.random(in: 0 ... max(0, height))
        let origin = CGPoint(x: playableArea.origin.x + randomX,
                             y: playableArea.origin.y + randomY)
        let frame = CGRect(origin: origin, size: shapeSize)

        return FocusTargetShape(shapeType: chosen.shape, color: chosen.color, frame: frame)
    }
}
