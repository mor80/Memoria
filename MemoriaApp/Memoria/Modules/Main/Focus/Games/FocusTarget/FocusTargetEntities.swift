import UIKit

enum ShapeType {
    case circle
    case square
}

struct FocusTargetShape {
    let shapeType: ShapeType
    let color: UIColor
    let frame: CGRect
}
