import UIKit

enum ShapeType {
    case circle
    case square
}

/// Структура для описания конкретной фигуры: её тип (круг/квадрат), цвет, позиция и размер.
struct FocusTargetShape {
    let shapeType: ShapeType
    let color: UIColor
    /// Положение и размеры на экране
    let frame: CGRect
}
