//
//  StatusWeather.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation

enum StatusWeather: Int {
    case thunderstorm
    case thunderstormWithRain
    case drizzle
    case rain
    case show
    case mist
    case clear
    case clouds
    case none
    
    init?(rawValue: Int) {
        switch rawValue {
            case 200...210, 222...299:
                self = .thunderstormWithRain
            case 211...221:
                self = .thunderstorm
            case 300...399:
                self = .drizzle
            case 500...599:
                self = .rain
            case 600...699:
                self = .show
            case 701, 721, 741:
                self = .mist
            case 800:
                self = .clear
            case 801...899:
                self = .clouds
            default:
                self = .none
            
        }
    }
    
    var imageName: String {
        switch self {
            case .thunderstormWithRain:
                return "cloud.bolt.rain"
            case .thunderstorm:
                return "cloud.bolt"
            case .drizzle:
                return "cloud.drizzle"
            case .rain:
                return "cloud.rain"
            case .show:
                return "cloud.snow"
            case .mist:
                return "fog"
            case .clear:
                let date = Date.now
                let calendar = Calendar.current
                let hour  = calendar.component(.hour, from: date)
                print(hour)
                if hour > 19 {
                    return "sparkles"
                } else {
                    return "sun.max"
                }
            case .clouds:
                return "cloud"
            case .none:
                return ""
        }
    }
}
