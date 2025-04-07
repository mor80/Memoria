import UIKit

// MARK: - View

/// Protocol defining the interface for the view to display daily tasks.
protocol DailyTasksViewProtocol: AnyObject {
    /// Displays the provided list of daily task view models.
    /// - Parameter tasks: Array of `DailyTaskViewModel` to be shown.
    func displayDailyTasks(_ tasks: [DailyTaskViewModel])
}

// MARK: - Presenter

/// Protocol defining presenter actions in response to view events.
protocol DailyTasksPresenterProtocol: AnyObject {
    /// Called when the view is loaded.
    func viewDidLoad()
}

// MARK: - Interactor

/// Protocol defining data-fetching logic for the daily tasks module.
protocol DailyTasksInteractorProtocol: AnyObject {
    /// Fetches today's daily tasks.
    func fetchDailyTasks()
}

/// Protocol for receiving output from the interactor.
protocol DailyTasksInteractorOutputProtocol: AnyObject {
    /// Called when daily tasks are fetched.
    /// - Parameter tasks: Array of fetched `DailyTask` objects.
    func didFetchDailyTasks(_ tasks: [DailyTask])
}

// MARK: - Router

/// Protocol defining navigation for the daily tasks module.
protocol DailyTasksRouterProtocol: AnyObject {
    /// Creates the DailyTasks module.
    /// - Returns: Configured `UIViewController`.
    static func createModule() -> UIViewController
}
