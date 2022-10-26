//
//  DegreeModel.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 26/10/2022.
//

import Foundation

@MainActor
class DegreeModel: ObservableObject {
    @Published private(set) var conventer: Degrees = .celsius
    func changeConventer(to degree: Degrees) {
        conventer = degree
    }

    func formatDegree(_ degrees: Double) -> String {
        switch conventer {
        case .celsius:
            return String(degrees) + "\u{00B0}"
        case .fahrenheit:
            return String((degrees * 33.8).roundedToTwoDecimals()) + "F"
        case .kelvin:
            return String((degrees * 274.15).roundedToTwoDecimals()) + "K"
        }
    }
}
