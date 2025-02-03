import UIKit

protocol MemoryMatrixViewProtocol: AnyObject {
    func displayGrid(size: (rows: Int, cols: Int))
    func highlightSquares(_ squares: [Position])
    func hideSquares()
    func updateLevel(level: Int)
    func showGameOver()
    func showIncorrectSelection(at position: Position) // 🔥 Добавлено для ошибок
}

class MemoryMatrixViewController: UIViewController, MemoryMatrixViewProtocol {
    var presenter: MemoryMatrixPresenterProtocol!

    private var gridView = UIStackView()
    private var gridButtons: [[UIButton]] = []
    private var selectedSquares: [Position] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGrid()
        presenter.startGame()
    }

    private func setupGrid() {
        gridView.axis = .vertical
        gridView.alignment = .center
        gridView.spacing = 5
        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)

        NSLayoutConstraint.activate([
            gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func displayGrid(size: (rows: Int, cols: Int)) {
        // Очистка старых кнопок
        gridButtons.forEach { row in row.forEach { $0.removeFromSuperview() } }
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
    }

    func highlightSquares(_ squares: [Position]) {
        squares.forEach { gridButtons[$0.row][$0.col].backgroundColor = .blue }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideSquares()
        }
    }

    func hideSquares() {
        gridButtons.forEach { row in row.forEach { $0.backgroundColor = .lightGray } }
        selectedSquares.removeAll()
    }

    func updateLevel(level: Int) {
        title = "Уровень \(level)"
    }

    func showGameOver() {
        let alert = UIAlertController(title: "Игра окончена", message: "Вы допустили 3 ошибки!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.presenter.startGame()
        }))
        present(alert, animated: true)
    }

    func showIncorrectSelection(at position: Position) { // 🔥 Новая функция
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = .red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            button.backgroundColor = .lightGray
        }
    }

    @objc private func squareTapped(_ sender: UIButton) {
        let row = sender.tag / gridButtons[0].count
        let col = sender.tag % gridButtons[0].count

        let selectedPosition = Position(row: row, col: col)

        if selectedSquares.contains(selectedPosition) {
            return // Не даем повторно выбирать один и тот же квадрат
        }

        selectedSquares.append(selectedPosition)
        presenter.checkSelection(selectedSquares)
    }
}
