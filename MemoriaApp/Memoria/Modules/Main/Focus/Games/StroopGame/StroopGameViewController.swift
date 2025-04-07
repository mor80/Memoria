import UIKit

/// ViewController for the Stroop Game.
final class StroopGameViewController: UIViewController, StroopGameViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - VIPER Reference
    
    var presenter: StroopGamePresenterProtocol!
    
    // MARK: - Constants
    
    private enum Constants {
        static let titleTopInset: CGFloat = 0
        static let backButtonLeftInset: CGFloat = 20
        static let scoreTopInset: CGFloat = 16
        static let wordTopInset: CGFloat = 32
        static let gridHorizontalInset: CGFloat = 30
        static let gridBottomInset: CGFloat = 100
        static let wordFontSize: CGFloat = 32
    }
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Stroop Game")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0")
    private let backButton = BackButton()
    private var startOverlay: GameStartOverlay!
    private var gameOverView: GameOverView?
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.wordFontSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var gridView: StroopGameGridView = {
        let grid = StroopGameGridView()
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.isHidden = true
        grid.onColorSelected = { [weak self] color in
            self?.presenter.userSelectedColor(color)
        }
        return grid
    }()
    
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
    
    // MARK: - UI Setup
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopInset)
        titleLabel.pinCenterX(to: view)
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeftInset)
        backButton.pinCenterY(to: titleLabel)
    }
    
    private func setupLayout() {
        view.addSubview(scoreLabel)
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, Constants.scoreTopInset)
        scoreLabel.pinCenterX(to: view)
        
        view.addSubview(wordLabel)
        wordLabel.pinTop(to: scoreLabel.bottomAnchor, Constants.wordTopInset)
        wordLabel.pinCenterX(to: view)
        
        view.addSubview(gridView)
        gridView.pinLeft(to: view, Constants.gridHorizontalInset)
        gridView.pinRight(to: view, Constants.gridHorizontalInset)
        gridView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.gridBottomInset)
    }
    
    private func setupStartOverlay() {
        startOverlay = GameStartOverlay()
        startOverlay.onStart = { [weak self] in
            guard let self = self else { return }
            self.hideStartOverlay()
            self.presenter.startGame()
        }
        view.addSubview(startOverlay)
        startOverlay.pin(to: view)
    }
    
    private func hideStartOverlay() {
        startOverlay.removeFromSuperview()
        startOverlay = nil
        wordLabel.isHidden = false
        gridView.isHidden = false
    }
    
    private func hideGameOverView() {
        gameOverView?.removeFromSuperview()
        gameOverView = nil
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - StroopGameViewProtocol
    
    func displayWord(text: String, textColor: UIColor) {
        wordLabel.text = text
        wordLabel.textColor = textColor
    }
    
    func updateMistakes(_ mistakes: Int, maxMistakes: Int) {
        // Mistakes are not displayed in this game.
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func showGameOver() {
        gameOverView = GameOverView()
        gameOverView?.setResultText("Game Over\n\(scoreLabel.text ?? "Score: 0")")
        gameOverView?.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter.startGame()
        }
        if let gameOverView = gameOverView {
            view.addSubview(gameOverView)
            gameOverView.pin(to: view)
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
