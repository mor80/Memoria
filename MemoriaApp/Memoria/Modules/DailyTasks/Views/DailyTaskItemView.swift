import UIKit

/// A reusable view that represents a single daily task with progress and completion indicator.
final class DailyTaskItemView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 30
        static let borderWidth: CGFloat = 4
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 12
        
        static let checkmarkSize: CGFloat = 40
        static let descriptionTrailingOffset: CGFloat = 65
        
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }
    
    // MARK: - Subviews
    
    /// A label displaying the task description.
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    /// A label displaying the task progress in the format n/m.
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// A checkmark image shown when the task is completed.
    private let checkmarkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGreen
        iv.image = UIImage(systemName: "checkmark.circle.fill")
        iv.isHidden = true
        return iv
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    /// Sets up the view’s appearance and layout.
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.systemBlue.cgColor
        
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.masksToBounds = false
        
        addSubview(descriptionLabel)
        addSubview(progressLabel)
        addSubview(checkmarkImageView)
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressLabel.setContentHuggingPriority(.required, for: .horizontal)
        progressLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        descriptionLabel.pinLeft(to: leadingAnchor, Constants.horizontalPadding)
        descriptionLabel.pinCenterY(to: centerYAnchor)
        descriptionLabel.pinRight(to: trailingAnchor, Constants.descriptionTrailingOffset)
        
        progressLabel.pinRight(to: trailingAnchor, Constants.horizontalPadding)
        progressLabel.pinCenterY(to: centerYAnchor)
        
        checkmarkImageView.pinRight(to: trailingAnchor, Constants.horizontalPadding)
        checkmarkImageView.pinCenterY(to: centerYAnchor)
        checkmarkImageView.setWidth(Constants.checkmarkSize)
        checkmarkImageView.setHeight(Constants.checkmarkSize)
    }
    
    // MARK: - Configuration
    
    /// Configures the view with a `DailyTaskViewModel`.
    /// Displays a checkmark if completed, otherwise shows current progress.
    /// - Parameter viewModel: The model representing task data.
    func configure(with viewModel: DailyTaskViewModel) {
        descriptionLabel.text = viewModel.description
        
        if viewModel.isCompleted {
            progressLabel.isHidden = true
            checkmarkImageView.isHidden = false
            layer.borderColor = UIColor.systemGreen.cgColor
            descriptionLabel.textColor = UIColor.systemGreen
        } else {
            progressLabel.isHidden = false
            checkmarkImageView.isHidden = true
            progressLabel.text = "\(viewModel.currentValue)/\(viewModel.targetValue)"
            layer.borderColor = UIColor.systemBlue.cgColor
            descriptionLabel.textColor = UIColor.black
            progressLabel.textColor = UIColor.black
        }
    }
}
