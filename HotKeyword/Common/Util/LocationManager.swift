//
//  LocationManager.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/08/01.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 위치 정보 승인 요청
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             manager.startUpdatingLocation() // 중요!
         case .restricted, .notDetermined:
             manager.requestWhenInUseAuthorization()
         case .denied:
             manager.requestWhenInUseAuthorization()
         default:
             print("GPS: Default")
         }
     }
    
    func startUpdatingLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        manager.startUpdatingLocation()
        
        if let location = manager.location {
            completion(location.coordinate)
            manager.stopUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func address(coordinate: CLLocationCoordinate2D, locale: Locale = Locale(identifier: "Ko-kr"), completion: @escaping (CLPlacemark) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: { placemarks, error in
            if let placemark = placemarks,
               let address = placemark.last {
                completion(address)
            }
        })
    }
}
