import UIKit

class AchievementCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 30
        
        // Shadow properties for the cell
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }
    
    // MARK: - UI Elements
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    // StackView to hold the labels
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, progressLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Cell background and corner radius
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerRadius
        
        // Border and shadow setup
        contentView.layer.borderWidth = 4
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.clipsToBounds = true
        
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.masksToBounds = false
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        contentView.addSubview(textStackView)
        
        textStackView.pinCenter(to: contentView)
        textStackView.pinLeft(to: contentView.leadingAnchor, 6)
        textStackView.pinRight(to: contentView.trailingAnchor, 6)
    }
    
    // MARK: - Public Method to Configure Cell
    
    /// Configures the cell with achievement data.
    /// - Parameter item: The achievement data to display in the cell.
    func configure(with item: AchievementDisplayItem) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        progressLabel.text = item.progress
        descriptionLabel.textColor = item.color
        progressLabel.textColor = item.color
        
        // Change the border color based on the achievement status
        contentView.layer.borderColor = item.color.cgColor
    }
}
