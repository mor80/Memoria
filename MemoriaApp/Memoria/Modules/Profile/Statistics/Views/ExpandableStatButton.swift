import UIKit

final class ExpandableStatButton: UIControl {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 30
        static let horizontalPadding: CGFloat = 20
        static let headerHeight: CGFloat = 40
        static let arrowSize: CGFloat = 24
        static let animationDuration: TimeInterval = 0.25
        static let arrowExpandedRotation: CGFloat = .pi / 2  // 90° rotation
        
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
    }
    
    // MARK: - Subviews for the button header
    
    private let headerView: UIView = {
        let view = UIView()
        view.setHeight(Constants.headerHeight)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.isUserInteractionEnabled = false
        return label
    }()
    
    // MARK: - Subviews for the expandable detail section
    
    private let detailContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.isHidden = true
        stack.isUserInteractionEnabled = false
        return stack
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false
        return stack
    }()
    
    // MARK: - Properties
    
    private var isExpanded = false
    private var stats: [(name: String, value: String)] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - View Setup
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        clipsToBounds = false
        layer.masksToBounds = false
        
        addSubview(containerStackView)
        containerStackView.pinTop(to: topAnchor)
        containerStackView.pinRight(to: trailingAnchor)
        containerStackView.pinLeft(to: leadingAnchor)
        containerStackView.pinBottom(to: bottomAnchor, 20)

        containerStackView.addArrangedSubview(headerView)
        containerStackView.addArrangedSubview(detailContainer)
        
        headerView.addSubview(arrowImageView)
        headerView.addSubview(titleLabel)
        
        arrowImageView.pinLeft(to: headerView.leadingAnchor, Constants.horizontalPadding)
        arrowImageView.pinTop(to: headerView.topAnchor, 17)
        arrowImageView.setWidth(Constants.arrowSize)
        arrowImageView.setHeight(Constants.arrowSize)
        
        titleLabel.pinLeft(to: arrowImageView.trailingAnchor, Constants.horizontalPadding)
        titleLabel.pinTop(to: headerView.topAnchor, 17)
        titleLabel.pinRight(to: headerView.trailingAnchor, Constants.horizontalPadding)
        
        addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
    }
    
    // MARK: - Button Configuration
    
    /// Configures the button with a title and a list of stats
    /// - Parameters:
    ///   - title: The title of the button (game name)
    ///   - stats: An array of tuples with the stat name and value
    func configure(title: String, stats: [(name: String, value: String)]) {
        titleLabel.text = title
        self.stats = stats
        
        detailContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for stat in stats {
            let row = createStatRow(name: stat.name, value: stat.value)
            detailContainer.addArrangedSubview(row)
        }
    }
    
    /// Creates a stat row with a label for the name and the value
    private func createStatRow(name: String, value: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = .systemBlue
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.isUserInteractionEnabled = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .systemBlue
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.isUserInteractionEnabled = false
        
        container.addSubview(nameLabel)
        container.addSubview(valueLabel)
        
        nameLabel.pinLeft(to: container.leadingAnchor, 20)
        nameLabel.pinTop(to: container.topAnchor)
        nameLabel.pinBottom(to: container.bottomAnchor)
        
        valueLabel.pinRight(to: container.trailingAnchor, 20)
        valueLabel.pinTop(to: container.topAnchor)
        valueLabel.pinBottom(to: container.bottomAnchor)
        
        return container
    }
    
    // MARK: - Actions
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        if isExpanded {
            detailContainer.isHidden = false
            detailContainer.alpha = 0
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: Constants.arrowExpandedRotation)
                self.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: Constants.animationDuration, animations: {
                    self.detailContainer.alpha = 1
                })
            })
        } else {
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.detailContainer.alpha = 0
            }, completion: { _ in
                UIView.animate(withDuration: Constants.animationDuration, animations: {
                    self.arrowImageView.transform = .identity
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.detailContainer.isHidden = true
                })
            })
        }
    }
}
