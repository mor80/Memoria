import Foundation

// MARK: - UploadAvatarEndpoint

/// Endpoint for uploading the user's avatar.
struct UploadAvatarEndpoint: Endpoint {
    
    /// The user ID for which the avatar is being uploaded.
    let userId: String
    
    /// The boundary string used in the multipart request.
    let boundary: String
    
    // MARK: - Endpoint Implementation
    
    /// The composite path for the endpoint to upload the avatar for the user.
    var compositePath: String {
        return "/api/user/\(userId)/avatar"
    }
    
    /// The headers for the multipart request, including the boundary and authorization token.
    var headers: [String: String] {
        return ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Authorization": CoreDataManager.shared.getToken()?.isEmpty == false ? "Bearer \(CoreDataManager.shared.getToken()!)" : ""]
    }
    
    /// Parameters for the request (nil for this case).
    var paremetrs: [String: String]? {
        return nil
    }
}

// MARK: - FileDownloadEndpoint

/// Endpoint for downloading a file from a specific path.
struct FileDownloadEndpoint: Endpoint {
    
    /// The path of the file to be downloaded.
    let path: String
    
    // MARK: - Endpoint Implementation
    
    /// The composite path for the file download endpoint.
    var compositePath: String {
        return "/\(path)"
    }
    
    /// The headers for the file download request (empty in this case).
    var headers: [String: String] {
        return [:]
    }
}
