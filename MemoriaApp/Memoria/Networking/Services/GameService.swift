import UIKit

// MARK: - GameService

/// Service responsible for handling game-related network operations.
final class GameService {
    
    /// Networking worker to handle API requests.
    private let networkWorker: NetworkingLogic
    
    /// Base URL for the API.
    private let baseURL: String
    
    // MARK: - Initialization
    
    /// Initializes the GameService with an optional base URL.
    /// - Parameter baseURL: The base URL for the API (default is shared constant).
    init(baseURL: String = SharedConsts.baseURL) {
        self.baseURL = baseURL
        self.networkWorker = BaseURLWorker(baseURL: baseURL)
    }
    
    // MARK: - Game Fetching
    
    /// Fetches the list of all games from the server.
    /// - Parameter completion: Completion handler with the result, either a list of games or an error.
    func listGames(completion: @escaping (Result<[GameDTO], Error>) -> Void) {
        let request = Request(endpoint: GameEndpoint.listGames,
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
                    let games = try JSONDecoder().decode([GameDTO].self, from: data)
                    completion(.success(games))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
