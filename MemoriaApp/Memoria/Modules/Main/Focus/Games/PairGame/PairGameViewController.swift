import UIKit

/// ViewController for the Pair Game screen.
final class PairGameViewController: UIViewController, PairGameViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - VIPER Reference
    
    var presenter: PairGamePresenterProtocol?
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Pair Game")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0")
    private let backButton = BackButton()
    
    private var startOverlay: GameStartOverlay!
    private var gameOverView: GameOverView!
    
    private var gridView = UIStackView()
    private var cardButtons: [UIButton] = []
    private var isInteractionBlocked = true
    
    // MARK: - Constants
    
    private enum Constants {
        static let gridRows = 4
        static let gridCols = 4
        static let gridHorizontalPadding: CGFloat = 60
        static let buttonSpacing: CGFloat = 8
        static let buttonCornerRadius: CGFloat = 8
        static let buttonBorderWidth: CGFloat = 4.0
        static let buttonSymbolSize: CGFloat = 24
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
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
        setupGridView()
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
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, 20)
        backButton.pinCenterY(to: titleLabel)
    }
    
    private func setupScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, 16)
        scoreLabel.pinCenterX(to: view)
    }
    
    private func setupGridView() {
        gridView.axis = .vertical
        gridView.alignment = .center
        gridView.spacing = Constants.buttonSpacing
        view.addSubview(gridView)
        gridView.pinLeft(to: view)
        gridView.pinCenter(to: view)
    }
    
    // MARK: - PairGameViewProtocol
    
    func displayGrid(cards: [CardEntity], revealAll: Bool) {
        cardButtons.forEach { $0.removeFromSuperview() }
        cardButtons.removeAll()
        gridView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let availableWidth = view.bounds.width - Constants.gridHorizontalPadding
        let totalSpacing = CGFloat(Constants.gridCols - 1) * Constants.buttonSpacing
        let buttonWidth = (availableWidth - totalSpacing) / CGFloat(Constants.gridCols)
        
        for row in 0..<Constants.gridRows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.spacing = Constants.buttonSpacing
            rowStack.distribution = .fillEqually
            gridView.addArrangedSubview(rowStack)
            
            for col in 0..<Constants.gridCols {
                let index = row * Constants.gridCols + col
                let button = UIButton(type: .system)
                button.tag = index
                button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                button.layer.cornerRadius = Constants.buttonCornerRadius
                button.layer.borderWidth = Constants.buttonBorderWidth
                button.layer.borderColor = UIColor.systemBlue.cgColor
                button.layer.shadowColor = Constants.shadowColor
                button.layer.shadowOffset = Constants.shadowOffset
                button.layer.shadowOpacity = Constants.shadowOpacity
                button.layer.shadowRadius = Constants.shadowRadius
                button.addTarget(self, action: #selector(cardTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
                cardButtons.append(button)
            }
        }
        
        setInteractionBlocked(true)
        
        if revealAll {
            for (index, card) in cards.enumerated() {
                let button = cardButtons[index]
                let config = UIImage.SymbolConfiguration(pointSize: Constants.buttonSymbolSize)
                button.setImage(UIImage(systemName: card.icon, withConfiguration: config), for: .normal)
                button.tintColor = .black
            }
        }
    }
    
    func hideCards() {
        for button in cardButtons {
            button.setImage(nil, for: .normal)
        }
        setInteractionBlocked(false)
    }
    
    func revealCard(_ card: CardEntity, at index: Int) {
        guard index < cardButtons.count else { return }
        let button = cardButtons[index]
        let config = UIImage.SymbolConfiguration(pointSize: Constants.buttonSymbolSize)
        button.setImage(UIImage(systemName: card.icon, withConfiguration: config), for: .normal)
        button.tintColor = .black
        
        if card.isMatching {
            button.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            button.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    func showRoundResult(correct: Bool, cards: [CardEntity]) {
        setInteractionBlocked(true)
        
        for (index, card) in cards.enumerated() {
            let button = cardButtons[index]
            let config = UIImage.SymbolConfiguration(pointSize: Constants.buttonSymbolSize)
            button.setImage(UIImage(systemName: card.icon, withConfiguration: config), for: .normal)
            button.tintColor = .black
            
            if card.isMatching {
                button.layer.borderColor = UIColor.systemGreen.cgColor
            } else {
                button.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func setInteractionBlocked(_ blocked: Bool) {
        isInteractionBlocked = blocked
        gridView.isUserInteractionEnabled = !blocked
    }
    
    func showGameOver(score: Int) {
        gameOverView = GameOverView()
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.setResultText("Game Over\nScore: \(score)")
        gameOverView.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter?.startGame()
        }
        view.addSubview(gameOverView)
        gameOverView.pin(to: view)
    }
    
    // MARK: - Actions
    
    @objc private func cardTapped(_ sender: UIButton) {
        guard !isInteractionBlocked else { return }
        presenter?.userTappedCard(at: sender.tag)
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
