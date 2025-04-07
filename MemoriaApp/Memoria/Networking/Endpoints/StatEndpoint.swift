enum StatEndpoint: Endpoint {
    case getUserStat(userId: String, gameId: Int)
    case updateUserStat(userId: String, gameId: Int)
    case listUserStats(userId: String)  // Новый кейс для получения всей статистики пользователя

    var compositePath: String {
        switch self {
        case .getUserStat(let userId, let gameId),
             .updateUserStat(let userId, let gameId):
            return "/api/user/\(userId)/stats/\(gameId)"
        case .listUserStats(let userId):
            return "/api/user/\(userId)/stats"
        }
    }
    
    var headers: [String: String] {
        // Для всех запросов статистики передаём заголовок авторизации и JSON
        return ["Content-Type": "application/json",
                "Authorization": CoreDataManager.shared.getToken()?.isEmpty == false ? "Bearer \(CoreDataManager.shared.getToken()!)" : ""]
    }
    
    var paremetrs: [String : String]? { nil }
}
