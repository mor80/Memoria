import Foundation
import CoreData


extension GameProgress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameProgress> {
        return NSFetchRequest<GameProgress>(entityName: "GameProgress")
    }

    @NSManaged public var gameName: String?
    @NSManaged public var currentPoints: Int64
    @NSManaged public var task: DailyTask?

}

extension GameProgress : Identifiable {

}
