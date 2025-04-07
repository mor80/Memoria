import Foundation

struct Request {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
        case options = "OPTIONS"
    }
    
    var endpoint: Endpoint
    var method: Method
    var parameters: [String: String]?
    var timeInterval: TimeInterval
    
    let body: Data?
    
    init(
        endpoint: Endpoint,
        method: Method = .get,
        paremetrs: [String : String]? = nil,
        body: Data? = nil,
        timeInterval: TimeInterval = 60
    ) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = paremetrs
        self.timeInterval = timeInterval
        self.body = body
        if var endpointParemetrs = endpoint.paremetrs {
            for (key, value) in paremetrs ?? [:] {
                endpointParemetrs[key] = value
            }
            
            self.parameters = endpointParemetrs
        }
    }
}
