import UIKit

/// Протокол, через который Presenter сообщает View, что нужно отобразить
protocol SequenceMemoryViewProtocol: AnyObject {
    /// Показать сетку 3×3 (создать нужные UIButton в UIStackView)
    func displayGrid(rows: Int, cols: Int)

    /// Прокрутить анимацию подсветки (каждый квадрат загорается на 0.3s)
    func showSequence(_ sequence: [SequencePosition])

    /// Подсветить клетку для «правильного» нажатия
    func highlightSelection(at position: SequencePosition, color: UIColor)

    /// Подсветить клетку при ошибке (красным)
    func showIncorrectSelection(at position: SequencePosition)

    /// Показать, сколько осталось ошибок
    func updateMistakesLeft(_ left: Int)

    /// Обновить уровень (title = "Уровень X")
    func updateLevel(_ level: Int)

    /// Показать Game Over (UIAlertController)
    func showGameOver()
}

final class SequenceMemoryViewController: UIViewController, SequenceMemoryViewProtocol {

    var presenter: SequenceMemoryPresenterProtocol!

    private let gridView = UIStackView()
    private var gridButtons: [[UIButton]] = []

    // Блокируем клики на время демонстрации последовательности
    private var isInteractionBlocked = false

    private let mistakesLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибок осталось: 3"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        
        // Presenter запустит игру
        // (Можно вызвать вручную, если требуется)
         presenter.startGame()
    }

    // MARK: - Layout with UIView+Pin
    private func setupLayout() {
        let topStack = UIStackView(arrangedSubviews: [mistakesLabel])
        topStack.axis = .vertical
        topStack.alignment = .center
        topStack.spacing = 8

        view.addSubview(topStack)
        view.addSubview(gridView)

        // Настраиваем gridView
        gridView.axis = .vertical
        gridView.alignment = .center
        gridView.spacing = 5

        // Пример использования вашего UIView+Pin:
        topStack.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        topStack.pinCenterX(to: view)

        gridView.pinCenter(to: view)
    }

    // MARK: - SequenceMemoryViewProtocol

    func displayGrid(rows: Int, cols: Int) {
        // Удаляем старые кнопки
        for row in gridButtons {
            for button in row {
                button.removeFromSuperview()
            }
        }
        gridButtons.removeAll()
        gridView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Создаём новую сетку
        for rowIndex in 0..<rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.spacing = 5
            gridView.addArrangedSubview(rowStack)

            var buttonRow: [UIButton] = []
            for colIndex in 0..<cols {
                let button = UIButton(type: .system)
                button.backgroundColor = .lightGray
                button.tag = rowIndex * cols + colIndex
                // Размер кнопки
                button.setWidth(mode: .equal, 50)
                button.setHeight(mode: .equal, 50)
                button.addTarget(self, action: #selector(squareTapped(_:)), for: .touchUpInside)

                rowStack.addArrangedSubview(button)
                buttonRow.append(button)
            }
            gridButtons.append(buttonRow)
        }

        // После вызова displayGrid мы ещё не показываем последовательность
        // Отключаем блокировку — покажем её при showSequence
        isInteractionBlocked = false
    }

    func showSequence(_ sequence: [SequencePosition]) {
        // Пока идёт анимация подсветки — блокируем
        isInteractionBlocked = true

        // Каждая клетка подсвечивается 0.3s
        var delay: TimeInterval = 0
        for (index, pos) in sequence.enumerated() {
            delay = Double(index) * 1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let btn = self.gridButtons[pos.row][pos.col]
                btn.backgroundColor = .blue

                // Отключаем через 0.25, оставив 0.05 между показами
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    btn.backgroundColor = .lightGray
                }
            }
        }

        // По окончании всей последовательности снова разрешаем клики
        let totalTime = delay + 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime) {
            self.isInteractionBlocked = false
        }
    }

    func highlightSelection(at position: SequencePosition, color: UIColor) {
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = color
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
         button.backgroundColor = .lightGray
        }
    }

    func showIncorrectSelection(at position: SequencePosition) {
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = .red

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            button.backgroundColor = .lightGray
        }
    }

    func updateMistakesLeft(_ left: Int) {
        mistakesLabel.text = "Ошибок осталось: \(left)"
    }

    func updateLevel(_ level: Int) {
        title = "Уровень \(level)"
    }

    func showGameOver() {
        let alert = UIAlertController(
            title: "Игра окончена",
            message: "Вы допустили 3 ошибки!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Начинаем игру заново
            self.presenter.startGame()
        }))
        present(alert, animated: true)
    }

    // MARK: - Actions

    @objc private func squareTapped(_ sender: UIButton) {
        guard !isInteractionBlocked else {
            return
        }
        guard let firstRow = gridButtons.first else { return }
        let colsCount = firstRow.count
        let row = sender.tag / colsCount
        let col = sender.tag % colsCount

        let pos = SequencePosition(row: row, col: col)
        presenter.userTapped(pos)
    }
}
