//
//  WeatherTemperatureMenu.swift
//  WeatherApp
//
//  Created by Paweł Świątek on 31/07/2022.
//
import SwiftUI

struct WeatherTemperatureMenu: View {
    @ObservedObject var weatherModel: WeatherModel
    @EnvironmentObject var degreeModel: DegreeModel
    var body: some View {
        Menu {
            ForEach(Degrees.allCases) { degree in
                Button {
                    degreeModel.changeConventer(to: degree)
                } label: {
                    HStack {
                        Text(degree.rawValue.capitalized)
                        if degreeModel.conventer == degree {
                            Image(systemName: "arrow.up.arrow.down.square")
                        }
                    }
                }
            }
        } label: {
            switch degreeModel.conventer {
            case .celsius: Text("C")
            case .fahrenheit: Text("F")
            case .kelvin: Text("K")
            }
        }
    }
}
