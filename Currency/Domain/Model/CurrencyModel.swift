//
//  CurrencyModel.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation

struct CurrencyModel: Codable {
    let success: Bool?
    let timestamp: Int?
    let base, date: String?
    let rates: [String: Double]?
    let error: ErrorModel?
}
