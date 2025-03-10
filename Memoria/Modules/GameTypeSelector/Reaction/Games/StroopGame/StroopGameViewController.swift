import UIKit

protocol StroopGameViewProtocol: AnyObject {
    /// Показать слово (текст) и цвет текста
    func displayWord(text: String, textColor: UIColor)
    
    /// Обновить количество ошибок (например, "Ошибки: 1/3")
    func updateMistakes(_ mistakes: Int, maxMistakes: Int)
    
    /// Показать сообщение об окончании игры
    func showGameOver(mistakes: Int)
}

class StroopGameViewController: UIViewController, StroopGameViewProtocol {
    var presenter: StroopGamePresenterProtocol!

    // MARK: - UI
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавим тень на случай белого текста
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 0.8
        
        return label
    }()
    
    private let mistakesLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибки: 0/3"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопки (шесть штук) без названия, только фон
    private lazy var redButton: UIButton    = createColorButton(color: .red)
    private lazy var greenButton: UIButton  = createColorButton(color: .green)
    private lazy var blueButton: UIButton   = createColorButton(color: .blue)
    private lazy var blackButton: UIButton  = createColorButton(color: .black)
    private lazy var whiteButton: UIButton  = createColorButton(color: .white)
    private lazy var yellowButton: UIButton = createColorButton(color: .yellow)
    
    // Три горизонтальных стека для «строк» (по две кнопки на каждой)
    private lazy var rowStack1: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [redButton, greenButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var rowStack2: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [blueButton, blackButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var rowStack3: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [whiteButton, yellowButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    // Главный вертикальный стек для трёх "строк"
    private lazy var gridStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [rowStack1, rowStack2, rowStack3]
        )
        stack.axis = .vertical
        // Включаем fillEqually, чтобы каждая «строка» занимала одинаковую высоту.
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        presenter.startGame()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        [wordLabel, mistakesLabel, gridStack].forEach {
            view.addSubview($0)
        }
        
        // Располагаем текст и счётчик ошибок сверху
        wordLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 40)
        wordLabel.pinCenterX(to: view)
        
        mistakesLabel.pinTop(to: wordLabel.bottomAnchor, 20)
        mistakesLabel.pinCenterX(to: view)
        
        // "Растягиваем" stack по всей ширине с небольшими отступами
        // и заполняем всё оставшееся пространство до нижней границы
        gridStack.pinTop(to: mistakesLabel.bottomAnchor, 40)
        gridStack.pinLeft(to: view, 16)
        gridStack.pinRight(to: view, 16)
        gridStack
            .pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16, .lsOE)
        // .lsOE (lessThanOrEqual) — если места мало, стек может уехать в скролл,
        // либо мы можем просто использовать pinBottom(to:..., 16, .equal) если хотим жёсткую фиксацию
        
        // Теперь каждая «строка» заполнит пропорционально оставшуюся высоту,
        // а каждая кнопка внутри строки — половину её ширины.
    }
    
    private func createColorButton(color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        
        if color == .white {
            // Для белой кнопки добавим обводку, иначе её не будет видно на белом фоне
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
        }
        
        button
            .addTarget(
                self,
                action: #selector(colorButtonTapped(_:)),
                for: .touchUpInside
            )
        return button
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        presenter.userSelectedColor(color)
    }
    
    // MARK: - StroopGameViewProtocol
    
    func displayWord(text: String, textColor: UIColor) {
        wordLabel.text = text
        wordLabel.textColor = textColor
    }
    
    func updateMistakes(_ mistakes: Int, maxMistakes: Int) {
        mistakesLabel.text = "Ошибки: \(mistakes)/\(maxMistakes)"
    }
    
    func showGameOver(mistakes: Int) {
        let alert = UIAlertController(
            title: "Игра окончена",
            message: "Вы допустили \(mistakes) ошибок из 3.",
            preferredStyle: .alert
        )
        alert
            .addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: { _ in
                self.presenter.startGame()
            }))
        alert
            .addAction(
                UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
            )
        
        present(alert, animated: true)
    }
}

