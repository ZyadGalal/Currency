//
//  String + Extension.swift
//  Currency
//
//  Created by Zyad Galal on 24/02/2022.
//

import Foundation

extension Date {

    func getDateFrom(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.date(from: string)!
    }
    func getDayDate(before daysCount: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -daysCount, to: Date())!)
    }
}
