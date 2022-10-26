//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//

import SwiftUI
import Combine

@MainActor
class WeatherModel: ObservableObject {
    @Published private(set) var weathers: [Weather] = []
    private let timer: AsyncTimer
    private let weatherService: WeatherService

    init(timer: AsyncTimer = AsyncTimer(),
         weatherService: WeatherService = WeatherService()) {
        self.timer = timer
        self.weatherService = weatherService
    }

    func searchHints() async throws -> [String] {
        try await weatherService.searchSuggestions()
    }
    
    func weather(for cityName: String) async throws {
        if let weather = weathers.first(where: { $0.cityName == cityName }) {
            bumpWeather(weather)
        } else {
            let weather = try await weatherService.weather(for: cityName)
            append(weather: weather)
        }
    }

    func remove(weather: Weather) {
        let weatherCityName = weather.cityName
        timer.cancelTimmer(for: weatherCityName)
        weathers.removeAll(where: { $0.cityName == weatherCityName })
    }

    // It is "fetching" colors for given temperature/weather state
    func image(for weather: Weather) async throws -> LinearGradient {
        return try await weatherService.backgroundColor(for: weather.temperatue, weather: weather.weather)
    }
}

private extension WeatherModel {
    func append(weather: Weather) {
        weathers.insert(weather, at: 0)
        Task {
            for await _ in timer.start(for: weather.cityName, every: 60) {
                let weather = try await weatherService.weather(for: weather.cityName)
                update(weather: weather)
            }
        }
    }

    func update(weather: Weather) {
        if let weatherIndex = weathers.firstIndex(where: { $0.cityName == weather.cityName }) {
            weathers[weatherIndex] = weather
        }
    }

    func bumpWeather(_ weather: Weather) {
        let weatherCityName = weather.cityName
        timer.cancelTimmer(for: weatherCityName)
        weathers.removeAll(where: { $0.cityName == weatherCityName })
        append(weather: weather)
    }
}
