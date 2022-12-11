//
//  WeatherForecastView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/07/16.
//

import SwiftUI

struct WeatherForecastView<ViewModel: ForecastViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            if let currentWeather = viewModel.currentWeather {
                VStack {
                    Text(currentWeather.time.toStringDate(from: "yyyy-MM-dd'T'HH:mm"))
                    
                    LottieView(filename: viewModel.weatherLottieFilename)
                    
                    Text("\(currentWeather.temperature.toTemperatureString)")
                        .font(.largeTitle)
                    
                    Text(currentWeather.wmoCode.description)
                    
                    let dailyWeathers = viewModel.dailyWeathers
                    
                    let temperatureMax = dailyWeathers[0].temperature2MMax.toTemperatureString
                    let temperatureMin = dailyWeathers[0].temperature2MMin.toTemperatureString
                    Text("\(temperatureMax) / \(temperatureMin)")
                    
                    let hourlyWeathers = viewModel.hourlyWeathers
                    let hourlyWeathersTodayAndTomorrow = hourlyWeathers
                        .filter { $0.time >= currentWeather.time }
                        .prefix(48)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(hourlyWeathersTodayAndTomorrow) { weather in
                                hourlyWeather(weather)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding()
                    
                    VStack {
                        ForEach(dailyWeathers[1...]) { weather in
                            dailyWeather(weather)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .background(Color.green.opacity(0.8))
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.loadForecast()
        }
    }
    
    private func hourlyWeather(_ weather: HourlyWeather) -> some View {
        VStack {
            Text(weather.time.toStringDate(from: "yyyy-MM-dd'T'HH:mm", to: "h a"))
            
            Text(weather.wmoCode.description)
            
            Text(weather.temperature2M.toTemperatureString)
        }
        .padding()
    }
    
    private func dailyWeather(_ weather: DailyWeather) -> some View {
        HStack {
            Text(weather.time.toStringDate(from: "yyyy-MM-dd", to: "EEEE"))
            
            Spacer()
            
            Text(weather.wmoCode.description)
            
            let temperatureMax = weather.temperature2MMax.toTemperatureString
            let temperatureMin = weather.temperature2MMin.toTemperatureString
            Text("\(temperatureMax) / \(temperatureMin)")
        }
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView(viewModel: MockForecastViewModel())
    }
}
