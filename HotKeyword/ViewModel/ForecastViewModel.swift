//
//  ForecastViewModel.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/07/18.
//

import Foundation
import CoreLocation

protocol ForecastViewModelProtocol: ObservableObject {
    var currentWeather: CurrentWeather? { get set }
    var dailyWeathers: [DailyWeather] { get set }
    var hourlyWeathers: [HourlyWeather] { get set }
    
    func loadForecast()
}

extension ForecastViewModelProtocol {
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
}

final class MockForecastViewModel: ForecastViewModelProtocol {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeathers: [DailyWeather] = []
    @Published var hourlyWeathers: [HourlyWeather] = []
    
    func loadForecast() {
        let jsonData = sampleWeahterJSON.data(using: .utf8)
        do {
            guard let jsonData = jsonData else { return }
            let response = try JSONDecoder().decode(Forecast.self, from: jsonData)
            currentWeather = response.currentWeather
            dailyWeathers = response.dailyWeathers
            hourlyWeathers = response.hourlyWeathers
        } catch let error {
            print("error: \(error)")
        }
    }
}

final class ForecastViewModel: ForecastViewModelProtocol {
    private let provider = ServiceProvider<ForecastService>()
    
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeathers: [DailyWeather] = []
    @Published var hourlyWeathers: [HourlyWeather] = []
    
