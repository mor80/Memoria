import UIKit

/// ViewController responsible for displaying the achievements and managing user interactions.
class AchievementsViewController: UIViewController, AchievementsViewProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - VIPER Reference
    
    var presenter: AchievementsPresenterProtocol!
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Achievements")
    private let backButton = BackButton()
    
    private var collectionView: UICollectionView!
    private var achievementDisplayItems: [AchievementDisplayItem] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupTitle()
        setupBackButton()
        setupCollectionView()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup Methods
    
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 20
        let interItemSpacing: CGFloat = 10
        let totalPadding = padding * 2 + interItemSpacing
        let itemWidth = (view.frame.width - totalPadding) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 150)
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: padding, bottom: 10, right: padding)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AchievementCell.self, forCellWithReuseIdentifier: "AchievementCell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.pinTop(to: titleLabel.bottomAnchor, 16)
        collectionView.pinLeft(to: view.leadingAnchor)
        collectionView.pinRight(to: view.trailingAnchor)
        collectionView.pinBottom(to: view.bottomAnchor)
    }
    
    // MARK: - AchievementsViewProtocol Methods
    
    func displayAchievements(_ achievements: [AchievementDisplayItem]) {
        self.achievementDisplayItems = achievements
        collectionView.reloadData()
    }
    
    func displayError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        if let router = (presenter as? AchievementsPresenter)?.router {
            router.navigateBack()
        }
    }
}

extension AchievementsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementDisplayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: indexPath) as? AchievementCell else {
            return UICollectionViewCell()
        }
        let item = achievementDisplayItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}
