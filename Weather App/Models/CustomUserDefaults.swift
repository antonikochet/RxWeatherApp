//
//  UserDefaults.swift
//  Weather App
//
//  Created by Антон Кочетков on 09.11.2021.
//

import Foundation

class CustomUserDefaults {

    static var arrayOfCities: [String] {
        get {
            
            return UserDefaults.standard.stringArray(forKey: NameOfValue.arrayOfCities.rawValue) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: NameOfValue.arrayOfCities.rawValue)
        }
    }
    
    static var firstDataCity: ViewWeather? {
        get {
            guard let data = UserDefaults.standard.value(forKey: NameOfValue.firstDataCity.rawValue) as? Data else { return nil}
            return try? PropertyListDecoder().decode(ViewWeather.self, from: data)
        }
        set {
            let encodeData = try? PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(encodeData, forKey: NameOfValue.firstDataCity.rawValue)
        }
    }

    
    enum NameOfValue: String {
        case arrayOfCities
        case firstDataCity
    }

}
    
