import UIKit

// MARK: - UserAchievementService

/// Service responsible for handling user achievement-related network operations.
final class UserAchievementService {
    
    private let networkWorker: NetworkingLogic
    private let baseURL: String
    
    // MARK: - Initialization
    
    /// Initializes the UserAchievementService with an optional base URL.
    /// - Parameter baseURL: The base URL for the API (default is shared constant).
    init(baseURL: String = SharedConsts.baseURL) {
        self.baseURL = baseURL
        self.networkWorker = BaseURLWorker(baseURL: baseURL)
    }
    
    // MARK: - User Achievement Fetching
    
    /// Fetches the user achievement data from the server (GET request).
    /// - Parameters:
    ///   - userId: The ID of the user whose achievement is being fetched.
    ///   - achievementId: The ID of the achievement to fetch.
    ///   - completion: Completion handler that returns the user achievement data or an error.
    func getUserAchievement(for userId: String, achievementId: Int, completion: @escaping (Result<UserAchievementDTO, Error>) -> Void) {
        let request = Request(endpoint: AchievementEndpoint.getUserAchievement(userId: userId, achievementId: achievementId),
                              method: .get,
                              paremetrs: nil,
                              body: nil)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                guard let data = serverResponse.data else {
                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let achievement = try JSONDecoder().decode(UserAchievementDTO.self, from: data)
                    completion(.success(achievement))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - User Achievement Updating
    
    /// Updates the user achievement data on the server (PATCH request).
    /// - Parameters:
    ///   - userId: The ID of the user whose achievement is being updated.
    ///   - achievementId: The ID of the achievement to update.
    ///   - achieved: Whether the achievement has been achieved or not.
    ///   - progress: The current progress of the achievement.
    ///   - completion: Completion handler that returns the updated achievement data or an error.
    func updateUserAchievement(for userId: String, achievementId: Int, achieved: Bool?, progress: Int?, completion: @escaping (Result<UserAchievementDTO, Error>) -> Void) {
        let updateDTO = UpdateUserAchievementDTO(achieved: achieved, progress: progress)
        guard let bodyData = try? JSONEncoder().encode(updateDTO) else {
            completion(.failure(NSError(domain: "EncodingError", code: -1, userInfo: nil)))
            return
        }
        let request = Request(endpoint: AchievementEndpoint.updateUserAchievement(userId: userId, achievementId: achievementId),
                              method: .patch,
                              paremetrs: nil,
                              body: bodyData)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                guard let data = serverResponse.data else {
                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let achievement = try JSONDecoder().decode(UserAchievementDTO.self, from: data)
                    completion(.success(achievement))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
