import UIKit

class StatisticsViewController: UIViewController, StatisticsViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - VIPER References
    
    /// Reference to the presenter of the Statistics module.
    var presenter: StatisticsPresenterProtocol!
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Statistics")
    private let backButton = BackButton()
    
    private let chartIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chart.bar.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .bold))?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        return stack
    }()
    
    private var displayItems: [StatDisplayItem] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupTitle()
        setupBackButton()
        setupChartIcon()
        setupScrollView()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the title label on the view.
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    /// Sets up the back button and its action.
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.pinLeft(to: view.leadingAnchor, 20)
        backButton.pinCenterY(to: titleLabel)
    }
    
    /// Sets up the chart icon view.
    private func setupChartIcon() {
        view.addSubview(chartIconView)
        chartIconView.pinTop(to: titleLabel.bottomAnchor, 12)
        chartIconView.pinCenterX(to: view.centerXAnchor)
        chartIconView.setHeight(150)
        chartIconView.setWidth(200)
    }

    /// Sets up the scroll view and the stack view inside it.
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.pinTop(to: chartIconView.bottomAnchor, 12)
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinBottom(to: view.bottomAnchor, 20)
        
        scrollView.addSubview(stackView)
        stackView.pinTop(to: scrollView.topAnchor, 10)
        stackView.pinLeft(to: scrollView.leadingAnchor, 20)
        stackView.pinRight(to: scrollView.trailingAnchor, 20)
        stackView.pinBottom(to: scrollView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    // MARK: - StatisticsViewProtocol
    
    /// Displays the list of statistics items on the view.
    /// - Parameter stats: A list of `StatDisplayItem` to display.
    func displayStatistics(_ stats: [StatDisplayItem]) {
        displayItems = stats
        // Removes previous items from the stack
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Creates ExpandableStatButton for each item with a height of 60
        for item in stats {
            let statButton = ExpandableStatButton()
            statButton.configure(title: item.gameName,
                                 stats: [("Games played:", item.gamesPlayed),
                                         ("Best score:", item.bestScore)])
            statButton.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(statButton)
        }
    }
    
    /// Displays an error message on the view.
    /// - Parameter error: The error to display.
    func displayError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    /// Action triggered when the back button is tapped.
    @objc private func backButtonTapped() {
        if let router = (presenter as? StatisticsPresenter)?.router {
            router.navigateBack()
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    /// Enables interactive pop gesture recognition.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
