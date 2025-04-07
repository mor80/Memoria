import UIKit

/// ViewController for the Matrix Memory game.
final class MemoryMatrixViewController: UIViewController, MemoryMatrixViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - Constants
    
    private enum Constants {
        static let gridSpacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 30
        static let buttonBorderWidth: CGFloat = 2.0
        static let highlightDelay: Double = 1.0
        static let wrongSelectionFlashDuration: TimeInterval = 0.5
    }
    
    // MARK: - VIPER
    
    var presenter: MemoryMatrixPresenterProtocol!
    
    // MARK: - UI Elements
    
    private let gridView = UIStackView()
    private var gridButtons: [[UIButton]] = []
    private let titleLabel = CommonViews.makeTitleLabel(text: "Matrix Memory")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0")
    private let backButton = BackButton()
    private var startOverlay: GameStartOverlay!
    private var gameOverView: GameOverView!
    
    private var isInteractionBlocked = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupTitle()
        setupBackButton()
        setupLayout()
        setupStartOverlay()
    }
    
    // MARK: - Setup UI
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, 20)
        backButton.pinCenterY(to: titleLabel)
    }
    
    private func setupLayout() {
        view.addSubview(scoreLabel)
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, 16)
        scoreLabel.pinCenterX(to: view)
        
        gridView.axis = .vertical
        gridView.alignment = .center
        gridView.spacing = Constants.gridSpacing
        view.addSubview(gridView)
        gridView.pinCenter(to: view)
    }
    
    private func setupStartOverlay() {
        startOverlay = GameStartOverlay()
        startOverlay.onStart = { [weak self] in
            self?.hideStartOverlay()
            self?.presenter.startGame()
        }
        view.addSubview(startOverlay)
        startOverlay.pin(to: view)
    }
    
    // MARK: - MemoryMatrixViewProtocol
    
    func displayGrid(size: (rows: Int, cols: Int)) {
        view.layoutIfNeeded()
        
        // Clean previous
        for row in gridButtons {
            for button in row {
                button.removeFromSuperview()
            }
        }
        gridButtons.removeAll()
        gridView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let availableWidth = view.bounds.width - (Constants.horizontalPadding * 2)
        let totalSpacing = CGFloat(size.cols - 1) * Constants.gridSpacing
        let buttonWidth = (availableWidth - totalSpacing) / CGFloat(size.cols)
        
        for row in 0..<size.rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.spacing = Constants.gridSpacing
            gridView.addArrangedSubview(rowStack)
            
            var buttonRow: [UIButton] = []
            for col in 0..<size.cols {
                let button = UIButton(type: .system)
                button.backgroundColor = .white
                button.tag = row * size.cols + col
                button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                button.layer.shadowColor = SquareStyle.shadowColor
                button.layer.shadowOffset = SquareStyle.shadowOffset
                button.layer.shadowOpacity = SquareStyle.shadowOpacity
                button.layer.shadowRadius = SquareStyle.shadowRadius
                button.layer.cornerRadius = SquareStyle.cornerRadius
                button.layer.borderColor = UIColor.systemBlue.cgColor
                button.layer.borderWidth = Constants.buttonBorderWidth
                button.addTarget(self, action: #selector(squareTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
                buttonRow.append(button)
            }
            gridButtons.append(buttonRow)
        }
        isInteractionBlocked = false
    }
    
    func highlightSquares(_ squares: [Position]) {
        isInteractionBlocked = true
        
        squares.forEach {
            guard $0.row < gridButtons.count, $0.col < gridButtons[$0.row].count else { return }
            gridButtons[$0.row][$0.col].backgroundColor = .systemBlue
        }
        
        let delay = Constants.highlightDelay + (0.3 * Double(squares.count))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.hideSquares()
            self.isInteractionBlocked = false
        }
    }
    
    func hideSquares() {
        for row in gridButtons {
            for button in row {
                if button.backgroundColor == .systemBlue {
                    button.backgroundColor = .white
                }
            }
        }
    }
    
    func showIncorrectSelection(at position: Position) {
        guard position.row < gridButtons.count, position.col < gridButtons[position.row].count else { return }
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = .red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.wrongSelectionFlashDuration) {
            if button.backgroundColor != .green {
                button.backgroundColor = .white
            }
        }
    }
    
    func highlightSelection(at position: Position, color: UIColor) {
        guard position.row < gridButtons.count, position.col < gridButtons[position.row].count else { return }
        gridButtons[position.row][position.col].backgroundColor = color
    }
    
    func setInteractionBlocked(_ blocked: Bool) {
        isInteractionBlocked = blocked
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func showGameOver() {
        gameOverView = GameOverView()
        gameOverView.setResultText("Game Over\n\(scoreLabel.text ?? "0")")
        gameOverView.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter.startGame()
        }
        view.addSubview(gameOverView)
        gameOverView.pin(to: view)
    }
    
    // MARK: - Private Helpers
    
    private func hideStartOverlay() {
        startOverlay.removeFromSuperview()
        startOverlay = nil
    }
    
    private func hideGameOverView() {
        gameOverView.removeFromSuperview()
        gameOverView = nil
    }
    
    // MARK: - Actions
    
    @objc private func squareTapped(_ sender: UIButton) {
        guard !isInteractionBlocked else { return }
        guard let firstRow = gridButtons.first else { return }
        let colsCount = firstRow.count
        let row = sender.tag / colsCount
        let col = sender.tag % colsCount
        let position = Position(row: row, col: col)
        presenter.userTapped(position: position)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
