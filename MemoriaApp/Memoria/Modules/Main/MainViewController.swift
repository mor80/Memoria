import UIKit

/// ViewController for the Main module, displaying the game types and handling user interactions.
class MainViewController: UIViewController, MainViewProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let buttonHeight: CGFloat = 140
        static let stackViewSpacing: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
    }
    
    // MARK: - VIPER Reference
    
    var presenter: MainPresenterProtocol!
    
    // MARK: - UI Elements
    
    private var buttons: [SectionButton] = []
    private let titleLabel = CommonViews.makeTitleLabel(text: "Memoria")
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.stackViewSpacing
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
        setupTitle()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup Methods
    
    /// Configures and adds the title label.
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    /// Configures and adds the stack view to hold the game type buttons.
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.pinCenter(to: view)
        stackView.pinLeft(to: view.leadingAnchor, Constants.horizontalPadding)
    }
    
    // MARK: - MainViewProtocol Methods
    
    /// Displays the game type buttons with titles, descriptions, and icons.
    /// - Parameters:
    ///   - titles: List of game type titles.
    ///   - descriptions: List of descriptions for each game type.
    ///   - icons: List of icons for each game type.
    func displayButtons(titles: [String], descriptions: [String], icons: [UIImage?]) {
        for (index, title) in titles.enumerated() {
            let button = SectionButton()
            button.configure(
                title: title,
                description: descriptions[index],
                icon: icons[index]
            )
            button.tag = index
            
            // Subscribe to button tap action
            button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            
            // Set the button height
            button.setHeight(Constants.buttonHeight)
            
            // Add button to the stack view
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }

    // MARK: - Actions
    
    /// Handles the button tap action for selecting a game type.
    @objc private func sectionButtonTapped(_ sender: SectionButton) {
        presenter.didSelectButton(at: sender.tag)
    }
}
