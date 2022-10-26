//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//

import Foundation

enum WeatherState: String, Decodable {
    case windy = "Windy"
    case sunny = "Sunny"
    case cloudy = "Cloudy"
}

enum Degrees: String, CaseIterable, Identifiable {
    public var id: Int {
        get { hashValue }
    }
    case celsius
    case fahrenheit
    case kelvin
}

struct Weather: Decodable, Identifiable {
    var id = UUID()
    let cityName: String
    var temperatue: Double // always in Celsius
    var weather: WeatherState
}
