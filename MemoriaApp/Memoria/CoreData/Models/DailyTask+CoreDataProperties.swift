import Foundation
import CoreData


extension DailyTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTask> {
        return NSFetchRequest<DailyTask>(entityName: "DailyTask")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var taskType: String?
    @NSManaged public var targetValue: Int64
    @NSManaged public var currentValue: Int64
    @NSManaged public var game: String?
    @NSManaged public var category: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var gameProgress: NSSet?

}

// MARK: Generated accessors for gameProgress
extension DailyTask {

    @objc(addGameProgressObject:)
    @NSManaged public func addToGameProgress(_ value: GameProgress)

    @objc(removeGameProgressObject:)
    @NSManaged public func removeFromGameProgress(_ value: GameProgress)

    @objc(addGameProgress:)
    @NSManaged public func addToGameProgress(_ values: NSSet)

    @objc(removeGameProgress:)
    @NSManaged public func removeFromGameProgress(_ values: NSSet)

}

extension DailyTask : Identifiable {

}
