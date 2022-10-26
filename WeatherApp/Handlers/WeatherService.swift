//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//

import SwiftUI

enum WeatherServiceError: Error {
    case weatherAlreadyExists
    case dummy
}

// Used Task.sleep(nanoseconds) just to mimic URLSession behaviour. Task.sleep is not blocking threads.
struct WeatherService {
    func searchSuggestions() async throws -> [String] {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000 * 1)
            let jsonURL = Bundle.main.url(forResource: "world-cities", withExtension: "json")
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: jsonURL!)
            let jsonSentence = try jsonDecoder.decode([String].self, from: jsonData)
            return jsonSentence
        } catch {
            print(error)
        }
        return []
    }

    func weather(for cityName: String) async throws -> Weather {
        let randomSleepNumber = UInt64.random(in: 1...5)
        try await Task.sleep(nanoseconds: randomSleepNumber * 1_000_000_000)
        return Weather(cityName: cityName.capitalized, temperatue: getRandomTemperature(), weather: getRandomWeather())
    }

    func backgroundColor(for degrees: Double, weather: WeatherState) async throws -> LinearGradient {
        let randomSleepNumber = UInt64.random(in: 2...6)
        try await Task.sleep(nanoseconds: randomSleepNumber * 1_000_000_000)
        let tempColor = getTemperatureBackgroundColor(for: degrees)
        let weatherColor = getWeatherBackgroundColor(for: weather)
        return LinearGradient(gradient: Gradient(colors: [weatherColor, tempColor]),
                              startPoint: .bottomLeading,
                              endPoint: .topTrailing)
    }

    private func getTemperatureBackgroundColor(for degrees: Double) -> Color {
        switch degrees {
        case let x where x < 0.0: return .white
        case let x where x >= 0.0 && x <= 10: return .blue
        case let x  where  x > 10 && x <= 20: return .green
        case let x where x > 20 && x <= 25: return .orange
        case let x where x > 25: return .red
        default: return .cyan
        }
    }

    private func getWeatherBackgroundColor(for weather: WeatherState) -> Color {
        switch weather {
        case .sunny: return .yellow
        case .windy: return .gray
        case .cloudy: return .mint
        }
    }

    private func getRandomTemperature() -> Double {
        let random = Double.random(in: -20...40)
        return random.roundedToTwoDecimals()
    }

    private func getRandomWeather() -> WeatherState {
        let random = Int.random(in: 1...3)
        if random == 1 { return .sunny }
        if random == 2 { return .cloudy }
        else { return .windy }
    }
}
