//
//  Forecast.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/07/17.
//

// Document: https://open-meteo.com/en/docs

import Foundation


// MARK: - Forecast

struct Forecast: Codable {
    let latitude: Double
    let longitude: Double
    let generationtimeMS: Double
    let utcOffsetSeconds: Int
    let elevation: Int
    let currentWeather: CurrentWeather
    let daily: Daily
    let dailyUnits: DailyUnits
    let hourly: Hourly
    let hourlyUnits: HourlyUnits

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case elevation
        case currentWeather = "current_weather"
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
    }
}


// MARK: - CurrentWeather

struct CurrentWeather: Codable {
    let temperature: Double
    let windspeed: Double
    let winddirection: Int
    let weathercode: Int
    let time: String
    
    var wmoCode: WMOCode { WMOCode(rawValue: weathercode) ?? .clearSky }
}


// MARK: - Daily

struct Daily: Codable {
    let time: [String]
    let weathercode: [Int]
    let temperature2MMax: [Double]
    let temperature2MMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time, weathercode
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}


// MARK: - DailyUnits

struct DailyUnits: Codable {
    let time: String
    let weathercode: String
    let temperature2MMax: String
    let temperature2MMin: String

    enum CodingKeys: String, CodingKey {
        case time, weathercode
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}


// MARK: - Hourly

struct Hourly: Codable {
    let time: [String]
    let temperature2M: [Double?]
    let relativehumidity2M: [Int?]
    let weathercode: [Int?]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativehumidity2M = "relativehumidity_2m"
        case weathercode
    }
}


// MARK: - HourlyUnits

struct HourlyUnits: Codable {
    let time: String
    let temperature2M: String
    let relativehumidity2M: String
    let weathercode: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativehumidity2M = "relativehumidity_2m"
        case weathercode
    }
}


// MARK: - WMO Code

enum WMOCode: Int, CustomStringConvertible {
    case clearSky = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case rimeFog = 48 // 상고대 (나무서리?)
    case lightDrizzle = 51
    case moderateDrizzle = 53
    case denseDrizzle = 55
    case lightFreezingDrizzle = 56
    case denseFreezingDrizzle = 57
    case slightRain = 61
    case moderateRain = 63
    case heavyIntensityRain = 65
    case lightFreezingRain = 66
    case heavyIntensityFreezingRain = 67
    case slightSnowFall = 71
    case moderateSnowFall = 73
    case heavyIntensitySnowFall = 75
    case snowGrains = 77
    case slightRainShowers = 80
    case moderateRainShowers = 81
    case violentRainShowers = 82
    case slightSnowShowers = 85
    case heavySnowShowers = 86
    // Thunderstorm forecast with hail is only available in Central Europe
    case moderateThunderstorm = 95
    case slightThunderstorm = 96
    case heavyHailThunderstorm = 99
    
    var description: String {
        switch self {
        case .clearSky:
            return "맑음"
        case .mainlyClear:
            return "대부분 맑음"
        case .partlyCloudy:
            return "구름"
        case .overcast:
            return "흐림"
        case .fog:
            return "안개"
        case .rimeFog:
            return "상고대"
        case .lightDrizzle:
            return "약한 이슬비"
        case .moderateDrizzle:
            return "이슬비"
        case .denseDrizzle:
            return "강한 이슬비"
        case .lightFreezingDrizzle:
            return "약한 진눈깨비"
        case .denseFreezingDrizzle:
            return "강한 진눈깨비"
        case .slightRain:
            return "가랑비"
        case .moderateRain:
            return "비"
        case .heavyIntensityRain:
            return "폭우"
        case .lightFreezingRain:
            return "우빙"
        case .heavyIntensityFreezingRain:
            return "강한 우빙"
        case .slightSnowFall:
            return "가랑눈"
        case .moderateSnowFall:
            return "눈"
        case .heavyIntensitySnowFall:
            return "폭설"
        case .snowGrains:
            return "싸락눈"
        case .slightRainShowers:
            return "약한 소나기"
        case .moderateRainShowers:
            return "소나기"
        case .violentRainShowers:
            return "집중호우"
        case .slightSnowShowers:
            return "약한 소낙눈"
        case .heavySnowShowers:
            return "소낙눈"
        case .moderateThunderstorm:
            return "Moderate Thunderstorm"
        case .slightThunderstorm:
            return "Slight Thunderstorm"
        case .heavyHailThunderstorm:
            return "Heavy Hail Thunderstorm"
        }
    }
}
