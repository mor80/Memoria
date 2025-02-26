import UIKit

protocol MemoryMatrixViewProtocol: AnyObject {
    func displayGrid(size: (rows: Int, cols: Int))
    func highlightSquares(_ squares: [Position])
    func hideSquares()
    func updateLevel(level: Int)
    func showGameOver()
    func showIncorrectSelection(at position: Position)

    // Подсветить одну клетку указанным цветом (для правильных кликов)
    func highlightSelection(at position: Position, color: UIColor)

    // Показать, сколько ошибок осталось
    func updateMistakesLeft(_ left: Int)
}

class MemoryMatrixViewController: UIViewController, MemoryMatrixViewProtocol {
    var presenter: MemoryMatrixPresenterProtocol!

    private var gridView = UIStackView()
    private var gridButtons: [[UIButton]] = []

    // Флаг для блокировки нажатий на время подсветки
    private var isInteractionBlocked = false

    private let mistakesLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибок осталось: 3"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        presenter.startGame()
    }

    private func setupLayout() {
        let topStack = UIStackView(arrangedSubviews: [mistakesLabel])
        topStack.axis = .vertical
        topStack.alignment = .center
        topStack.spacing = 8
        topStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStack)

        gridView.axis = .vertical
        gridView.alignment = .center
        gridView.spacing = 5
        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)

        topStack.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        topStack.pinCenterX(to: view)
        
        gridView.pinCenter(to: view)
    }

    func displayGrid(size: (rows: Int, cols: Int)) {
        // Удаляем предыдущие кнопки
        for row in gridButtons {
            for button in row {
                button.removeFromSuperview()
            }
        }
        gridButtons.removeAll()
        gridView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for row in 0..<size.rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.spacing = 5
            gridView.addArrangedSubview(rowStack)

            var buttonRow: [UIButton] = []
            for col in 0..<size.cols {
                let button = UIButton(type: .system)
                button.backgroundColor = .lightGray
                button.tag = row * size.cols + col
                button.widthAnchor.constraint(equalToConstant: 50).isActive = true
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
                button.addTarget(self, action: #selector(squareTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
                buttonRow.append(button)
            }
            gridButtons.append(buttonRow)
        }

        // В начале нового раунда разрешаем нажатие,
        // но дальше временно заблокируем при подсветке
        isInteractionBlocked = false
    }

    func highlightSquares(_ squares: [Position]) {
        // Блокируем клики на время подсветки
        isInteractionBlocked = true

        squares.forEach {
            gridButtons[$0.row][$0.col].backgroundColor = .blue
        }

        // Время подсветки = 0.3 * количество клеток
        let highlightDuration = 0.3 * Double(squares.count)

        DispatchQueue.main.asyncAfter(deadline: .now() + highlightDuration) {
            // Возвращаем всем клеткам исходный цвет
            self.hideSquares()
            // Снова разрешаем нажатия
            self.isInteractionBlocked = false
        }
    }

    func hideSquares() {
        for row in gridButtons {
            for button in row {
                button.backgroundColor = .lightGray
            }
        }
    }

    func updateLevel(level: Int) {
        title = "Уровень \(level)"
    }

    func showGameOver() {
        let alert = UIAlertController(
            title: "Игра окончена",
            message: "Вы допустили 3 ошибки!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.presenter.startGame()
        }))
        present(alert, animated: true)
    }

    func showIncorrectSelection(at position: Position) {
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = .red

        // Через 0.5 сек возвращаем цвет
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            button.backgroundColor = .lightGray
        }
    }

    func highlightSelection(at position: Position, color: UIColor) {
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = color
    }

    func updateMistakesLeft(_ left: Int) {
        mistakesLabel.text = "Ошибок осталось: \(left)"
    }

    @objc private func squareTapped(_ sender: UIButton) {
        // Если заблокировано — игнорируем
        guard !isInteractionBlocked else {
            return
        }

        guard let firstRow = gridButtons.first else { return }
        let colsCount = firstRow.count
        let row = sender.tag / colsCount
        let col = sender.tag % colsCount

        let tappedPosition = Position(row: row, col: col)
        presenter.userTapped(position: tappedPosition)
    }
}
