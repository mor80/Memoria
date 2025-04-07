import Foundation

/// Presenter for the Daily Tasks module, responsible for coordinating between view, interactor, and router.
class DailyTasksPresenter: DailyTasksPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: DailyTasksViewProtocol?
    var interactor: DailyTasksInteractorProtocol?
    var router: DailyTasksRouterProtocol?
    
    // MARK: - Properties
    
    private var dailyTasks: [DailyTask] = []
    
    // MARK: - View Lifecycle
    
    /// Called when the view is loaded.
    func viewDidLoad() {
        interactor?.fetchDailyTasks()
    }
}

// MARK: - DailyTasksInteractorOutputProtocol

extension DailyTasksPresenter: DailyTasksInteractorOutputProtocol {
    
    /// Called when daily tasks are fetched from the interactor.
    /// - Parameter tasks: Array of fetched `DailyTask` objects.
    func didFetchDailyTasks(_ tasks: [DailyTask]) {
        dailyTasks = tasks
        
        let viewModels = tasks.map { task -> DailyTaskViewModel in
            let currentValue = task.isCompleted ? task.targetValue : task.currentValue
            var desc = ""
            
            switch task.taskType {
            case "roundsInCategory":
                desc = "Play \(task.targetValue) rounds in \(task.category ?? "a category")"
            case "roundsInGame":
                desc = "Play \(task.targetValue) rounds in \(task.game ?? "a game")"
            case "pointsInGame":
                desc = "Score \(task.targetValue) points in \(task.game ?? "a game")"
            case "pointsInEachGameInCategory":
                desc = "Score \(task.targetValue) points in each game in \(task.category ?? "a category")"
            default:
                desc = ""
            }
            
            return DailyTaskViewModel(
                taskType: task.taskType ?? "",
                targetValue: task.targetValue,
                currentValue: currentValue,
                description: desc,
                isCompleted: task.isCompleted
            )
        }
        
        view?.displayDailyTasks(viewModels)
    }
}
