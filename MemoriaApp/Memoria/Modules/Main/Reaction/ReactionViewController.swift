import UIKit

/// ViewController for displaying reaction games.
final class ReactionGamesViewController: UIViewController, GameTypeViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - Constants
    
    private enum Constants {
        static let margin: CGFloat = 20
        static let gameButtonHeight: CGFloat = 110
    }
    
    // MARK: - VIPER Reference
    
    var presenter: GameTypePresenterProtocol!
    
    // MARK: - UI Elements
    
    private let stackView = CommonViews.makeVerticalStackView()
    private let titleLabel = CommonViews.makeTitleLabel(text: "Reaction")
    private let backButton = BackButton()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupTitle()
        setupStackView()
        setupBackButton()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup Methods

    /// Configures and adds the custom back button.
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, Constants.margin)
        backButton.pinCenterY(to: titleLabel)
    }
    
    /// Configures and adds the title label.
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    /// Configures and adds the vertical stack view.
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.pinCenter(to: view)
        stackView.pinLeft(to: view.leadingAnchor, Constants.margin)
    }
    
    // MARK: - GameTypeViewProtocol Methods

    /// Displays game buttons with titles and descriptions.
    /// - Parameters:
    ///   - titles: An array of game titles.
    ///   - descriptions: An array of game descriptions.
    func displayGameButtons(titles: [String], descriptions: [String]) {
        for (index, title) in titles.enumerated() {
            let button = GameButton()
            button.configure(title: title, description: descriptions[index])
            button.tag = index
            
            button.addTarget(self, action: #selector(gameButtonTapped(_:)), for: .touchUpInside)
            button.setHeight(Constants.gameButtonHeight)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions

    /// Handles the tap action on a game button.
    /// - Parameter sender: The tapped game button.
    @objc private func gameButtonTapped(_ sender: GameButton) {
        presenter.didSelectGame(at: sender.tag)
    }
    
    /// Handles the tap action on the back button.
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate

    /// Allows the interactive pop gesture to begin.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
