//
//  String + Extension.swift
//  Currency
//
//  Created by Zyad Galal on 25/02/2022.
//

import Foundation

extension String {
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.date(from: self)!
    }
}
