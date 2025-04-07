import UIKit

/// ViewController displaying a list of Focus games.
final class FocusGamesViewController: UIViewController, GameTypeViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - VIPER Reference
    
    var presenter: GameTypePresenterProtocol!
    
    // MARK: - Constants
    
    private enum Constants {
        static let screenTitle: String = "Focus"
        static let buttonHeight: CGFloat = 110
        static let horizontalPadding: CGFloat = 20
        static let titleTopPadding: CGFloat = 0
    }
    
    // MARK: - UI Elements
    
    private let stackView = CommonViews.makeVerticalStackView()
    private let titleLabel = CommonViews.makeTitleLabel(text: Constants.screenTitle)
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
    
    // MARK: - UI Setup
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopPadding)
        titleLabel.pinCenterX(to: view)
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, Constants.horizontalPadding)
        backButton.pinCenterY(to: titleLabel)
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.pinCenter(to: view)
        stackView.pinLeft(to: view.leadingAnchor, Constants.horizontalPadding)
    }
    
    // MARK: - GameTypeViewProtocol
    
    /// Displays a list of game buttons based on titles and descriptions.
    func displayGameButtons(titles: [String], descriptions: [String]) {
        for (index, title) in titles.enumerated() {
            let button = GameButton()
            button.configure(title: title, description: descriptions[index])
            button.tag = index
            button.addTarget(self, action: #selector(gameButtonTapped(_:)), for: .touchUpInside)
            button.setHeight(Constants.buttonHeight)
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    
    @objc private func gameButtonTapped(_ sender: GameButton) {
        presenter.didSelectGame(at: sender.tag)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
