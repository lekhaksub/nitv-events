//import Foundation
//
//struct LoginUseCase {
//    let repository: AuthRepository
//
//    func callAsFunction(email: String, password: String) async -> Resource<Session> {
//        let emailPattern = "^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"
//        guard email.range(of: emailPattern, options: .regularExpression) != nil else {
//            return .failure("Enter a valid email address")
//        }
//        guard !password.trimmed.isEmpty else { return .failure("Enter your password") }
//        return await repository.login(email: email, password: password)
//    }
//}
//
//struct SearchTicketsUseCase {
//    let repository: TicketRepository
//
//    func callAsFunction(query: String) async -> Resource<[Ticket]> {
//        await repository.search(query: query.trimmed)
//    }
//}
