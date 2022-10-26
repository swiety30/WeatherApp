//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//

import SwiftUI

@main
struct WeatherApp: App {    
    var body: some Scene {
        WindowGroup {
            WeatherList(weatherModel: WeatherModel())
                .environmentObject(DegreeModel())
        }
    }
}
