import UIKit

/// ViewController for the Focus Target game.
class FocusTargetViewController: UIViewController, FocusTargetViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - VIPER Reference
    
    var presenter: FocusTargetPresenterProtocol?
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Focus Target")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0")
    private let backButton = BackButton()
    
    private var startOverlay: GameStartOverlay!
    private var gameOverView: GameOverView!
    
    private let gameAreaView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private var shapeButton: UIButton = UIButton(type: .system)
    
    // MARK: - Constants
    
    private enum Constants {
        static let titleTopSpacing: CGFloat = 0
        static let scoreTopSpacing: CGFloat = 16
        static let shapeCornerRadius: CGFloat = 8
        static let shapeShadowColor: CGColor = UIColor.black.cgColor
        static let shapeShadowOffset: CGSize = CGSize(width: 0, height: 2)
        static let shapeShadowOpacity: Float = 0.3
        static let shapeShadowRadius: CGFloat = 4
        static let backButtonLeading: CGFloat = 20
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
        setupLayout()
        setupStartOverlay()
    }
    
    // MARK: - UI Setup
    
    private func setupStartOverlay() {
        startOverlay = GameStartOverlay()
        startOverlay.onStart = { [weak self] in
            guard let self = self else { return }
            self.hideStartOverlay()
            self.presenter?.startGame()
        }
        view.addSubview(startOverlay)
        startOverlay.pin(to: view)
    }
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopSpacing)
        titleLabel.pinCenterX(to: view)
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeading)
        backButton.pinCenterY(to: titleLabel)
    }
    
    private func setupScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, Constants.scoreTopSpacing)
        scoreLabel.pinCenterX(to: view)
    }
    
    private func setupLayout() {
        view.addSubview(gameAreaView)
        gameAreaView.pinTop(to: scoreLabel.bottomAnchor, Constants.scoreTopSpacing)
        gameAreaView.pinLeft(to: view)
        gameAreaView.pinRight(to: view)
        gameAreaView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    // MARK: - FocusTargetViewProtocol
    
    func displayShape(_ shape: FocusTargetShape) {
        removeShape()
        let button = UIButton(type: .system)
        button.frame = shape.frame
        button.backgroundColor = shape.color
        
        if shape.shapeType == .circle {
            button.layer.cornerRadius = shape.frame.height / 2
        } else {
            button.layer.cornerRadius = Constants.shapeCornerRadius
        }
        
        button.layer.shadowColor = Constants.shapeShadowColor
        button.layer.shadowOffset = Constants.shapeShadowOffset
        button.layer.shadowOpacity = Constants.shapeShadowOpacity
        button.layer.shadowRadius = Constants.shapeShadowRadius
        
        button.addTarget(self, action: #selector(shapeTapped), for: .touchUpInside)
        gameAreaView.addSubview(button)
        shapeButton = button
    }
    
    func removeShape() {
        shapeButton.removeFromSuperview()
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateMistakes(_ mistakes: Int, maxMistakes: Int) {
        // Mistakes are tracked internally but not shown in UI.
    }
    
    func showGameOver(score: Int) {
        gameOverView = GameOverView()
        gameOverView.setResultText("Game Over\nScore: \(score)")
        gameOverView.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter?.startGame()
        }
        view.addSubview(gameOverView)
        gameOverView.pin(to: view)
    }
    
    // MARK: - Actions
    
    @objc private func shapeTapped() {
        presenter?.userTappedShape()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Overlay Handling
    
    private func hideStartOverlay() {
        startOverlay.removeFromSuperview()
        startOverlay = nil
    }
    
    private func hideGameOverView() {
        gameOverView.removeFromSuperview()
        gameOverView = nil
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
