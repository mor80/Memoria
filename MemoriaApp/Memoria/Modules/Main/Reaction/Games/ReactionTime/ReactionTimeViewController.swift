import UIKit

/// ViewController for the Reaction Time game, responsible for displaying the reaction button, score, and handling user interaction.
final class ReactionTimeViewController: UIViewController, ReactionTimeViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - Constants
    
    private enum Constants {
        static let backButtonLeftInset: CGFloat = 20
        static let scoreLabelTopOffset: CGFloat = 16
        static let reactionButtonTopOffset: CGFloat = 106
        static let reactionButtonSideInset: CGFloat = 20
        static let reactionButtonBottomInset: CGFloat = 20
        static let reactionButtonCornerRadius: CGFloat = 30
    }
    
    // MARK: - VIPER
    
    var presenter: ReactionTimePresenterProtocol!
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Reaction Time")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0 ms")
    private let backButton = BackButton()
    
    // Reaction button for the game.
    private let reactionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("START", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        setupReactionButton()
        
        presenter.startGame()
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
    
    /// Configures the layout for the score label.
    private func setupLayout() {
        view.addSubview(scoreLabel)
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, Constants.scoreLabelTopOffset)
        scoreLabel.pinCenterX(to: view)
    }
    
    /// Configures and adds the reaction button with proper constraints and styling.
    private func setupReactionButton() {
        reactionButton.layer.cornerRadius = Constants.reactionButtonCornerRadius
        view.addSubview(reactionButton)
        reactionButton.addTarget(self, action: #selector(reactionButtonTapped), for: .touchUpInside)
        
        reactionButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.reactionButtonTopOffset)
        reactionButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.reactionButtonSideInset)
        reactionButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.reactionButtonSideInset)
        reactionButton.pinBottom(to: view.bottomAnchor, Constants.reactionButtonBottomInset)
    }
    
    // MARK: - ReactionTimeViewProtocol
    
    /// Updates the reaction button's appearance.
    /// - Parameters:
    ///   - backgroundColor: The new background color.
    ///   - title: The new title text.
    func updateReactionButton(backgroundColor: UIColor, title: String) {
        reactionButton.backgroundColor = backgroundColor
        reactionButton.setTitle(title, for: .normal)
    }
    
    /// Updates the score display.
    /// - Parameter score: The new score string.
    func updateScore(_ score: String) {
        scoreLabel.text = score
    }
    
    /// Resets the reaction button to its initial state.
    func resetReactionButton() {
        updateReactionButton(backgroundColor: .systemBlue, title: "START")
    }
    
    /// Enables or disables the reaction button.
    /// - Parameter enabled: `true` to enable, `false` to disable.
    func setReactionButtonEnabled(_ enabled: Bool) {
        reactionButton.isUserInteractionEnabled = enabled
    }
    
    // MARK: - Actions
    
    /// Handles the reaction button tap.
    @objc private func reactionButtonTapped() {
        presenter.reactionButtonTapped()
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
