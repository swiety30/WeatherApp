//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 02/08/2022.
//

import Foundation

public extension Double {
    func roundedToTwoDecimals() -> Double {
        (self * 100).rounded() / 100
    }
}
