//
//  ForecastViewModel.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/07/18.
//

import Foundation

final class ForecastViewModel: ObservableObject {
    private let provider = ServiceProvider<ForecastService>()
    
    @Published var currentWeather: CurrentWeather?
    
    var weatherLottieFilename: String {
        "weather-\(dayOrNight)-\(currentWeatherImageSuffixName).json"
    }
    
    private var dayOrNight: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6...18: return "day"
        default: return "night"
        }
    }
    
    private var currentWeatherImageSuffixName: String {
        currentWeather?.wmoCode.imageSuffixName ?? ""
    }
    
    func loadForecast() {
        provider.get(service: .forecast, decodeType: Forecast.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.currentWeather = response.currentWeather
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}
