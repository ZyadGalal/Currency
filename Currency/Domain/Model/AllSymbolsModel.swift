//
//  AllSymbolsModel.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation

struct AllSymbolsModel: Codable {
    let success: Bool?
    let symbols: [String: String]?
    let error: ErrorModel?
}

// MARK: - Error
struct ErrorModel: Codable {
    let code: Int?
    let info: String?
}


