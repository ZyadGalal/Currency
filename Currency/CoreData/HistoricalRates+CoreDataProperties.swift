//
//  HistoricalRates+CoreDataProperties.swift
//  Currency
//
//  Created by Zyad Galal on 24/02/2022.
//
//

import Foundation
import CoreData


extension HistoricalRates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalRates> {
        return NSFetchRequest<HistoricalRates>(entityName: "HistoricalRates")
    }

    @NSManaged public var date: String?
    @NSManaged public var rate: Data?

}

extension HistoricalRates : Identifiable {

}
