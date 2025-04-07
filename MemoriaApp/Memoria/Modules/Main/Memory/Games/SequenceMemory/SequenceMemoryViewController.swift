import UIKit

/// ViewController for the Sequence Memory game, responsible for displaying the grid and handling user interaction.
final class SequenceMemoryViewController: UIViewController, SequenceMemoryViewProtocol, UIGestureRecognizerDelegate {

    // MARK: - Constants

    private enum Constants {
        static let gridSpacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 30
        static let buttonBorderWidth: CGFloat = 2.0
        static let sequenceFlashDelay: TimeInterval = 0.25
        static let interactionEnableDelay: TimeInterval = 0.3
        static let incorrectFlashDelay: TimeInterval = 0.5
        static let highlightResetDelay: TimeInterval = 0.3
    }

    // MARK: - VIPER

    var presenter: SequenceMemoryPresenterProtocol!

    // MARK: - UI Elements

    private var gridView = UIStackView()
    private var gridButtons: [[UIButton]] = []
    private let titleLabel = CommonViews.makeTitleLabel(text: "Sequence Memory")
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

    /// Sets up the title label.
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }

    /// Sets up the back button.
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, 20)
        backButton.pinCenterY(to: titleLabel)
    }

    /// Sets up the score label and grid layout.
    private func setupLayout() {
        view.addSubview(scoreLabel)

        gridView.axis = .vertical
        gridView.alignment = .center
        gridView.spacing = Constants.gridSpacing
        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)

        scoreLabel.pinTop(to: titleLabel.bottomAnchor, 16)
        scoreLabel.pinCenterX(to: view)
        gridView.pinCenter(to: view)
    }

    /// Sets up the game start overlay.
    private func setupStartOverlay() {
        startOverlay = GameStartOverlay()
        startOverlay.translatesAutoresizingMaskIntoConstraints = false
        startOverlay.onStart = { [weak self] in
            self?.hideStartOverlay()
            self?.presenter.startGame()
        }
        view.addSubview(startOverlay)
        startOverlay.pin(to: view)
    }

    // MARK: - SequenceMemoryViewProtocol

    /// Displays a grid of buttons based on the given row and column counts.
    func displayGrid(rows: Int, cols: Int) {
        view.layoutIfNeeded()

        // Remove previous buttons
        for row in gridButtons {
            for button in row {
                button.removeFromSuperview()
            }
        }
        gridButtons.removeAll()
        gridView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let availableWidth = view.bounds.width - (Constants.horizontalPadding * 2)
        let totalSpacing = CGFloat(cols - 1) * Constants.gridSpacing
        let buttonWidth = (availableWidth - totalSpacing) / CGFloat(cols)

        for row in 0..<rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.spacing = Constants.gridSpacing
            gridView.addArrangedSubview(rowStack)

            var buttonRow: [UIButton] = []
            for col in 0..<cols {
                let button = UIButton(type: .system)
                button.backgroundColor = .white
                button.tag = row * cols + col
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

    /// Animates the full sequence by flashing the corresponding cells.
    func showSequence(_ sequence: [SequencePosition]) {
        isInteractionBlocked = true
        var delay: TimeInterval = 0
        for (index, pos) in sequence.enumerated() {
            delay = Double(index)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let btn = self.gridButtons[pos.row][pos.col]
                btn.backgroundColor = .systemBlue
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.sequenceFlashDelay) {
                    btn.backgroundColor = .white
                }
            }
        }

        let totalTime = delay + Constants.interactionEnableDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime) {
            self.isInteractionBlocked = false
        }
    }

    /// Highlights the tapped cell with a specific color.
    func highlightSelection(at position: SequencePosition, color: UIColor) {
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = color
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.highlightResetDelay) {
            button.backgroundColor = .white
        }
    }

    /// Shows the red flash for incorrect cell tap.
    func showIncorrectSelection(at position: SequencePosition) {
        let button = gridButtons[position.row][position.col]
        button.backgroundColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.incorrectFlashDelay) {
            button.backgroundColor = .white
        }
    }

    /// Updates the score label.
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }

    /// Displays the Game Over screen with final score and restart option.
    func showGameOver() {
        gameOverView = GameOverView()
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.setResultText("Game Over\n\(scoreLabel.text ?? "0")")
        gameOverView.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter.startGame()
        }
        view.addSubview(gameOverView)
        gameOverView.pin(to: view)
    }

    /// Enables or disables user interaction on the grid.
    func setInteractionBlocked(_ blocked: Bool) {
        isInteractionBlocked = blocked
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
        let pos = SequencePosition(row: row, col: col)
        presenter.userTapped(pos)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
