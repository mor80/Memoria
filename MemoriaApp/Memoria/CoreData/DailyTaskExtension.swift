import UIKit
import CoreData

// MARK: - DailyTask & GameProgress Handling

extension CoreDataManager {
    
    /// Creates a new `DailyTask` with optional game and category associations.
    /// - Parameters:
    ///   - taskType: The type of task (e.g., "roundsInCategory", "pointsInGame").
    ///   - targetValue: The target value (points or rounds).
    ///   - game: A specific game name (optional).
    ///   - category: A specific category name (optional).
    ///   - gameNames: A list of games (for "pointsInEachGameInCategory" type).
    /// - Returns: The newly created `DailyTask` object.
    func createDailyTask(taskType: String,
                         targetValue: Int64,
                         game: String? = nil,
                         category: String? = nil,
                         gameNames: [String]? = nil) -> DailyTask {
        let dailyTask = DailyTask(context: context)
        dailyTask.id = UUID()
        dailyTask.date = Date()
        dailyTask.taskType = taskType
        dailyTask.targetValue = targetValue
        dailyTask.currentValue = 0
        dailyTask.game = game
        dailyTask.category = category
        dailyTask.isCompleted = false
        
        // For "pointsInEachGameInCategory", create GameProgress for each game
        if taskType == "pointsInEachGameInCategory", let gameNames = gameNames {
            for name in gameNames {
                let progress = GameProgress(context: context)
                progress.gameName = name
                progress.currentPoints = 0
                progress.task = dailyTask
                dailyTask.addToGameProgress(progress)
            }
        }
        
        saveContext()
        return dailyTask
    }
    
    /// Fetches all `DailyTask` objects for a given date.
    /// - Parameter date: The date to filter tasks.
    /// - Returns: An array of `DailyTask` objects.
    func fetchDailyTasks(for date: Date) -> [DailyTask] {
        let fetchRequest: NSFetchRequest<DailyTask> = DailyTask.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch DailyTasks: \(error)")
            return []
        }
    }
    
    /// Deletes all daily tasks that are older than the current day.
    func deleteOldDailyTasks() {
        let fetchRequest: NSFetchRequest<DailyTask> = DailyTask.fetchRequest()
        let startOfToday = Calendar.current.startOfDay(for: Date())
        fetchRequest.predicate = NSPredicate(format: "date < %@", startOfToday as NSDate)
        
        do {
            let oldTasks = try context.fetch(fetchRequest)
            oldTasks.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Failed to delete old DailyTasks: \(error)")
        }
    }
    
    /// Updates progress for a given daily task.
    /// - Parameters:
    ///   - task: The task to update.
    ///   - newValue: The new value to apply.
    func updateDailyTaskProgress(task: DailyTask, newValue: Int64) {
        if task.taskType == "pointsInGame" {
            if newValue > task.currentValue {
                task.currentValue = newValue
            }
        } else {
            task.currentValue += newValue
        }
        
        if task.currentValue >= task.targetValue {
            task.isCompleted = true
        }
        saveContext()
    }
    
    /// Updates progress for a specific game within a grouped task.
    /// - Parameters:
    ///   - task: The parent task object.
    ///   - gameName: The game name to update.
    ///   - newPoints: The new point value.
    func updateGameProgress(for task: DailyTask, gameName: String, newPoints: Int64) {
        guard let gameProgressSet = task.gameProgress as? Set<GameProgress> else {
            print("Game progress not found for this task.")
            return
        }
        
        if let progress = gameProgressSet.first(where: { $0.gameName == gameName }) {
            if newPoints > progress.currentPoints {
                progress.currentPoints = newPoints
            }
            
            let allCompleted = gameProgressSet.allSatisfy {
                $0.currentPoints >= task.targetValue
            }
            
            if allCompleted {
                task.isCompleted = true
            }
            saveContext()
        } else {
            print("Progress for game \(gameName) not found in task.")
        }
    }
    
    /// Deletes all `DailyTask` objects regardless of date.
    func clearDailyTasks() {
        let fetchRequest: NSFetchRequest<DailyTask> = DailyTask.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            tasks.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Failed to clear DailyTasks: \(error)")
        }
    }
    
    /// Prints all tasks and their progress for debugging purposes.
    func verifyDailyTasksCreation() {
        let tasks = fetchDailyTasks(for: Date())
        print("Generated tasks: \(tasks.count)")
        
        for task in tasks {
            print("Task: \(task.taskType ?? "unknown"), Target: \(task.targetValue), Date: \(String(describing: task.date))")
            if task.taskType == "pointsInEachGameInCategory",
               let gameProgressSet = task.gameProgress as? Set<GameProgress> {
                for progress in gameProgressSet {
                    print("   Game: \(progress.gameName ?? "unknown"), Points: \(progress.currentPoints)")
                }
            }
        }
    }
}
