import UIKit

final class NumberMemoryViewController: UIViewController, NumberMemoryViewProtocol, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var presenter: NumberMemoryPresenterProtocol!
    
    // MARK: - UI Elements
    
    private let titleLabel = CommonViews.makeTitleLabel(text: "Number Memory")
    private let scoreLabel = CommonViews.makeScoreLabel(text: "Score: 0")
    private let backButton = BackButton()
    private var startOverlay: GameStartOverlay!
    private var gameOverView: GameOverView!
    private let submitButton = AnimatedButton(title: "Submit")
    
    // Стилизованный label для показа числа
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кастомное текстовое поле – черная линия, шрифт 32, с Return
    private let textField: BlackLineTextField = {
        let tf = BlackLineTextField()
        tf.placeholder = "Enter Number"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupTitle()
        setupBackButton()
        setupLayout()
        
        // Устанавливаем делегат для обработки Return
        textField.delegate = self
        
        submitButton.addTarget(self, action: #selector(checkNumber), for: .touchUpInside)
        
        setupStartOverlay()
    }
    
    // MARK: - Setup UI
    
    private func setupStartOverlay() {
        startOverlay = GameStartOverlay()
        startOverlay.translatesAutoresizingMaskIntoConstraints = false
        startOverlay.onStart = { [weak self] in
            self?.hideStartOverlay()
            self?.presenter.startGame()
        }
        view.addSubview(startOverlay)
        startOverlay.pin(to: view)
    }
    
    private func setupLayout() {
        view.addSubview(numberLabel)
        view.addSubview(textField)
        view.addSubview(submitButton)
        view.addSubview(scoreLabel)
        
        numberLabel.pinCenter(to: view)
        numberLabel.setHeight(80)
        numberLabel.setWidth(200)
        
        textField.pinCenter(to: view)
        textField.setWidth(250)
        
        submitButton.pinTop(to: textField.bottomAnchor, 20)
        submitButton.pinCenterX(to: view)
        submitButton.setWidth(150)
        submitButton.setHeight(50)
        
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, 16)
        scoreLabel.pinCenterX(to: view)
                
        // Изначально показываем число, скрываем поле ввода и кнопку
        numberLabel.isHidden = true
        hideInput()
    }
    
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
    
    // MARK: - Private Helpers for Input UI
    
    private func showInput() {
        textField.isHidden = false
        submitButton.isHidden = false
    }
    
    private func hideInput() {
        textField.isHidden = true
        submitButton.isHidden = true
    }
    
    private func hideStartOverlay() {
        startOverlay.removeFromSuperview()
        startOverlay = nil
    }
    
    private func hideGameOverView() {
        gameOverView.removeFromSuperview()
        gameOverView = nil
    }
    
    // MARK: - NumberMemoryViewProtocol
    
    func showNumber(_ number: String) {
        // При показе числа скрываем поле ввода
        numberLabel.text = number
        numberLabel.isHidden = false
        hideInput()
        
        // Вычисляем время отображения: 0.5 + currentLength * 0.2 секунд (используем длину числа как proxy)
        let displayTime = 0.5 + Double(number.count) * 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + displayTime) { [weak self] in
            self?.hideNumber()
            self?.showInput()
        }
    }
    
    func hideNumber() {
        numberLabel.isHidden = true
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func showGameOver() {
        gameOverView = GameOverView()
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.setResultText("Game Over\n\(scoreLabel.text ?? "0")")
        gameOverView.onRestart = { [weak self] in
            self?.hideGameOverView()
            self?.presenter.startGame()
        }
        view.addSubview(gameOverView)
        gameOverView.pin(to: view)
    }
    
    // MARK: - Actions
    
    @objc private func checkNumber() {
        guard let input = textField.text, !input.isEmpty else { return }
        hideInput()
        presenter.checkNumber(input)
        textField.text = ""
        // Скрываем клавиатуру
        textField.resignFirstResponder()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkNumber()
        return true
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
