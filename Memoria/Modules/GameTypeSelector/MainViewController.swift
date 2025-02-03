import UIKit

protocol MainViewProtocol: AnyObject {
    func displayButtons(titles: [String])
}

class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol!
    
    private var buttons: [UIButton] = []
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Memoria"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
        setupTitle()
        presenter.viewDidLoad()
    }
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinCenterX(to: view)
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        
        stackView.pinCenter(to: view)
        stackView.pinLeft(to: view.leadingAnchor, 20)
    }
    
    func displayButtons(titles: [String]) {
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.tag = index
            
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonTouchUpOutside(_:)), for: .touchUpOutside)
            
            button.layer.cornerRadius = 30
            
            view.addSubview(button)
            buttons.append(button)
            
            button.setHeight(140)
            stackView.addArrangedSubview(button)
        }
    }
    
    // Анимация уменьшения кнопки при нажатии
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            sender.alpha = 0.8
        })
    }

    // Анимация возвращения к исходному размеру и обработка нажатия
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = .identity
            sender.alpha = 1
        }) { _ in
            // Обработка точного нажатия
            self.presenter.didSelectButton(at: sender.tag)
        }
    }

    // Анимация возвращения к исходному размеру при отмене нажатия
    @objc private func buttonTouchUpOutside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = .identity
            sender.alpha = 1
        })
    }
    
//    @objc private func buttonTapped(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.1) {
//            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//            sender.alpha = 0.7
//        }
//        
//        presenter.didSelectButton(at: sender.tag)
//    }
}
