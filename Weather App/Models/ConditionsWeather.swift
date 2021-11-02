//
//  ConditionsWeather.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation


enum ConditionsWeather {
    case highLow(Int, Int)
    case wind(Double)
    case humidity(Int)
    
    var imageName: String {
        switch self {
            case .highLow:
                return "thermometer"
            case .wind:
                return "wind"
            case .humidity:
                return "humidity.fill"
        }
    }
    
    var nameLabel: String {
        switch self {
            case .highLow:
                return "High/Low"
            case .wind:
                return "Wind"
            case .humidity:
                return "Humidity"
        }
    }
    
    var stringDataView: String {
        switch self {
            case .highLow(let high, let low):
                return "\(high)/\(low)"
            case .wind(let speed):
                return "\(speed) m/s"
            case .humidity(let hum):
                return "\(hum)%"
        }
    }
}
