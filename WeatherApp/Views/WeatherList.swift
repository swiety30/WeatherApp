//
//  WeatherList.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//

import SwiftUI

struct WeatherList: View {
    @ObservedObject var weatherModel: WeatherModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var searchHints: [String] = []
    @Environment(\.dismissSearch) var dismissSearch

    var body: some View {
        NavigationView {
            WeatherListView(weatherModel: weatherModel)
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Look for a city..") {
            WeatherSuggestionsView(suggestions: $searchHints, searchText: $searchText)
        }
        .onSubmit(of: .search) {
            dismissSearch()
            if !isSearching {
                Task {
                    isSearching = true
                    let searchPhrase = searchText
                    searchText = ""
                    do {
                         try await weatherModel.weather(for: searchPhrase)
                    } catch {
                        print("Error happened")
                    }
                    isSearching = false
                }
            }
        }
        .onAppear {
            Task {
                searchHints = try await weatherModel.searchHints()
            }
        }
    }

    struct WeatherListView: View {
        @ObservedObject var weatherModel: WeatherModel
        var body: some View {
            List {
                ForEach(weatherModel.weathers) { weather in
                    WeatherView(weather: weather,
                                model: weatherModel)
                        .swipeActions {
                            Button(action: {
                                withAnimation {
                                    weatherModel.remove(weather: weather)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)

                            }
                            .tint(.red)
                        }
                }
                .listRowSeparator(.hidden)
                .background(.clear)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem() {
                    WeatherTemperatureMenu(weatherModel: weatherModel)
                }
            }
            .navigationTitle("Weather")
        }

    }
}

struct WeatherList_Previews: PreviewProvider {
    static var previews: some View {
        WeatherList(weatherModel: WeatherModel())
    }
}
