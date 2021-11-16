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
    var city: String
    let dateUpdate: Date
    let weatherDesctiption: String
    let highTemperature: Int
    let lowTemperature: Int
    let windSpeed: Double
    let humidity: Int
    let sunrise: Date
    let sunset: Date
    var arrayForecast: [ForecastWeather] = []
    
    init(_ curract: Currect, _ forecast: Forecast) {
        city = curract.name
        idCity = curract.id
        temperature = curract.main.temp.toInt()
        feelsLikeTemperature = curract.main.feelsLike.toInt()
        let statusId = curract.weather.first?.id ?? 0
        statusWeaher = StatusWeather(rawValue: statusId) ?? StatusWeather.none
        dateUpdate = Date(timeIntervalSince1970: TimeInterval(curract.dt))
        weatherDesctiption = curract.weather.first?.weatherDescription ?? ""
        highTemperature = curract.main.tempMax.toInt()
        lowTemperature = curract.main.tempMin.toInt()
        windSpeed = curract.wind.speed
        humidity = curract.main.humidity
        sunrise = Date(timeIntervalSince1970: TimeInterval(curract.sys.sunrise))
        sunset = Date(timeIntervalSince1970: TimeInterval(curract.sys.sunset))
        arrayForecast = forecast.list.map { forecastList in
            let statusId = forecastList.weather.first?.id ?? 0
            let forecastWeather = ForecastWeather(time: Date(timeIntervalSince1970: TimeInterval(forecastList.dt)),
                                                  timeZone: forecast.city.timezone,
                                                  statusWeather: StatusWeather(rawValue: statusId) ?? StatusWeather.none,
                                                  temperature: forecastList.main.temp.toInt())
            return forecastWeather
        }
    }
}

struct ForecastWeather: Codable {
    let time: Date
    let timeZone: Int
    let statusWeather: StatusWeather
    let temperature: Int
}

extension Double {
    func toInt() -> Int {
        return Int(self.rounded())
    }
}
