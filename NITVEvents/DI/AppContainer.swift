import Foundation

/// Manual dependency injection container (data -> domain -> presentation).
@MainActor
final class AppContainer {
    static let shared = AppContainer()

    private let tokenStorage = TokenStorage()
    private lazy var api: APIService = AppConfig.useMockAPI
        ? MockAPIService()
        : RemoteAPIService(baseURL: AppConfig.baseURL, tokenStorage: tokenStorage)
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl(api: api, tokenStorage: tokenStorage)
//    private lazy var ticketRepository: TicketRepository = TicketRepositoryImpl(api: api)

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel()
    }

    func makeTicketViewModel() -> TicketViewModel {
        TicketViewModel()
    }
    
    func logout() {
        tokenStorage.clear()   
    }
}
