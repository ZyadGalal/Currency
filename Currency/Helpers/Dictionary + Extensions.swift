//
//  Dictionary + Extensions.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