    func loadForecast() {
        LocationManager().startUpdatingLocation { [weak self] coordinate in
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            
            LocationManager().address(coordinate: coordinate) { address in
                print(address.locality ?? address.subLocality ?? address.country ?? "대한민국")
            }
            
            self?.provider.get(service: .forecast(lat: latitude, lng: longitude), decodeType: Forecast.self) { result in
                switch result {
                case .success(let response):
                    self?.currentWeather = response.currentWeather
                    self?.dailyWeathers = response.dailyWeathers
                    self?.hourlyWeathers = response.hourlyWeathers
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }
}



extension MockForecastViewModel {
    var sampleWeahterJSON: String { """
{
  "generationtime_ms" : 1.0449886322021484,
  "daily_units" : {
    "temperature_2m_max" : "°C",
    "temperature_2m_min" : "°C",
    "time" : "iso8601",
    "weathercode" : "wmo code"
  },
  "daily" : {
    "temperature_2m_max" : [
      4.7999999999999998,
      5.7000000000000002,
      3.3999999999999999,
      -4.0999999999999996,
      0.10000000000000001,
      -5.7000000000000002,
      -4.5
    ],
    "temperature_2m_min" : [
      -5.2999999999999998,
      -6.9000000000000004,
      -6.2999999999999998,
      -11.1,
      -11.4,
      -11.9,
      -11.699999999999999
    ],
    "time" : [
      "2022-12-11",
      "2022-12-12",
      "2022-12-13",
      "2022-12-14",
      "2022-12-15",
      "2022-12-16",
      "2022-12-17"
    ],
    "weathercode" : [
      1,
      53,
      75,
      71,
      71,
      71,
      71
    ]
  },
  "longitude" : 127,
  "elevation" : 72,
  "latitude" : 37.25,
  "timezone_abbreviation" : "JST",
  "current_weather" : {
    "temperature" : 4.7999999999999998,
    "windspeed" : 12,
    "time" : "2022-12-11T14:00",
    "winddirection" : 311,
    "weathercode" : 0
  },
  "hourly_units" : {
    "temperature_2m" : "°C",
    "weathercode" : "wmo code",
    "time" : "iso8601",
    "relativehumidity_2m" : "%"
  },
  "hourly" : {
    "temperature_2m" : [
      -1.8999999999999999,
      -2.2000000000000002,
      -2.7000000000000002,
      -3,
      -3.3999999999999999,
      -4,
      -4.5,
      -5,
      -5.2999999999999998,
      -3.8999999999999999,
      -1.3,
      1.2,
      3.2999999999999998,
      4.4000000000000004,
      4.7999999999999998,
      4.7999999999999998,
      4.2000000000000002,
      1.7,
      -0.5,
      -1.8,
      -2.7999999999999998,
      -3.6000000000000001,
      -3.6000000000000001,
      -4,
      -4.5,
      -4.2000000000000002,
      -4,
      -6.0999999999999996,
      -6.5,
      -5.9000000000000004,
      -6.2999999999999998,
      -6.9000000000000004,
      -6.4000000000000004,
      -5,
      -3,
      -0.69999999999999996,
      1.3999999999999999,
      3.5,
      4.7999999999999998,
      5.5999999999999996,
      5.7000000000000002,
      4.4000000000000004,
      3.6000000000000001,
      3.2999999999999998,
      3.6000000000000001,
      3.7999999999999998,
      2.5,
      3.5,
      3.3999999999999999,
      3.3999999999999999,
      3.2999999999999998,
      3,
      2.5,
      2.1000000000000001,
      1.6000000000000001,
      0.59999999999999998,
      -0.59999999999999998,
      -0.40000000000000002,
      0.40000000000000002,
      0.10000000000000001,
      -0.90000000000000002,
      -0.80000000000000004,
      0.20000000000000001,
      0.40000000000000002,
      0.20000000000000001,
      -1.1000000000000001,
      -2.2000000000000002,
      -3.1000000000000001,
      -3.8999999999999999,
      -5,
      -5.7999999999999998,
      -6.2999999999999998,
      -6.7000000000000002,
      -8.3000000000000007,
      -9.3000000000000007,
      -9.9000000000000004,
      -10.4,
      -10.699999999999999,
      -11,
      -11.1,
      -11.1,
      -10,
      -8.4000000000000004,
      -7,
      -5.7999999999999998,
      -5,
      -4.4000000000000004,
      -4.0999999999999996,
      -7,
      -7.0999999999999996,
      -7.5,
      -8,
      -8.6999999999999993,
      -9.5,
      -10,
      -10.5,
      -11,
      -11.199999999999999,
      -11.4,
      -11.4,
      -11.199999999999999,
      -10.9,
      -10.4,
      -10,
      -9.5,
      -8.5999999999999996,
      -7.5,
      -6.2000000000000002,
      -4.5,
      -3.2000000000000002,
      -2,
      -0.80000000000000004,
      -0.20000000000000001,
      0.10000000000000001,
      -0.20000000000000001,
      -1.3,
      -2.8999999999999999,
      -4.7999999999999998,
      -5.7000000000000002,
      -6.2999999999999998,
      -7.2000000000000002,
      -7.9000000000000004,
      -8.5999999999999996,
      -9.5,
      -10.300000000000001,
      -11,
      -11.699999999999999,
      -11.9,
      -11.9,
      -11.4,
      -10.5,
      -9.1999999999999993,
      -7.7000000000000002,
      -6.9000000000000004,
      -6.2000000000000002,
      -5.7000000000000002,
      -5.7999999999999998,
      -6.2000000000000002,
      -6.7999999999999998,
      -7.2999999999999998,
      -7.9000000000000004,
      -8.5999999999999996,
      -8.6999999999999993,
      -8.6999999999999993,
      -8.5999999999999996,
      -8.5,
      -8.3000000000000007,
      -8.3000000000000007,
      -8.8000000000000007,
      -9.4000000000000004,
      -9.9000000000000004,
      -9.9000000000000004,
      -9.5999999999999996,
      -8.8000000000000007,
      -7.5999999999999996,
      -6.0999999999999996,
      -4.5999999999999996,
      -4.5,
      -4.7999999999999998,
      -5.2999999999999998,
      -5.5999999999999996,
      -6,
      -6.7000000000000002,
      -7.7000000000000002,
      -8.9000000000000004,
      -10.300000000000001,
      -11,
      -11.699999999999999
    ],
    "weathercode" : [
      1,
      0,
      0,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      0,
      1,
      2,
      3,
      3,
      2,
      1,
      1,
      2,
      2,
      1,
      1,
      2,
      51,
      53,
      1,
      1,
      2,
      2,
      3,
      2,
      3,
      2,
      3,
      51,
      53,
      2,
      2,
      2,
      3,
      73,
      75,
      63,
      53,
      51,
      73,
      71,
      1,
      1,
      1,
      1,
      71,
      71,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      2,
      2,
      2,
      2,
      0,
      0,
      0,
      0,
      0,
      0,
      2,
      2,
      2,
      1,
      1,
      1,
      2,
      2,
      2,
      71,
      71,
      71,
      3,
      3,
      3,
      2,
      2,
      2,
      0,
      0,
      0,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      3,
      3,
      3,
      3,
      3,
      3,
      71,
      71,
      71,
      71,
      71,
      71,
      3,
      3,
      3,
      2,
      2,
      2,
      3,
      3,
      3,
      71,
      71,
      71,
      3,
      3,
      3,
      0,
      0,
      0,
      0,
      0
    ],
    "time" : [
      "2022-12-11T00:00",
      "2022-12-11T01:00",
      "2022-12-11T02:00",
      "2022-12-11T03:00",
      "2022-12-11T04:00",
      "2022-12-11T05:00",
      "2022-12-11T06:00",
      "2022-12-11T07:00",
      "2022-12-11T08:00",
      "2022-12-11T09:00",
      "2022-12-11T10:00",
      "2022-12-11T11:00",
      "2022-12-11T12:00",
      "2022-12-11T13:00",
      "2022-12-11T14:00",
      "2022-12-11T15:00",
      "2022-12-11T16:00",
      "2022-12-11T17:00",
      "2022-12-11T18:00",
      "2022-12-11T19:00",
      "2022-12-11T20:00",
      "2022-12-11T21:00",
      "2022-12-11T22:00",
      "2022-12-11T23:00",
      "2022-12-12T00:00",
      "2022-12-12T01:00",
      "2022-12-12T02:00",
      "2022-12-12T03:00",
      "2022-12-12T04:00",
      "2022-12-12T05:00",
      "2022-12-12T06:00",
      "2022-12-12T07:00",
      "2022-12-12T08:00",
      "2022-12-12T09:00",
      "2022-12-12T10:00",
      "2022-12-12T11:00",
      "2022-12-12T12:00",
      "2022-12-12T13:00",
      "2022-12-12T14:00",
      "2022-12-12T15:00",
      "2022-12-12T16:00",
      "2022-12-12T17:00",
      "2022-12-12T18:00",
      "2022-12-12T19:00",
      "2022-12-12T20:00",
      "2022-12-12T21:00",
      "2022-12-12T22:00",
      "2022-12-12T23:00",
      "2022-12-13T00:00",
      "2022-12-13T01:00",
      "2022-12-13T02:00",
      "2022-12-13T03:00",
      "2022-12-13T04:00",
      "2022-12-13T05:00",
      "2022-12-13T06:00",
      "2022-12-13T07:00",
      "2022-12-13T08:00",
      "2022-12-13T09:00",
      "2022-12-13T10:00",
      "2022-12-13T11:00",
      "2022-12-13T12:00",
      "2022-12-13T13:00",
      "2022-12-13T14:00",
      "2022-12-13T15:00",
      "2022-12-13T16:00",
      "2022-12-13T17:00",
      "2022-12-13T18:00",
      "2022-12-13T19:00",
      "2022-12-13T20:00",
      "2022-12-13T21:00",
      "2022-12-13T22:00",
      "2022-12-13T23:00",
      "2022-12-14T00:00",
      "2022-12-14T01:00",
      "2022-12-14T02:00",
      "2022-12-14T03:00",
      "2022-12-14T04:00",
      "2022-12-14T05:00",
      "2022-12-14T06:00",
      "2022-12-14T07:00",
      "2022-12-14T08:00",
      "2022-12-14T09:00",
      "2022-12-14T10:00",
      "2022-12-14T11:00",
      "2022-12-14T12:00",
      "2022-12-14T13:00",
      "2022-12-14T14:00",
      "2022-12-14T15:00",
      "2022-12-14T16:00",
      "2022-12-14T17:00",
      "2022-12-14T18:00",
      "2022-12-14T19:00",
      "2022-12-14T20:00",
      "2022-12-14T21:00",
      "2022-12-14T22:00",
      "2022-12-14T23:00",
      "2022-12-15T00:00",
      "2022-12-15T01:00",
      "2022-12-15T02:00",
      "2022-12-15T03:00",
      "2022-12-15T04:00",
      "2022-12-15T05:00",
      "2022-12-15T06:00",
      "2022-12-15T07:00",
      "2022-12-15T08:00",
      "2022-12-15T09:00",
      "2022-12-15T10:00",
      "2022-12-15T11:00",
      "2022-12-15T12:00",
      "2022-12-15T13:00",
      "2022-12-15T14:00",
      "2022-12-15T15:00",
      "2022-12-15T16:00",
      "2022-12-15T17:00",
      "2022-12-15T18:00",
      "2022-12-15T19:00",
      "2022-12-15T20:00",
      "2022-12-15T21:00",
      "2022-12-15T22:00",
      "2022-12-15T23:00",
      "2022-12-16T00:00",
      "2022-12-16T01:00",
      "2022-12-16T02:00",
      "2022-12-16T03:00",
      "2022-12-16T04:00",
      "2022-12-16T05:00",
      "2022-12-16T06:00",
      "2022-12-16T07:00",
      "2022-12-16T08:00",
      "2022-12-16T09:00",
      "2022-12-16T10:00",
      "2022-12-16T11:00",
      "2022-12-16T12:00",
      "2022-12-16T13:00",
      "2022-12-16T14:00",
      "2022-12-16T15:00",
      "2022-12-16T16:00",
      "2022-12-16T17:00",
      "2022-12-16T18:00",
      "2022-12-16T19:00",
      "2022-12-16T20:00",
      "2022-12-16T21:00",
      "2022-12-16T22:00",
      "2022-12-16T23:00",
      "2022-12-17T00:00",
      "2022-12-17T01:00",
      "2022-12-17T02:00",
      "2022-12-17T03:00",
      "2022-12-17T04:00",
      "2022-12-17T05:00",
      "2022-12-17T06:00",
      "2022-12-17T07:00",
      "2022-12-17T08:00",
      "2022-12-17T09:00",
      "2022-12-17T10:00",
      "2022-12-17T11:00",
      "2022-12-17T12:00",
      "2022-12-17T13:00",
      "2022-12-17T14:00",
      "2022-12-17T15:00",
      "2022-12-17T16:00",
      "2022-12-17T17:00",
      "2022-12-17T18:00",
      "2022-12-17T19:00",
      "2022-12-17T20:00",
      "2022-12-17T21:00",
      "2022-12-17T22:00",
      "2022-12-17T23:00"
    ],
    "relativehumidity_2m" : [
      68,
      64,
      62,
      64,
      63,
      66,
      69,
      72,
      76,
      73,
      59,
      52,
      49,
      48,
      47,
      47,
      50,
      70,
      71,
      70,
      70,
      72,
      64,
      62,
      63,
      57,
      54,
      68,
      69,
      61,
      62,
      69,
      73,
      78,
      69,
      63,
      60,
      66,
      72,
      77,
      79,
      84,
      87,
      93,
      92,
      80,
      80,
      79,
      77,
      77,
      77,
      78,
      79,
      78,
      89,
      89,
      81,
      74,
      69,
      78,
      92,
      94,
      94,
      87,
      85,
      88,
      76,
      73,
      76,
      78,
      77,
      84,
      73,
      69,
      67,
      67,
      69,
      71,
      72,
      73,
      73,
      69,
      68,
      67,
      66,
      66,
      66,
      66,
      61,
      65,
      69,
      71,
      72,
      73,
      75,
      77,
      79,
      80,
      79,
      79,
      79,
      78,
      77,
      76,
      75,
      75,
      77,
      81,
      85,
      86,
      86,
      86,
      87,
      89,
      89,
      85,
      78,
      71,
      68,
      67,
      64,
      61,
      57,
      52,
      49,
      46,
      43,
      41,
      38,
      37,
      38,
      40,
      43,
      44,
      44,
      45,
      48,
      53,
      59,
      62,
      65,
      69,
      74,
      80,
      86,
      87,
      87,
      87,
      87,
      88,
      88,
      87,
      85,
      83,
      81,
      78,
      76,
      77,
      80,
      80,
      74,
      65,
      55,
      51,
      48,
      46,
      47,
      50
    ]
  },
  "timezone" : "Asia/Tokyo",
  "utc_offset_seconds" : 32400
}
"""
    }
}
