import Foundation

/// A singleton responsible for managing daily task logic and game progress updates.
final class DailyTaskManager {
    
    // MARK: - Singleton
    
    static let shared = DailyTaskManager()
    private let coreDataManager = CoreDataManager.shared
    
    private init() {}
    
    // MARK: - Game Event Handlers
    
    /// Called when a new round is started in a game.
    /// Updates tasks of type `roundsInGame` and `roundsInCategory`.
    /// - Parameters:
    ///   - gameName: The name of the game.
    ///   - category: The category of the game.
    func handleNewRound(gameName: String, category: String) {
        let todayTasks = coreDataManager.fetchDailyTasks(for: Date())
        
        for task in todayTasks {
            if task.taskType == "roundsInGame",
               let taskGame = task.game, taskGame == gameName {
                coreDataManager.updateDailyTaskProgress(task: task, newValue: 1)
            } else if task.taskType == "roundsInCategory",
                      let taskCategory = task.category, taskCategory == category {
                coreDataManager.updateDailyTaskProgress(task: task, newValue: 1)
            }
        }
    }
    
    /// Called when points are earned in a game.
    /// Updates tasks of type `pointsInGame` and `pointsInEachGameInCategory`.
    /// - Parameters:
    ///   - gameName: The name of the game.
    ///   - category: The category of the game.
    ///   - points: The number of points earned.
    func handleNewPoints(gameName: String, category: String, points: Int64) {
        let todayTasks = coreDataManager.fetchDailyTasks(for: Date())
        
        for task in todayTasks {
            if task.taskType == "pointsInGame",
               let taskGame = task.game, taskGame == gameName {
                coreDataManager.updateDailyTaskProgress(task: task, newValue: points)
            } else if task.taskType == "pointsInEachGameInCategory",
                      let taskCategory = task.category, taskCategory == category {
                coreDataManager.updateGameProgress(for: task, gameName: gameName, newPoints: points)
            }
        }
    }
    
    // MARK: - Daily Task Generation
    
    /// Generates 3 random daily tasks after clearing any existing ones.
    ///
    /// Task types (3 out of 4 are randomly selected):
    /// - `roundsInCategory`: Play rounds in a specific category.
    /// - `roundsInGame`: Play rounds in a specific game.
    /// - `pointsInGame`: Earn points in a specific game.
    /// - `pointsInEachGameInCategory`: Earn points in each game of a category.
    func generateDailyTasks() {
        coreDataManager.clearDailyTasks()
        
        let allTaskTypes = ["roundsInCategory", "roundsInGame", "pointsInGame", "pointsInEachGameInCategory"]
        let selectedTypes = Array(allTaskTypes.shuffled().prefix(3))
        
        func randomRoundsTargetValue() -> Int64 {
            let possibleValues = stride(from: 10, through: 30, by: 5).map { Int64($0) }
            return possibleValues.randomElement() ?? 10
        }
        
        func randomPointsTargetValue() -> Int64 {
            let possibleValues = stride(from: 1000, through: 2500, by: 50).map { Int64($0) }
            return possibleValues.randomElement() ?? 1000
        }
        
        let categories = ["Memory", "Focus", "Reaction"]
        
        let allGames = ["Matrix Memory", "Sequence Memory", "Number Memory",
                        "Stroop Game", "Focus Target", "Pair Game",
                        "Reaction Time", "Quick Math", "Symbol Sequence"]
        
        let pointsGames = ["Matrix Memory", "Sequence Memory", "Number Memory",
                           "Stroop Game", "Focus Target", "Pair Game",
                           "Quick Math", "Symbol Sequence"]
        
        for taskType in selectedTypes {
            switch taskType {
            case "roundsInCategory":
                let category = categories.randomElement() ?? "Memory"
                let targetValue = randomRoundsTargetValue()
                coreDataManager.createDailyTask(taskType: taskType, targetValue: targetValue, category: category)
                
            case "roundsInGame":
                let game = allGames.randomElement() ?? "Matrix Memory"
                let targetValue = randomRoundsTargetValue()
                coreDataManager.createDailyTask(taskType: taskType, targetValue: targetValue, game: game)
                
            case "pointsInGame":
                let game = pointsGames.randomElement() ?? "Matrix Memory"
                let targetValue = randomPointsTargetValue()
                coreDataManager.createDailyTask(taskType: taskType, targetValue: targetValue, game: game)
                
            case "pointsInEachGameInCategory":
                let category = categories.randomElement() ?? "Memory"
                let targetValue = randomPointsTargetValue()
                var gameNames: [String] = []
                
                if category == "Memory" {
                    gameNames = ["Matrix Memory", "Sequence Memory", "Number Memory"]
                } else if category == "Focus" {
                    gameNames = ["Stroop Game", "Focus Target", "Pair Game"]
                } else if category == "Reaction" {
                    gameNames = ["Quick Math", "Symbol Sequence"]
                }
                
                coreDataManager.createDailyTask(
                    taskType: taskType,
                    targetValue: targetValue,
                    category: category,
                    gameNames: gameNames
                )
                
            default:
                break
            }
        }
    }
}
