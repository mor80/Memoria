import Foundation
import UIKit

struct LoginDTO: Codable {
    let email: String
    let password: String
    
    func generateRequestBody() -> Data? {
        let grantType = "password"
        let scope = ""
        let clientId = "string"
        let clientSecret = "string"
        let body = "grant_type=\(grantType)&username=\(email)&password=\(password)&scope=\(scope)&client_id=\(clientId)&client_secret=\(clientSecret)"
        
        guard let data = body.data(using: .utf8) else {
            return nil
        }
        
        return data
    }
}

struct AddUserDTO: Codable {
    let name: String
    let email: String
    let password: String
}

struct UpdateUserDTO: Codable {
    let name: String?
    let email: String?
    let experience: Int?
}

struct UserDTO: Codable {
    let id: String
    let name: String
    let experience: Int
    let email: String
    let avatarUrl: String?
        
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case experience
        case email
        case avatarUrl = "avatar_url"
    }
}

