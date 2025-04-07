import UIKit

// MARK: - StatService

/// Service responsible for handling statistics-related network operations.
final class StatService {
    
    /// Networking worker to handle API requests.
    private let networkWorker: NetworkingLogic
    
    /// Base URL for the API.
    private let baseURL: String
    
    // MARK: - Initialization
    
    /// Initializes the StatService with an optional base URL.
    /// - Parameter baseURL: The base URL for the API (default is shared constant).
    init(baseURL: String = SharedConsts.baseURL) {
        self.baseURL = baseURL
        self.networkWorker = BaseURLWorker(baseURL: baseURL)
    }
    
    // MARK: - Stat Fetching
    
    /// Fetches the statistics for a specific game and user.
    /// - Parameters:
    ///   - userId: The ID of the user whose statistics are being fetched.
    ///   - gameId: The ID of the game for which statistics are being fetched.
    ///   - completion: Completion handler that returns the result, either user game stats or an error.
    func getStat(for userId: String, gameId: Int, completion: @escaping (Result<UserGameStatDTO, Error>) -> Void) {
        let request = Request(endpoint: StatEndpoint.getUserStat(userId: userId, gameId: gameId),
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
                    let stat = try JSONDecoder().decode(UserGameStatDTO.self, from: data)
                    completion(.success(stat))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Updates the statistics for a specific game and user (PATCH request).
    /// - Parameters:
    ///   - userId: The ID of the user whose stats are being updated.
    ///   - gameId: The ID of the game for which stats are being updated.
    ///   - highScore: The new high score to be set.
    ///   - gamesPlayed: The number of games played to update.
    ///   - completion: Completion handler that returns the updated stat or an error.
    func updateStat(for userId: String, gameId: Int, highScore: Int?, gamesPlayed: Int?, completion: @escaping (Result<UserGameStatDTO, Error>) -> Void) {
        let updateDTO = UpdateUserGameStatDTO(high_score: highScore, games_played: gamesPlayed)
        guard let bodyData = try? JSONEncoder().encode(updateDTO) else {
            completion(.failure(NSError(domain: "EncodingError", code: -1, userInfo: nil)))
            return
        }
        let request = Request(endpoint: StatEndpoint.updateUserStat(userId: userId, gameId: gameId),
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
                    let stat = try JSONDecoder().decode(UserGameStatDTO.self, from: data)
                    completion(.success(stat))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Increments the number of games played for a specific game and user.
    /// - Parameters:
    ///   - userId: The ID of the user whose games played count is being incremented.
    ///   - gameId: The ID of the game for which the games played count is being incremented.
    ///   - completion: Completion handler that returns the updated stats or an error.
    func incrementGamesPlayed(for userId: String, gameId: Int, completion: @escaping (Result<UserGameStatDTO, Error>) -> Void) {
        // First fetch the current stats
        getStat(for: userId, gameId: gameId) { result in
            switch result {
            case .success(let stat):
                let newGamesPlayed = stat.games_played + 1
                // Update the stat with the new games played count
                self.updateStat(for: userId, gameId: gameId, highScore: nil, gamesPlayed: newGamesPlayed, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches all user statistics from the server.
    /// - Parameters:
    ///   - userId: The ID of the user whose stats are being fetched.
    ///   - completion: Completion handler that returns the list of user game stats or an error.
    func listUserStats(for userId: String, completion: @escaping (Result<[UserGameStatDTO], Error>) -> Void) {
        let request = Request(endpoint: StatEndpoint.listUserStats(userId: userId),
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
                    let stats = try JSONDecoder().decode([UserGameStatDTO].self, from: data)
                    completion(.success(stats))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
