import UIKit

protocol GameTypeRouterProtocol: AnyObject {
    func navigateToGameDetail(gameName: String)
    static func createModule() -> UIViewController
}
