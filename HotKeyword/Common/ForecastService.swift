//
//  ForecastService.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/07/17.
//

import Foundation

enum ForecastService {
    case forecast
}

extension ForecastService: Service {
    var baseURL: String { "https://api.open-meteo.com" }
    
    var path: String {
        switch self {
        case .forecast: return "/v1/forecast"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .forecast:
            return [
                // FIXME: 현재위치로 불러오기
                "latitude" : "37.4792672",
                "longitude" : "126.9526967",
                "hourly" : "temperature_2m,relativehumidity_2m,weathercode",
                "daily" : "weathercode,temperature_2m_max,temperature_2m_min",
                "current_weather" : "true",
                "timezone" : "Asia/Tokyo"
            ]
        }
    }
    
    var method: ServiceMethod {
        switch self {
        case .forecast: return .get
        }
    }
}
