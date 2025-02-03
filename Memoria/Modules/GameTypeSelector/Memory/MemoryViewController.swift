import UIKit

class MemoryGamesViewController: UIViewController, GameTypeViewProtocol {
    var presenter: GameTypePresenterProtocol!
    
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
        setupNavigationBar()
        setupStackView()
        presenter.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        // Настройка кнопки возврата (только стрелка)
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        // Убираем текст заголовка
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        
        // Констрейнты для StackView
        stackView.pinCenter(to: view)
        stackView.pinLeft(to: view.leadingAnchor, 20)
    }
    
    func displayGameButtons(titles: [String]) {
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.tag = index
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 100).isActive = true
            button.addTarget(self, action: #selector(gameButtonTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gameButtonTapped(_ sender: UIButton) {
        presenter.didSelectGame(at: sender.tag)
    }
}
