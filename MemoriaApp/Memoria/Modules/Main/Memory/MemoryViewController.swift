import UIKit

/// ViewController for displaying the list of memory games.
final class MemoryGamesViewController: UIViewController, GameTypeViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - Constants

    private enum Constants {
        static let backButtonLeftInset: CGFloat = 20
        static let stackViewLeftInset: CGFloat = 20
        static let stackViewButtonHeight: CGFloat = 110
        static let titleTopInset: CGFloat = 0
    }
    
    // MARK: - VIPER
    
    var presenter: GameTypePresenterProtocol!
    
    // MARK: - UI Elements
    
    private let stackView = CommonViews.makeVerticalStackView()
    private let titleLabel = CommonViews.makeTitleLabel(text: "Memory")
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
    
    // MARK: - Setup UI
    
    /// Configures and adds the custom back button.
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeftInset)
        backButton.pinCenterY(to: titleLabel)
    }
    
    /// Configures and adds the title label.
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopInset)
        titleLabel.pinCenterX(to: view)
    }
    
    /// Configures and adds the stack view.
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.pinCenter(to: view)
        stackView.pinLeft(to: view.leadingAnchor, Constants.stackViewLeftInset)
    }
    
    // MARK: - GameTypeViewProtocol
    
    /// Displays game buttons with titles and descriptions.
    /// - Parameters:
    ///   - titles: Array of game titles.
    ///   - descriptions: Array of game descriptions.
    func displayGameButtons(titles: [String], descriptions: [String]) {
        for (index, title) in titles.enumerated() {
            let button = GameButton()
            button.configure(title: title, description: descriptions[index])
            button.tag = index
            button.addTarget(self, action: #selector(gameButtonTapped(_:)), for: .touchUpInside)
            button.setHeight(Constants.stackViewButtonHeight)
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    
    /// Handles game button tap.
    /// - Parameter sender: The tapped GameButton.
    @objc private func gameButtonTapped(_ sender: GameButton) {
        presenter.didSelectGame(at: sender.tag)
    }
    
    /// Handles back button tap to navigate back.
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
