import UIKit

/// ViewController for the Quick Math game, responsible for displaying problems, answers and handling user interaction.
final class QuickMathViewController: UIViewController, QuickMathViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - Constants
    
    private enum Constants {
        // Layout offsets and dimensions
        static let backButtonLeftInset: CGFloat = 20
        static let scoreLabelTopOffset: CGFloat = 16
        static let answerStackViewLeftRightInset: CGFloat = 30
        static let answerStackViewBottomOffset: CGFloat = 100
        static let answerButtonDimension: CGFloat = 70
    }
    
    // MARK: - VIPER
    
    var presenter: QuickMathPresenterProtocol?
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Quick Math")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0")
    private let backButton = BackButton()
    
    // Overlays for Game Over and Game Start screens.
    private var gameOverView: GameOverView?
    private var startOverlay: GameStartOverlay?
    
    // Content elements
    private let problemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true // Hidden until game starts.
        return stack
    }()
    
    private var answerButtons: [QuickMathAnswerButton] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupTitle()
        setupBackButton()
        setupLayout()
        setupAnswerButtons()
        setupStartOverlay()
            }
    
    // MARK: - Setup UI
    
    /// Configures and adds the title label.
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    /// Configures and adds the back button.
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeftInset)
        backButton.pinCenterY(to: titleLabel)
    }
    
    /// Configures layout for score label and problem label.
    private func setupLayout() {
        // Score Label
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, Constants.scoreLabelTopOffset)
        scoreLabel.pinCenterX(to: view)
        
        // Problem Label
        view.addSubview(problemLabel)
        problemLabel.pinCenter(to: view)
    }
    
    /// Creates and configures answer buttons and adds them to the stack view.
    private func setupAnswerButtons() {
        view.addSubview(answerStackView)
        
        // Create 4 answer buttons.
        for _ in 0..<4 {
            let button = QuickMathAnswerButton()
            button.setWidth(Constants.answerButtonDimension)
            button.setHeight(Constants.answerButtonDimension)
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            answerStackView.addArrangedSubview(button)
            answerButtons.append(button)
        }
        
        // Set constraints for the answer stack view.
        answerStackView.pinLeft(to: view, Constants.answerStackViewLeftRightInset)
        answerStackView.pinRight(to: view, Constants.answerStackViewLeftRightInset)
        answerStackView.pinBottom(to: view, Constants.answerStackViewBottomOffset)
    }
    
    /// Sets up the start overlay, which is displayed before the game starts.
    private func setupStartOverlay() {
        let overlay = GameStartOverlay()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.onStart = { [weak self] in
            self?.hideStartOverlay()
            self?.presenter?.startGame()
        }
        view.addSubview(overlay)
        overlay.pin(to: view)
        
        startOverlay = overlay
    }
    
    /// Hides the start overlay and reveals the answer buttons.
    private func hideStartOverlay() {
        startOverlay?.removeFromSuperview()
        startOverlay = nil
        answerStackView.isHidden = false
    }
    
    // MARK: - QuickMathViewProtocol
    
    /// Displays the problem and its answer options.
    /// - Parameters:
    ///   - question: The problem's question text.
    ///   - answers: An array of possible answers.
    func displayProblem(question: String, answers: [Int]) {
        problemLabel.text = question
        for (index, answer) in answers.enumerated() {
            if index < answerButtons.count {
                answerButtons[index].setTitle("\(answer)", for: .normal)
            }
        }
    }
    
    /// Updates the score label.
    /// - Parameter score: The current score.
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    /// Displays the Game Over view with the final score.
    /// - Parameter score: The final score.
    func showGameOver(with score: Int) {
        hideGameOverView()
        
        let overView = GameOverView()
        overView.translatesAutoresizingMaskIntoConstraints = false
        overView.setResultText("Game Over\nScore: \(score)")
        overView.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter?.restartGame()
        }
        view.addSubview(overView)
        overView.pin(to: view)
        
        gameOverView = overView
    }
    
    /// Enables or disables interaction with the answer buttons.
    /// - Parameter blocked: `true` to block interaction, `false` to allow.
    func setInteractionBlocked(_ blocked: Bool) {
        answerButtons.forEach { $0.isUserInteractionEnabled = !blocked }
    }
    
    // MARK: - Private Helpers
    
    /// Removes the Game Over view from the hierarchy.
    private func hideGameOverView() {
        gameOverView?.removeFromSuperview()
        gameOverView = nil
    }
    
    // MARK: - Actions
    
    /// Called when an answer button is tapped.
    /// - Parameter sender: The tapped answer button.
    @objc private func answerButtonTapped(_ sender: UIButton) {
        // Prevent repeated taps.
        setInteractionBlocked(true)
        
        guard
            let title = sender.title(for: .normal),
            let answer = Int(title)
        else { return }
        
        presenter?.userSelectedAnswer(answer)
    }
    
    /// Handles the back button tap.
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
