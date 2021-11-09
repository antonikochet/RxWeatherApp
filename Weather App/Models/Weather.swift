//
//  Weather.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation

struct ViewWeather: Codable {
    let temperature: Int
    let feelsLikeTemperature: Int
    let statusWeaher: StatusWeather
    let idCity: Int
    let city: String
    let dateUpdate: Date
    let weatherDesctiption: String
    let highTemperature: Int
    let lowTemperature: Int
    let windSpeed: Double
    let humidity: Int
    
    init(_ weather: CurrectWeather) {
        city = weather.name
        idCity = weather.id
        temperature = weather.main.temp.toInt()
        feelsLikeTemperature = weather.main.feelsLike.toInt()
        let statusId = weather.weather.first?.id ?? 0
        statusWeaher = StatusWeather(rawValue: statusId) ?? StatusWeather.none
        dateUpdate = Date(timeIntervalSince1970: TimeInterval(weather.dt))
        weatherDesctiption = weather.weather.first?.weatherDescription ?? ""
        highTemperature = weather.main.tempMax.toInt()
        lowTemperature = weather.main.tempMin.toInt()
        windSpeed = weather.wind.speed
        humidity = weather.main.humidity
    }
}


extension Double {
    func toInt() -> Int {
        return Int(self.rounded())
    }
}
