//
//  APIRouter.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxSwift

enum APIRouter {
    case supportedSymbols
    case latest
    case historicalRates(date: String)

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
        case .historicalRates(let date):
            return date
        case .latest:
            return "latest"
        }
    }
}

enum HTTPMethod: String {
    case get
    case post
}
