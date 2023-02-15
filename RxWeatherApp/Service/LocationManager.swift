//
//  LocationManager.swift
//  Weather App
//
//  Created by Антон Кочетков on 12.11.2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    typealias getLocation = (CLLocation) -> Void
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    private var completion: getLocation?
    
    var isAuthorization: Bool {
        switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                return true
            default:
                return false
        }
    }
    
    func getLocation(completion: @escaping getLocation) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}
