//
//  ForecastViewModel.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/07/18.
//

import Foundation

final class ForecastViewModel: ObservableObject {
    private let provider = ServiceProvider<ForecastService>()
    
    func loadForecast() {
        provider.get(service: .forecast, decodeType: Forecast.self) { result in
            switch result {
            case .success(let response):
                print("success: \(response.currentWeather.wmoCode.description)")
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}
