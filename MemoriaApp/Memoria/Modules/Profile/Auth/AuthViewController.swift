import UIKit

/// ViewController responsible for managing the authentication UI, including login and registration.
class AuthViewController: UIViewController, AuthViewProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let verticalSpacing: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
        static let textFieldHeight: CGFloat = 45
        static let submitButtonHeight: CGFloat = 50
        static let activityIndicatorTopSpacing: CGFloat = 20
        static let textFieldSpacing: CGFloat = 15
        static let modeSegmentedControlTopSpacing: CGFloat = 20
        static let modeSegmentedControlWidth: CGFloat = 200
    }
    
    // MARK: - VIPER Reference
    
    var presenter: AuthPresenterProtocol?
    
    // MARK: - UI Elements
    
    private let modeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Login", "Register"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let submitButton = AnimatedButton(title: "Submit")
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        modeSegmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        updateUIForMode()
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    
    private func setupLayout() {
        view.addSubview(modeSegmentedControl)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)
        view.addSubview(activityIndicator)
        
        modeSegmentedControl.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.modeSegmentedControlTopSpacing)
        modeSegmentedControl.pinCenterX(to: view)
        modeSegmentedControl.setWidth(Constants.modeSegmentedControlWidth)
        
        nameTextField.pinTop(to: modeSegmentedControl.bottomAnchor, Constants.verticalSpacing)
        nameTextField.pinLeft(to: view.leadingAnchor, Constants.horizontalPadding)
        nameTextField.pinRight(to: view.trailingAnchor, Constants.horizontalPadding)
        nameTextField.setHeight(Constants.textFieldHeight)
        
        emailTextField.pinTop(to: nameTextField.bottomAnchor, Constants.textFieldSpacing)
        emailTextField.pinLeft(to: view.leadingAnchor, Constants.horizontalPadding)
        emailTextField.pinRight(to: view.trailingAnchor, Constants.horizontalPadding)
        emailTextField.setHeight(Constants.textFieldHeight)
        
        passwordTextField.pinTop(to: emailTextField.bottomAnchor, Constants.textFieldSpacing)
        passwordTextField.pinLeft(to: view.leadingAnchor, Constants.horizontalPadding)
        passwordTextField.pinRight(to: view.trailingAnchor, Constants.horizontalPadding)
        passwordTextField.setHeight(Constants.textFieldHeight)
        
        submitButton.pinTop(to: passwordTextField.bottomAnchor, Constants.verticalSpacing)
        submitButton.pinLeft(to: view.leadingAnchor, Constants.horizontalPadding)
        submitButton.pinRight(to: view.trailingAnchor, Constants.horizontalPadding)
        submitButton.setHeight(Constants.submitButtonHeight)
        
        activityIndicator.pinCenterX(to: view)
        activityIndicator.pinTop(to: submitButton.bottomAnchor, Constants.activityIndicatorTopSpacing)
    }
    
    // MARK: - Actions
    
    @objc private func modeChanged() {
        updateUIForMode()
    }
    
    private func updateUIForMode() {
        // In Login mode, hide the Name field
        let mode: AuthMode = modeSegmentedControl.selectedSegmentIndex == 0 ? .login : .register
        nameTextField.isHidden = (mode == .login)
    }
    
    @objc private func submitTapped() {
        let mode: AuthMode = modeSegmentedControl.selectedSegmentIndex == 0 ? .login : .register
        let name = mode == .register ? nameTextField.text : nil
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError(message: "Please fill in all required fields.")
            return
        }
        presenter?.didTapAuthenticate(mode: mode, name: name, email: email, password: password)
    }
    
    // MARK: - AuthViewProtocol Methods
    
    func showLoading() {
        activityIndicator.startAnimating()
        submitButton.isEnabled = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        submitButton.isEnabled = true
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        present(alert, animated: true)
    }
}
