import UIKit

// MARK: - AchievementService

/// Service responsible for handling achievement-related network operations.
final class AchievementService {
    
    /// Networking worker to handle the API requests.
    private let networkWorker: NetworkingLogic
    
    /// Base URL for the API.
    private let baseURL: String
    
    // MARK: - Initialization
    
    /// Initializes the AchievementService with an optional base URL.
    /// - Parameter baseURL: The base URL for the API (default is shared constant).
    init(baseURL: String = SharedConsts.baseURL) {
        self.baseURL = baseURL
        self.networkWorker = BaseURLWorker(baseURL: baseURL)
    }
    
    // MARK: - Achievement Fetching
    
    /// Fetches the list of all achievements from the server.
    /// - Parameter completion: Completion handler with the result, either a list of achievements or an error.
    func listAchievements(completion: @escaping (Result<[AchievementDTO], Error>) -> Void) {
        let request = Request(endpoint: AchievementsEndpoint.listAchievements,
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
                    let achievements = try JSONDecoder().decode([AchievementDTO].self, from: data)
                    completion(.success(achievements))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches achievement data by ID from the server.
    /// - Parameters:
    ///   - achievementId: The ID of the achievement to fetch.
    ///   - completion: Completion handler with the result, either the achievement data or an error.
    func getAchievement(achievementId: Int, completion: @escaping (Result<AchievementDTO, Error>) -> Void) {
        let request = Request(endpoint: AchievementsEndpoint.getAchievement(achievementId: achievementId),
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
                    let achievement = try JSONDecoder().decode(AchievementDTO.self, from: data)
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
