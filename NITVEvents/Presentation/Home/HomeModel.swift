//
//  HomeModel.swift
//  NITVEvents
//
//  Created by Shubham Lekhak on 08/10/2026.
//

import Foundation

// MARK: - ScennedTicketResponse
struct ScennedTicketResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ScennedTicketData?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
struct ScennedTicketData: Codable {
    let ticketID: String?
    let name: String?
    let email: String?
    let phone: String?
    let status: String?
    let isValid: Bool?

    enum CodingKeys: String, CodingKey {
        case ticketID = "ticket_id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case status = "status"
        case isValid = "is_valid"
    }
}
