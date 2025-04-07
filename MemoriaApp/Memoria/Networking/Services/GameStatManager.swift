import Foundation
import UIKit

// MARK: - GameStatManager

/// Manager responsible for handling game statistics, including updating scores and tracking game rounds.
final class GameStatManager {
    
    private let statService: StatService
    private let userId: String
    private let gameId: Int
    
    // MARK: - Initialization
    
    /// Initializes the GameStatManager with the provided game ID.
    /// - Parameter gameId: The ID of the game for which statistics are managed.
    init(gameId: Int) {
        // Fetch the user from CoreDataManager
        let fetchedUser = CoreDataManager.shared.fetchUser()
        self.userId = fetchedUser.dto.id
        self.gameId = gameId
        self.statService = StatService()
    }
    
    // MARK: - Update Score
    
    /// Updates the score on the server if the new score is higher than the current high score.
    /// - Parameters:
    ///   - newScore: The new score to be updated.
    ///   - completion: An optional completion handler that returns the updated high score or an error.
    func updateScore(newScore: Int, completion: ((Result<Int, Error>) -> Void)? = nil) {
        // If the user is not authorized, do nothing.
        guard !userId.isEmpty else {
            print("User not authorized")
            return
        }
        
        // Fetch current stats from the server
        statService.getStat(for: userId, gameId: gameId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stat):
                // For reaction games (id = 7), we consider the best score to be the minimum
                if self.gameId == 7 {
                    // If no score is set or the new score is less than the current, update it.
                    if stat.high_score == 0 || newScore < stat.high_score {
                        self.statService.updateStat(for: self.userId,
                                                    gameId: self.gameId,
                                                    highScore: newScore,
                                                    gamesPlayed: nil) { updateResult in
                            switch updateResult {
                            case .success(let updatedStat):
                                completion?(.success(updatedStat.high_score))
                            case .failure(let error):
                                completion?(.failure(error))
                            }
                        }
                    } else {
                        completion?(.success(stat.high_score))
                    }
                } else {
                    // For other games, update if the new score is higher.
                    if newScore > stat.high_score {
                        self.statService.updateStat(for: self.userId,
                                                    gameId: self.gameId,
                                                    highScore: newScore,
                                                    gamesPlayed: nil) { updateResult in
                            switch updateResult {
                            case .success(let updatedStat):
                                completion?(.success(updatedStat.high_score))
                            case .failure(let error):
                                completion?(.failure(error))
                            }
                        }
                    } else {
                        completion?(.success(stat.high_score))
                    }
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Increment Games Played
    
    /// Increments the number of games played on the server.
    /// - Parameter completion: An optional completion handler that returns the updated games played or an error.
    func newRound(completion: ((Result<Int, Error>) -> Void)? = nil) {
        guard !userId.isEmpty else {
            print("User not authorized")
            return
        }
        
        statService.incrementGamesPlayed(for: userId, gameId: gameId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedStat):
                // Fetch current user from CoreData
                let fetchedUser = CoreDataManager.shared.fetchUser()
                // Assuming the user has an experience field
                let currentExperience = fetchedUser.dto.experience
                let newExperience = currentExperience + 50
                
                // Create the update data for the user
                let updateData = UpdateUserDTO(name: nil, email: nil, experience: newExperience)
                
                // Create an instance of UserService and send the update request
                let userService = UserService()
                userService.updateUser(with: self.userId, updateData: updateData) { updateResult in
                    switch updateResult {
                    case .success:
                        // If the update was successful, return the updated games played count
                        completion?(.success(updatedStat.games_played))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
