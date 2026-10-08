import Foundation

//struct Session {
//    let token: String
//    let userName: String?
//}
//
//struct Ticket: Codable {
//    let ticketId: String
//    let holderName: String
//    let phone: String
//    let purchaseId: Int
//    let email: String
//    let status: String
//    let viewURL: String
//    
//    enum CodingKeys: String, CodingKey {
//        case ticketId = "ticket_id"
//        case holderName = "name"
//        case phone
//        case purchaseId = "purchase_id"
//        case email
//        case status
//        case viewURL = "url"
//    }
//}
//
//struct TicketsResponse: Codable {
//    let data: [Ticket]?
//}

import Foundation

// MARK: - TicketResponse
struct TicketResponse: Codable {
    let status: Bool?
    let data: [TicketData]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

// MARK: - Datum
struct TicketData: Codable {
    let purchaseID: Int?
    let ticketID: String?
    let name: String?
    let email: String?
    let phone: String?
    let status: String?
    let isScanned: Bool?
    let url: String?
    let purchase: PurchaseStatus?

    enum CodingKeys: String, CodingKey {
        case purchaseID = "purchase_id"
        case ticketID = "ticket_id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case status = "status"
        case isScanned = "is_scanned"
        case url = "url"
        case purchase = "purchase"
    }
}

// MARK: - Purchase
struct PurchaseStatus: Codable {
    let id: Int?
    let quantity: Int?
    let total: String?
    let status: String?
    let sessionID: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case quantity = "quantity"
        case total = "total"
        case status = "status"
        case sessionID = "session_id"
    }
}
