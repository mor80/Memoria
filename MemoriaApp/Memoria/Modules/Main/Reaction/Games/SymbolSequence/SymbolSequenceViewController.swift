import UIKit

/// ViewController for the Symbol Sequence game.
final class SymbolSequenceViewController: UIViewController, SymbolSequenceViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - VIPER Reference
    
    var presenter: SymbolSequencePresenterProtocol!
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Symbol Sequence")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0")
    private let backButton = BackButton()
    
    private var gameOverView: GameOverView!
    private var startOverlay: GameStartOverlay!
    
    private var sequenceStackView: UIStackView!
    private var buttonStack: UIStackView!
    private var gamepadButtons: [GamepadButton] = []
    
    // MARK: - Constants
    
    private enum Constants {
        static let backButtonLeftMargin: CGFloat = 20
        static let scoreLabelTopSpacing: CGFloat = 16
        static let sequenceStackSpacing: CGFloat = 16
        static let gamepadButtonSize: CGFloat = 70
        static let buttonStackLeftRightMargin: CGFloat = 30
        static let buttonStackBottomMargin: CGFloat = 100
        static let sequenceIconSize: CGFloat = 40
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        setupTitle()
        setupBackButton()
        setupScoreLabel()
        setupSequenceStackView()
        setupButtonStack()
        setupStartOverlay()
    }
    
    // MARK: - Setup Methods
    
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
        backButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeftMargin)
        backButton.pinCenterY(to: titleLabel)
    }
    
    /// Configures and adds the score label.
    private func setupScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, Constants.scoreLabelTopSpacing)
        scoreLabel.pinCenterX(to: view)
    }
    
    /// Configures and adds the stack view for displaying the symbol sequence.
    private func setupSequenceStackView() {
        sequenceStackView = UIStackView()
        sequenceStackView.axis = .horizontal
        sequenceStackView.alignment = .center
        sequenceStackView.distribution = .equalSpacing
        sequenceStackView.spacing = Constants.sequenceStackSpacing
        sequenceStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sequenceStackView)
        sequenceStackView.pinCenter(to: view)
    }
    
    /// Configures and adds the button stack for gamepad buttons.
    private func setupButtonStack() {
        buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .equalSpacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        // Hide buttons until the game starts.
        buttonStack.isHidden = true
        
        let symbols: [SymbolSequenceSymbol] = [.triangle, .circle, .cross, .square]
        for symbol in symbols {
            let button = GamepadButton()
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            let image = UIImage(systemName: symbol.sfSymbolName, withConfiguration: config)
            button.setImage(image, for: .normal)
            button.setWidth(Constants.gamepadButtonSize)
            button.setHeight(Constants.gamepadButtonSize)
            button.addTarget(self, action: #selector(gamepadButtonTapped(_:)), for: .touchUpInside)
            buttonStack.addArrangedSubview(button)
            gamepadButtons.append(button)
        }
        
        buttonStack.pinLeft(to: view, Constants.buttonStackLeftRightMargin)
        buttonStack.pinRight(to: view, Constants.buttonStackLeftRightMargin)
        buttonStack.pinBottom(to: view, Constants.buttonStackBottomMargin)
    }
    
    /// Configures and adds the start overlay.
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
    
    /// Removes the start overlay and reveals the gamepad buttons.
    private func hideStartOverlay() {
        startOverlay.removeFromSuperview()
        startOverlay = nil
        buttonStack.isHidden = false
    }
    
    // MARK: - SymbolSequenceViewProtocol Methods
    
    /// Displays the given sequence of symbols using icon views.
    /// - Parameter sequence: The sequence of symbols to display.
    func displaySequence(_ sequence: [SymbolSequenceSymbol]) {
        // Remove previous sequence views.
        sequenceStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let config = UIImage.SymbolConfiguration(weight: .bold)
        for symbol in sequence {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let image = UIImage(systemName: symbol.sfSymbolName, withConfiguration: config)
            imageView.image = image
            imageView.tintColor = .systemBlue
            imageView.contentMode = .scaleAspectFit
            imageView.setWidth(Constants.sequenceIconSize)
            imageView.setHeight(Constants.sequenceIconSize)
            sequenceStackView.addArrangedSubview(imageView)
        }
    }
    
    /// Updates the score display.
    /// - Parameter score: The current score.
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    /// Displays the Game Over screen with the final score.
    /// - Parameter score: The final score.
    func showGameOver(with score: Int) {
        gameOverView = GameOverView()
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.setResultText("Game Over\nScore: \(score)")
        gameOverView.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter.restartGame()
        }
        view.addSubview(gameOverView)
        gameOverView.pin(to: view)
    }
    
    /// Enables or disables interaction with the gamepad buttons.
    /// - Parameter blocked: Set `true` to block interaction.
    func setInteractionBlocked(_ blocked: Bool) {
        gamepadButtons.forEach { $0.isUserInteractionEnabled = !blocked }
    }
    
    /// Removes the Game Over view.
    private func hideGameOverView() {
        gameOverView.removeFromSuperview()
        gameOverView = nil
    }
    
    // MARK: - Actions
    
    /// Handles gamepad button taps.
    /// - Parameter sender: The tapped button.
    @objc private func gamepadButtonTapped(_ sender: UIButton) {
        guard let index = gamepadButtons.firstIndex(of: sender as! GamepadButton) else { return }
        let symbols: [SymbolSequenceSymbol] = [.triangle, .circle, .cross, .square]
        let symbol = symbols[index]
        presenter.userTapped(symbol: symbol)
    }
    
    /// Handles the back button tap.
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
