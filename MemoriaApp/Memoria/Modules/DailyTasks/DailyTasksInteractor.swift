import Foundation

/// Interactor responsible for fetching and preparing daily task data.
class DailyTasksInteractor: DailyTasksInteractorProtocol {
    
    // MARK: - Properties
    
    weak var presenter: DailyTasksInteractorOutputProtocol?
    
    // MARK: - Data Fetching
    
    /// Fetches today's daily tasks, generating them if necessary.
    func fetchDailyTasks() {
        generateDailyTasksIfNeeded()
        let tasks = CoreDataManager.shared.fetchDailyTasks(for: Date())
        presenter?.didFetchDailyTasks(tasks)
    }
    
    // MARK: - Daily Task Generation
    
    /// Checks if daily tasks need to be generated and creates them if not already done today.
    private func generateDailyTasksIfNeeded() {
        let defaults = UserDefaults.standard
        let lastGeneratedDate = defaults.object(forKey: "lastDailyTaskGenerationDate") as? Date
        let calendar = Calendar.current
        
        if let lastDate = lastGeneratedDate, calendar.isDateInToday(lastDate) {
            return
        }
        
        DailyTaskManager.shared.generateDailyTasks()
        defaults.set(Date(), forKey: "lastDailyTaskGenerationDate")
    }
}
