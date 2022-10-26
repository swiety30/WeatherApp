//
//  ContentView.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//

import SwiftUI

struct WeatherView: View {
    var weather: Weather
    @ObservedObject var model: WeatherModel
    @EnvironmentObject var degreeModel: DegreeModel
    @State var backgroundColor: LinearGradient = LinearGradient(colors: [.white], startPoint: .center, endPoint: .center)
    @State var formattedDegrees: String?
    @State var isFetchingImage: Bool = true
    var body: some View {
        HStack {
            VStack {
                Text(weather.cityName)
                    .font(.title)
                Text(weather.weather.rawValue)
                    .font(.title3)
            }
            Spacer()
            Text(degreeModel.formatDegree(weather.temperatue))
                .font(.largeTitle)
        }
        .padding()
        .onAppear {
            isFetchingImage = true
            Task {
                backgroundColor = try await model.image(for: weather)
                isFetchingImage = false

            }
        }
        .background(
            BackgroundView(isFetching: $isFetchingImage,
                           backgroundColor: backgroundColor)
        )
        .cornerRadius(20)
    }

    struct BackgroundView: View {
        @Binding var isFetching: Bool
        var backgroundColor: LinearGradient
        var body: some View {
            if isFetching {
                ProgressView()
            } else {
                backgroundColor
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: Weather(cityName: "Zgorzelec",
                                     temperatue: 30,
                                     weather: .cloudy),
                    model: WeatherModel())
    }
}
