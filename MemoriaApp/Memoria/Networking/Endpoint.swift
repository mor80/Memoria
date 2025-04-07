protocol Endpoint {
    var compositePath: String { get }
    var headers: [String: String] { get }
    var paremetrs: [String: String]? { get }
}

extension Endpoint {
    var paremetrs: [String: String]? { nil }
}

