//
//  APIRouter.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxSwift

enum APIRouter {
    
    case convertCurrency
    
    var method: HTTPMethod {
        switch self {
        case .convertCurrency:
            return .Get
        }
    }
    var path: String {
        switch self {
        case .convertCurrency:
            return ""
        }
    }
    
}

enum HTTPMethod: String {
    case Get
    case post
}
