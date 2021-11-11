//
//  ApiManager.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation

typealias currectWeather = (AnswerServer) -> Void

typealias GetWeather = (Currect?, Forecast?, ErrorServer?) -> Void

class ApiManager {
    
    private var lang: Lang
    private var units: Units
    private let apiKey = "4d5555216cc6eafafdb25aeee2050261"
    private let session = URLSession(configuration: .default)
    private let dispatchGroup = DispatchGroup()
    private var baseUrlComponents: URLComponents = {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.openweathermap.org"
        url.path = "/data/2.5/"
        return url
    }()
    
    init() {
        self.lang = Lang.ru
        self.units = Units.metric
    }
    
    init(lang: Lang, units: Units) {
        self.lang = lang
        self.units = units
    }
    
    func getWeather(for typeGetting: TypeGettingCurrectWeather, countTimestamps: Int, completion: @escaping GetWeather) {
        let currectUrlComponemts = URLComponemtsCurrect(typeGetting)
        let forecastUrlComponemts = URLComponemtsForecast(typeGetting, countTimestamps: countTimestamps)
        var currect: Currect?
        var forecast: Forecast?
        var error: ErrorServer?
        
        dispatchGroup.enter()
        request(forUrl: currectUrlComponemts, type: Currect.self) { answer in
            switch answer {
                case .success(let GettingCurrect):
                    currect = (GettingCurrect as! Currect)
                case .failure(let GettingError):
                    error = GettingError
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        request(forUrl: forecastUrlComponemts, type: Forecast.self) { answer in
            switch answer {
                case .success(let GettingForecast):
                    forecast = (GettingForecast as! Forecast)
                case .failure(let GettingError):
                    if error == nil {
                        error = GettingError
                    }
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(currect, forecast, error)
        }
        
    }
    
    private func URLComponemtsCurrect(_ typeGetting: TypeGettingCurrectWeather) -> URLComponents {
        var urlComponemts = baseUrlComponents
        urlComponemts.path += "weather"
        urlComponemts.queryItems = typeGetting.generateURLQueryItem() + [
                                    URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: lang.nameHeader, value: lang.rawValue),
                                    URLQueryItem(name: units.nameHeader, value: units.rawValue)]
        return urlComponemts
    }
    
    private func URLComponemtsForecast(_ typeGetting: TypeGettingCurrectWeather, countTimestamps: Int) -> URLComponents {
        var urlComponemts = baseUrlComponents
        urlComponemts.path += "forecast"
        urlComponemts.queryItems = typeGetting.generateURLQueryItem() + [
                                    URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: lang.nameHeader, value: lang.rawValue),
                                    URLQueryItem(name: units.nameHeader, value: units.rawValue),
                                    URLQueryItem(name: "cnt", value: String(countTimestamps))]
        return urlComponemts
    }
    
    private func request<T: Codable>(forUrl urlComponemts: URLComponents, type: T.Type, completion: @escaping currectWeather) {
        guard let url = urlComponemts.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        let task = session.dataTask(with: request) { data, response, error in
            var result: AnswerServer
            if let error = error {
                let errorServer = ErrorServer(cod: "0", message: error.localizedDescription)
                result = AnswerServer.failure(errorServer)
            }
            
            if data != nil,
               let weather = try? JSONDecoder().decode(type, from: data!){
                result = AnswerServer.success(weather)
            }
            else if data != nil,
                    let error = try? JSONDecoder().decode(ErrorServer.self, from: data!){
                result = AnswerServer.failure(error)
            } else {
                result = AnswerServer.failure(ErrorServer(cod: "0", message: "Ошибка"))
            }
            completion(result)
        }
        
        task.resume()
        
    }
}
