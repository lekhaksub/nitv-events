//
//  LoginModel.swift
//  NITVEvents
//
//  Created by Shubham Lekhak on 08/10/2026.
//


import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Bool?
    let data: LoginData?
}

// MARK: - DataClass
struct LoginData: Codable {
    let token: String?

}

