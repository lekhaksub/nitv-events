import Foundation

/// Fake backend so the app runs end-to-end without a server (AppConfig.useMockAPI).
/// Login: any valid email + password with 6+ characters.
final class MockAPIService: APIService {

    private let sampleTickets: [TicketDTO] = [
        TicketDTO(ticketId: "NT-1001", name: "Ram Gurung", phone: "09012345678", event: "Pension Patta", show: "Show #1 · 1:00pm", status: "Valid", viewUrl: nil),
        TicketDTO(ticketId: "NT-1002", name: "Sita Tamang", phone: "08023456789", event: "Pension Patta", show: "Show #2 · 4:30pm", status: "Valid", viewUrl: nil),
        TicketDTO(ticketId: "NT-1003", name: "Hari Rai", phone: "07034567890", event: "Pension Patta", show: "Show #1 · 1:00pm", status: "Used", viewUrl: nil),
        TicketDTO(ticketId: "NT-1004", name: "Maya Limbu", phone: "09045678901", event: "Pension Patta", show: "Show #2 · 4:30pm", status: "Valid", viewUrl: nil),
        TicketDTO(ticketId: "NT-1005", name: "Bikash Thapa", phone: "08056789012", event: "Pension Patta", show: "Show #1 · 1:00pm", status: "Valid", viewUrl: nil)
    ]

    func login(_ body: LoginRequest) async throws -> LoginResponse {
        try await Task.sleep(nanoseconds: 800_000_000)
        guard body.email.contains("@"), body.password.count >= 6 else {
            throw APIError.http(code: 401, message: "Invalid email or password")
        }
        return LoginResponse(
            message: "Login successful",
            token: "mock-token-123",
            user: UserDTO(id: "1", name: String(body.email.split(separator: "@").first ?? ""), email: body.email)
        )
        
//        return LoginResponse(status: true, data: UserTokenData)
    }

    func searchTickets(query: String) async throws -> TicketSearchResponse {
        try await Task.sleep(nanoseconds: 500_000_000)
        let q = query.trimmed.lowercased()
        let list = sampleTickets.filter {
            ($0.name ?? "").lowercased().contains(q) ||
            ($0.ticketId ?? "").lowercased().contains(q) ||
            ($0.phone ?? "").contains(q)
        }
        return TicketSearchResponse(message: nil, data: list)
    }
}
