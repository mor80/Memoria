import Foundation
import CoreData


extension TokenEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TokenEntity> {
        return NSFetchRequest<TokenEntity>(entityName: "TokenEntity")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var tokenType: String?

}

extension TokenEntity : Identifiable {

}
