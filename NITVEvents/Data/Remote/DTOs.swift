import Foundation

// MARK: - Auth
struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String?
    let token: String?
    let user: UserDTO?
}

struct UserDTO: Codable {
    let id: String?
    let name: String?
    let email: String?
}

struct ErrorDTO: Codable {
    let message: String?
}

// MARK: - Tickets
struct TicketSearchResponse: Codable {
    let message: String?
    let data: [TicketDTO]?
}

struct TicketDTO: Codable {
    let ticketId: String?
    let name: String?
    let phone: String?
    let event: String?
    let show: String?
    let status: String?
    let viewUrl: String?

    enum CodingKeys: String, CodingKey {
        case ticketId = "ticket_id"
        case name, phone, event, show, status
        case viewUrl = "view_url"
    }
}
