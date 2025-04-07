enum SymbolSequenceSymbol: CaseIterable, Equatable {
    case triangle
    case circle
    case cross
    case square

    var sfSymbolName: String {
        switch self {
        case .triangle: return "triangle.fill"
        case .circle:   return "circle.fill"
        case .cross:    return "xmark"
        case .square:   return "square.fill"
        }
    }
}
