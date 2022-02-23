//
//  CustomError.swift
//  Currency
//
//  Created by Zyad Galal on 23/02/2022.
//

import Foundation

public enum CustomError: Error {
    case APIError(message: String)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .APIError(let message):
            return message
        }
    }
}
