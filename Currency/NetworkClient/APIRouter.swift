//
//  APIRouter.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxSwift

enum APIRouter {
    case supportedSymbols(queryParameters: [String: String])
    case latest(queryParameters: [String: String])
    case historicalRates(date: String, queryParameters: [String: String])

    var method: HTTPMethod {
        switch self {
        case .supportedSymbols:
            return .get
        case .historicalRates:
            return .get
        case .latest:
            return .get
        }
    }
    var path: String {
        switch self {
        case .supportedSymbols:
            return "symbols"
        case .historicalRates(let date, _):
            return date
        case .latest:
            return "latest"
        }
    }

    var queryParameters: [String: String] {
        switch self {
        case .supportedSymbols(let queryParameter):
            return queryParameter
        case .historicalRates(_, let queryParameter):
            return queryParameter
        case .latest(let queryParameters):
            return queryParameters
        }
    }
}

enum HTTPMethod: String {
    case get
    case post
}
