import UIKit

protocol NumberMemoryViewProtocol: AnyObject {
    func showNumber(_ number: String)
    func hideNumber()
    func updateAttempts(remaining: Int)
    func showGameOver()
}

class NumberMemoryViewController: UIViewController, NumberMemoryViewProtocol {
    var presenter: NumberMemoryPresenterProtocol!
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите число"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Проверить", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let attemptsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        presenter.startGame()
    }
    
    private func setupUI() {
        view.addSubview(numberLabel)
        view.addSubview(textField)
        view.addSubview(submitButton)
        view.addSubview(attemptsLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 20),
            textField.widthAnchor.constraint(equalToConstant: 200),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            submitButton.widthAnchor.constraint(equalToConstant: 150),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            attemptsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attemptsLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20)
        ])
        
        submitButton.addTarget(self, action: #selector(checkNumber), for: .touchUpInside)
    }
    
    func showNumber(_ number: String) {
        numberLabel.text = number
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.hideNumber()
        }
    }
    
    func hideNumber() {
        numberLabel.text = "?"
    }
    
    func updateAttempts(remaining: Int) {
        attemptsLabel.text = "Ошибки: \(remaining)/3"
    }
    
    func showGameOver() {
        let alert = UIAlertController(title: "Игра окончена", message: "Вы допустили 3 ошибки!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.presenter.startGame()
        }))
        present(alert, animated: true)
    }
    
    @objc private func checkNumber() {
        guard let input = textField.text, !input.isEmpty else { return }
        presenter.checkNumber(input)
        textField.text = ""
    }
}

