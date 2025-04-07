import UIKit

/// ViewController for displaying the list of daily tasks.
class DailyTasksViewController: UIViewController, DailyTasksViewProtocol {
    
    // MARK: - VIPER Reference
    
    var presenter: DailyTasksPresenterProtocol!
    
    // MARK: - Constants
    
    private enum Constants {
        static let titleTopPadding: CGFloat = 0
        static let dateTopPadding: CGFloat = 16
        static let stackHorizontalPadding: CGFloat = 20
        static let taskViewHeight: CGFloat = 110
    }
    
    // MARK: - UI Components
    
    /// Title label for the screen.
    private let titleLabel: UILabel = CommonViews.makeTitleLabel(text: "Daily Tasks")
    
    /// Label displaying the current date.
    private lazy var dateLabel: UILabel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        let dateText = formatter.string(from: Date())
        return CommonViews.makeScoreLabel(text: dateText)
    }()
    
    /// Stack view that holds all task views.
    private var stackView: UIStackView = CommonViews.makeVerticalStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle()
        setupDate()
        setupStackView()
        presenter.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSignificantTimeChange),
            name: UIApplication.significantTimeChangeNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    /// Configures the title label layout.
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopPadding)
        titleLabel.pinCenterX(to: view)
    }
    
    /// Configures the date label layout.
    private func setupDate() {
        view.addSubview(dateLabel)
        dateLabel.pinTop(to: titleLabel.bottomAnchor, Constants.dateTopPadding)
        dateLabel.pinCenterX(to: view)
    }
    
    /// Configures the stack view layout.
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.pinLeft(to: view.leadingAnchor, Constants.stackHorizontalPadding)
        stackView.pinRight(to: view.trailingAnchor, Constants.stackHorizontalPadding)
        stackView.pinCenter(to: view)
    }
    
    // MARK: - DailyTasksViewProtocol
    
    /// Displays a list of daily tasks as view models.
    /// - Parameter tasks: Array of `DailyTaskViewModel` objects to display.
    func displayDailyTasks(_ tasks: [DailyTaskViewModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for viewModel in tasks {
            let taskView = DailyTaskItemView()
            taskView.configure(with: viewModel)
            taskView.translatesAutoresizingMaskIntoConstraints = false
            taskView.heightAnchor.constraint(equalToConstant: Constants.taskViewHeight).isActive = true
            stackView.addArrangedSubview(taskView)
        }
    }
    
    // MARK: - Time Change Handling
    
    /// Updates the date label when system time changes significantly (e.g., midnight).
    @objc private func handleSignificantTimeChange() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        dateLabel.text = formatter.string(from: Date())
    }
}
