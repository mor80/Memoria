import UIKit

// MARK: - Entities

enum QuickMathOperator: CaseIterable {
    case addition, subtraction, multiplication
    
    var symbol: String {
        switch self {
        case .addition:
            return "+"
        case .subtraction:
            return "−"
        case .multiplication:
            return "*"
        }
    }
}

struct QuickMathProblem {
    let left: Int
    let right: Int
    let op: QuickMathOperator
    
    var questionText: String {
        return "\(left) \(op.symbol) \(right)"
    }
    
    var answer: Int {
        switch op {
        case .addition:
            return left + right
        case .subtraction:
            return left - right
        case .multiplication:
            return left * right
        }
    }
}
