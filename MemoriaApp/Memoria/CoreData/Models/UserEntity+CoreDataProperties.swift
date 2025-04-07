import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var avatar: Data?
    @NSManaged public var email: String?
    @NSManaged public var experience: Int32
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var isLoggedIn: Bool
}

extension UserEntity : Identifiable {

}
