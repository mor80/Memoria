import UIKit

class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    // MARK: - VIPER References
    
    /// Reference to the presenter of the Profile module.
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - State
    
    /// A flag to track if the name editing mode is active.
    private var isInEditingMode = false
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Profile")
    
    /// Container for the avatar image with shadow effect.
    private let avatarContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Round corners and shadow for the container
        view.layer.cornerRadius = 90
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6
        
        // Prevent shadow clipping
        view.clipsToBounds = false
        view.layer.masksToBounds = false
        
        return view
    }()
    
    /// Avatar image view to display the user's avatar.
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // Ensuring no clipping inside the imageView
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 90  // To make it round with size 180x180
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.text = "User Name"
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let editNameButton: UIButton = {
        let button = UIButton(type: .system)
        let pencilImage = UIImage(systemName: "pencil",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        button.setImage(pencilImage, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var sectionsStackView: UIStackView?
    
    private let authButton: AuthButton = {
        let button = AuthButton()
        button.configure(title: "Login", isLogin: true)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTitle()
        setupLayout()
        setupActions()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    private func setupLayout() {
        // Add avatar container
        view.addSubview(avatarContainerView)
        avatarContainerView.pinTop(to: titleLabel.bottomAnchor, 16)
        avatarContainerView.pinCenterX(to: view)
        avatarContainerView.setWidth(180)
        avatarContainerView.setHeight(180)
        
        // Place the image view inside the avatar container
        avatarContainerView.addSubview(avatarImageView)
        avatarImageView.pin(to: avatarContainerView) // Fill the container
        
        view.addSubview(nameTextField)
        view.addSubview(editNameButton)
        view.addSubview(levelLabel)
        
        nameTextField.pinTop(to: avatarContainerView.bottomAnchor, 16)
        nameTextField.pinCenterX(to: view)
        
        editNameButton.pinLeft(to: nameTextField.trailingAnchor, 8)
        editNameButton.pinCenterY(to: nameTextField)
        
        levelLabel.pinTop(to: nameTextField.bottomAnchor, 12)
        levelLabel.pinCenterX(to: view)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        
        editNameButton.addTarget(self, action: #selector(editNameButtonTapped), for: .touchUpInside)
        nameTextField.delegate = self
    }
    
    // MARK: - ProfileViewProtocol
    
    /// Updates the UI with the user's information and avatar.
    func updateUserInfo(with user: UserDTO, avatar: UIImage?) {
        nameTextField.text = user.name
        let rawLevel = user.experience / 1000
        let level = min(rawLevel, 100)
        levelLabel.text = "Level: \(level)"
        
        if let image = avatar {
            avatarImageView.image = image
        } else {
            avatarImageView.image = UIImage(named: "avatar_placeholder") ?? UIImage(systemName: "person.circle")
        }
        
        if user.id.isEmpty {
            // Not authorized -> "Login"
            authButton.configure(title: "Login", isLogin: true)
        } else {
            // Authorized -> "Logout"
            authButton.configure(title: "Logout", isLogin: false)
        }
    }
    
    /// Displays the profile sections.
    func displaySections(_ sections: [ProfileSection], _ icons: [UIImage?]) {
        sectionsStackView?.removeFromSuperview()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.pinTop(to: levelLabel.bottomAnchor, 16)
        stackView.pinLeft(to: view.leadingAnchor, 20)
        stackView.pinCenterX(to: view)
        
        for (index, section) in sections.enumerated() {
            let button = SimpleSectionButton()
            let icon = icons[index]
            button.configure(title: section.rawValue, icon: icon)
            button.tag = index
            button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            button.setHeight(60)
        }
        
        sectionsStackView = stackView
        
        view.addSubview(authButton)
        authButton.pinTop(to: stackView.bottomAnchor, 16)
        authButton.pinLeft(to: view.leadingAnchor, 20)
        authButton.pinCenterX(to: view)
        authButton.setHeight(60)
        
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad() // Refresh the profile every time the screen appears
    }
    
    // MARK: - Actions
    
    @objc private func avatarTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func editNameButtonTapped() {
        if !isInEditingMode {
            isInEditingMode = true
            nameTextField.isUserInteractionEnabled = true
            nameTextField.becomeFirstResponder()
            let checkmarkImage = UIImage(systemName: "checkmark",
                                         withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            editNameButton.setImage(checkmarkImage, for: .normal)
        } else {
            endEditingName()
        }
    }
    
    private func endEditingName() {
        nameTextField.resignFirstResponder()
        nameTextField.isUserInteractionEnabled = false
        isInEditingMode = false
        
        if let newName = nameTextField.text, !newName.isEmpty {
            presenter?.updateUserName(newName)
        }
        
        let pencilImage = UIImage(systemName: "pencil",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        editNameButton.setImage(pencilImage, for: .normal)
    }
    
    @objc private func sectionButtonTapped(_ sender: UIControl) {
        let index = sender.tag
        let allSections = ProfileSection.allCases
        
        guard index >= 0, index < allSections.count else { return }
        
        let section = allSections[index]
        presenter?.didSelectSection(section)
    }
    
    @objc private func authButtonTapped() {
        let isLogin = authButton.isLoginButton()
        presenter?.didTapAuthButton(isLogin: isLogin)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        avatarImageView.image = selectedImage
        presenter?.updateUserAvatar(selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditingName()
        return true
    }
}

extension ProfileViewController: AuthModuleDelegate {
    func authModuleDidAuthenticate() {
        presenter?.viewDidLoad() // Refresh the profile after successful authentication
    }
}
