import UIKit

protocol StroopGameViewProtocol: AnyObject {
    /// Показать слово (текст) и цвет текста
    func displayWord(text: String, textColor: UIColor)

    /// Обновить количество ошибок (напр., "Ошибки: 1/3")
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
        // Чтобы белый текст оставался виден на светлом фоне, добавим тень
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

    // Кнопки (шесть штук) без названий, только цвет
    private lazy var redButton: UIButton    = createColorButton(color: .red)
    private lazy var greenButton: UIButton  = createColorButton(color: .green)
    private lazy var blueButton: UIButton   = createColorButton(color: .blue)
    private lazy var blackButton: UIButton  = createColorButton(color: .black)
    private lazy var whiteButton: UIButton  = createColorButton(color: .white)
    private lazy var yellowButton: UIButton = createColorButton(color: .yellow)

    // Для размещения в сетке 2×3 используем UIStackView как «вертикальный контейнер»,
    // внутри которого 3 горизонтальных стека (по 2 кнопки в каждом).
    private lazy var rowStack1: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [redButton, greenButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 16
        stack.distribution = .fillEqually // чтобы кнопки делили пространство поровну
        return stack
    }()

    private lazy var rowStack2: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [blueButton, blackButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var rowStack3: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [whiteButton, yellowButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var gridStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rowStack1, rowStack2, rowStack3])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLayout()
        presenter.startGame()
    }

    // MARK: - Layout
    private func setupLayout() {
        // Добавляем слово, метку ошибок и общий контейнер с кнопками
        [wordLabel, mistakesLabel, gridStack].forEach {
            view.addSubview($0)
        }

        // Располагаем заголовки (слово, ошибки)
        wordLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 40)
        wordLabel.pinCenterX(to: view)

        mistakesLabel.pinTop(to: wordLabel.bottomAnchor, 20)
        mistakesLabel.pinCenterX(to: view)

        // Сетка (gridStack) из трёх горизонтальных строк по две кнопки
        gridStack.pinTop(to: mistakesLabel.bottomAnchor, 40)
        gridStack.pinCenterX(to: view)

        // Устанавливаем явные размеры для стека,
        // чтобы кнопки были крупнее. Допустим, 320 по ширине, 300 по высоте.
        gridStack.setWidth(320)
        gridStack.setHeight(300)
    }

    /// Создаём кнопку требуемого цвета, без текста.
    private func createColorButton(color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        // Если фон белый, сделаем границу/рамку, чтобы было видно кнопку
        if color == .white {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
        }
        button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
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
            message: "Вы допустили \(mistakes) ошибок из \(3).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: { _ in
            self.presenter.startGame()
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
}
