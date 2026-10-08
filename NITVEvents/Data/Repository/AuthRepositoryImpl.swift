//import Foundation
//
//final class AuthRepositoryImpl: AuthRepository {
//    private let api: APIService
//    private let tokenStorage: TokenStorage
//
//    init(api: APIService, tokenStorage: TokenStorage) {
//        self.api = api
//        self.tokenStorage = tokenStorage
//    }
//
//    func login(email: String, password: String) async -> Resource<Session> {
//        do {
//            let response = try await api.login(LoginRequest(email: email, password: password))
//            guard let token = response.token, !token.isEmpty else {
//                return .failure(response.message ?? "Login failed")
//            }
//            tokenStorage.saveToken(token)
//            return .success(Session(token: token, userName: response.user?.name))
//        } catch {
//            return .failure(errorMessage(error))
//        }
//    }
//    
//    func logout() {
//        tokenStorage.clear()
//    }
//}
