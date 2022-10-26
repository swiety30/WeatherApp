//
//  ContentView.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//

// https://datahub.io/core/world-cities#resource-world-cities
import SwiftUI

struct WeatherSuggestionsView: View {
    @Binding var suggestions: [String]
    @Binding var searchText: String
    var body: some View {
        if searchText.count >= 2 {
            let suggestions = suggestions.filter { $0.contains(searchText) }
            if suggestions.count > 0 {
                ForEach(suggestions, id: \.self) { hint in
                    Label(hint, image: "")
                        .searchCompletion(hint)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct WeatherSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: Weather(cityName: "Zgorzelec",
                                     temperatue: 30,
                                     weather: .cloudy),
                    model: WeatherModel())
    }
}
