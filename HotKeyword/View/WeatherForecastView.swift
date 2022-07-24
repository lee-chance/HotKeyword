//
//  WeatherForecastView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/07/16.
//

import SwiftUI

struct WeatherForecastView: View {
    @StateObject var viewModel: ForecastViewModel
    
    var body: some View {
        ZStack {
            if viewModel.currentWeather != nil {
                LottieView(filename: viewModel.weatherLottieFilename) { b in
                    print(b)
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.loadForecast()
        }
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView(viewModel: ForecastViewModel())
    }
}
