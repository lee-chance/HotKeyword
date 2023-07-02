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
        GeometryReader { geometry in
            LinearGradient(
                colors: [.blue.opacity(0.2), .blue.opacity(0.5)],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            if let currentWeather = viewModel.currentWeather {
                ScrollView {
                    VStack {
                        Text(viewModel.currentAddress)
                            .font(.largeTitle)
                        
                        HStack {
                            Text(currentWeather.time.toStringDate(from: "yyyy-MM-dd'T'HH:mm", to: "MM월 dd일 EEEE HH:mm"))
                            
                            Image(systemName: "arrow.clockwise")
                        }
                        .onTapGesture {
                            viewModel.loadForecast()
                        }
                        
                        let lottieSize = geometry.size.width * 2 / 5
                        
                        LottieView(filename: viewModel.weatherLottieFilename)
                            .frame(width: lottieSize, height: lottieSize)
                        
                        Text("\(currentWeather.temperature.toTemperatureString)")
                            .font(.largeTitle)
                        
                        Text(currentWeather.wmoCode.description)
                        
                        let dailyWeathers = viewModel.dailyWeathers
                        
                        let temperatureMax = dailyWeathers[0].temperature2MMax.toTemperatureString
                        let temperatureMin = dailyWeathers[0].temperature2MMin.toTemperatureString
                        Text("\(temperatureMax) / \(temperatureMin)")
                        
                        let hourlyWeathers = viewModel.hourlyWeathers
                        let hourlyWeathersTodayAndTomorrow = hourlyWeathers
                            .filter { $0.time > currentWeather.time }
                            .prefix(48)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(hourlyWeathersTodayAndTomorrow) { weather in
                                    hourlyWeather(weather)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(16)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        
                        VStack {
                            ForEach(dailyWeathers) { weather in
                                dailyWeather(weather)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 48)
                }
                .padding(.top, 1)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            viewModel.loadForecast()
        }
    }
    
    private func hourlyWeather(_ weather: HourlyWeather) -> some View {
        VStack {
            Text(weather.time.toStringDate(from: "yyyy-MM-dd'T'HH:mm", to: "a h시"))
            
            let hour = Calendar.current.component(.hour, from: weather.time.toDate(format: "yyyy-MM-dd'T'HH:mm") ?? Date())
            let dayOrNight = 6 <= hour && hour <= 18 ? "day" : "night"
            LottieView(filename: "weather-\(dayOrNight)-\(weather.wmoCode.imageSuffixName).json")
                .frame(width: 50, height: 50)
            
            Text(weather.temperature2M.toTemperatureString)
        }
        .padding()
    }
    
    private func dailyWeather(_ weather: DailyWeather) -> some View {
        HStack {
            let weekday = Calendar.current.component(.weekday, from: weather.time.toDate(format: "yyyy-MM-dd") ?? Date())
            
            Text(weather.time.toStringDate(from: "yyyy-MM-dd", to: "EEEE"))
                .bold()
                .foregroundColor(weekday == 1 ? .red : weekday == 7 ? .blue : nil)
            
            Spacer()
            
            let hour = Calendar.current.component(.hour, from: weather.time.toDate(format: "yyyy-MM-dd'T'HH:mm") ?? Date())
            let dayOrNight = 6 <= hour && hour <= 18 ? "day" : "night"
            LottieView(filename: "weather-\(dayOrNight)-\(weather.wmoCode.imageSuffixName).json")
                .frame(width: 50, height: 50)
            
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
