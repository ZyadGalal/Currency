//
//  Double + Extension.swift
//  Currency
//
//  Created by Zyad Galal on 25/02/2022.
//

import Foundation

extension Double {
    func convertCurrency(firstRate: Double, secondRate: Double) -> Double {
        let result = (firstRate / secondRate) * self
        let multiplier = pow(10.0, Double(3))
        return (result * multiplier).rounded() / multiplier
    }
}
