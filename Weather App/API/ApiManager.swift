//
//  ApiManager.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation

typealias currectWeather = (AnswerServer) -> Void

class ApiManager {
    
    private var lang: Lang
    private var units: Units
    private let apiKey = "4d5555216cc6eafafdb25aeee2050261"
    private var baseUrlComponents: URLComponents = {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.openweathermap.org"
        url.path = "/data/2.5/weather"
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
    
    func getCurrectWeather(_ typeGetting: TypeGettingCurrectWeather, completion: @escaping currectWeather) {
        var urlComponemts = baseUrlComponents
        urlComponemts.queryItems = typeGetting.generateURLQueryItem() + [
                                    URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: lang.nameHeader, value: lang.rawValue),
                                    URLQueryItem(name: units.nameHeader, value: units.rawValue)]
        
        guard let url = urlComponemts.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        
        let seccion = URLSession(configuration: .default)
        let task = seccion.dataTask(with: request) { data, response, error in
            var result: AnswerServer
            if let error = error {
                let errorServer = ErrorServer(cod: "0", message: error.localizedDescription)
                result = AnswerServer.failure(errorServer)
            }
            
            if data != nil,
               let weather = try? JSONDecoder().decode(CurrectWeather.self, from: data!){
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
