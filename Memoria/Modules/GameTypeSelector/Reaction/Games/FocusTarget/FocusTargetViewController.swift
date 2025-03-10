import UIKit

// Предполагаем, что в этом же модуле у нас уже описаны протоколы:
// FocusTargetViewProtocol, FocusTargetPresenterProtocol и т.д.

class FocusTargetViewController: UIViewController, FocusTargetViewProtocol {
    var presenter: FocusTargetPresenterProtocol?

    // MARK: - UI
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Счёт: 0"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        return label
    }()

    private let mistakesLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибки: 0/5"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .right
        return label
    }()

    // Отдельный контейнер, куда будет выводиться фигурка (кнопка)
    private let gameAreaView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray6
        return v
    }()

    // Кнопка (или вью) для текущей фигуры (круг/квадрат, разные цвета)
    private var shapeButton: UIButton = UIButton(type: .system)

    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Focus Target"
        view.backgroundColor = .white

        setupLayout()
        presenter?.startGame()
    }

    // MARK: - Layout через методы pin...
    private func setupLayout() {
        // 1. Создаём горизонтальный UIStackView для scoreLabel и mistakesLabel
        let topStack = UIStackView(arrangedSubviews: [scoreLabel, mistakesLabel])
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.distribution = .fillEqually
        topStack.spacing = 8

        // 2. Добавляем subviews
        view.addSubview(topStack)
        view.addSubview(gameAreaView)

        // 3. Применяем констрейнты через библиотеку pin
        // topStack – 16 от верхнего safeArea, 16 слева и справа, высота 40
        topStack.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        topStack.pinLeft(to: view, 16)
        topStack.pinRight(to: view, 16)
        topStack.setHeight(40)

        // 4. gameAreaView размещаем под стеком, на всю оставшуюся часть экрана
        // 16 отступ сверху, 0 слева/справа, 0 до нижней границы safeArea
        gameAreaView.pinTop(to: topStack.bottomAnchor, 16)
        gameAreaView.pinLeft(to: view)
        gameAreaView.pinRight(to: view)
        gameAreaView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)

        // shapeButton будем добавлять в gameAreaView динамически при displayShape
    }

    // MARK: - FocusTargetViewProtocol
    func displayShape(_ shape: FocusTargetShape) {
        // Сначала уберём предыдущую фигуру (если есть)
        removeShape()

        // Создаём новую кнопку
        let button = UIButton(type: .system)

        // Переводим frame, с учётом что Interactor выдал координаты относительно (0,0) gameAreaView
        button.frame = shape.frame
        button.backgroundColor = shape.color

        if shape.shapeType == .circle {
            button.layer.cornerRadius = shape.frame.height / 2
        } else {
            button.layer.cornerRadius = 0
        }
        // Для белого цвета делаем обводку, иначе будет незаметно на белом фоне
        if shape.color == .white {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
        }

        button.addTarget(self, action: #selector(shapeTapped), for: .touchUpInside)

        // Добавляем кнопку в gameAreaView
        gameAreaView.addSubview(button)
        shapeButton = button
    }

    func removeShape() {
        shapeButton.removeFromSuperview()
    }

    func updateScore(_ score: Int) {
        scoreLabel.text = "Счёт: \(score)"
    }

    func updateMistakes(_ mistakes: Int, maxMistakes: Int) {
        mistakesLabel.text = "Ошибки: \(mistakes)/\(maxMistakes)"
    }

    func showGameOver(score: Int) {
        let alert = UIAlertController(
            title: "Игра окончена",
            message: "Ваш счёт: \(score)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Сыграть ещё", style: .default, handler: { _ in
            self.presenter?.startGame()
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Actions
    @objc private func shapeTapped() {
        presenter?.userTappedShape()
    }
}
