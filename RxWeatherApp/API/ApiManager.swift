//
//  ApiManager.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation
import RxSwift

typealias currectWeather = (AnswerServer) -> Void

typealias GetWeather = (Currect?, Forecast?, ErrorServer?) -> Void

class ApiManager {
    
    static let shared = ApiManager()
    
    private var lang: Lang
    private var units: Units
    private let session = URLSession(configuration: .default)
    private let dispatchGroup = DispatchGroup()
    
    init() {
        self.lang = Lang.ru
        self.units = Units.metric
    }
    
    private func URLComponemtsCurrect(_ typeGetting: TypeGettingCurrectWeather) -> URLComponents {
        var urlComponemts = WeatherApi.baseUrlComponents
        urlComponemts.path += WeatherApi.Requests.weather
        urlComponemts.queryItems = typeGetting.generateURLQueryItem() + [
                                    URLQueryItem(name: "appid", value: WeatherApi.apiKey),
                                    URLQueryItem(name: lang.nameHeader, value: lang.rawValue),
                                    URLQueryItem(name: units.nameHeader, value: units.rawValue)]
        return urlComponemts
    }
    
    private func URLComponemtsForecast(_ typeGetting: TypeGettingCurrectWeather, countTimestamps: Int) -> URLComponents {
        var urlComponemts = WeatherApi.baseUrlComponents
        urlComponemts.path += WeatherApi.Requests.forecast
        urlComponemts.queryItems = typeGetting.generateURLQueryItem() + [
                                    URLQueryItem(name: "appid", value: WeatherApi.apiKey),
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

// MARK: - Rx
extension ApiManager {
    func getCurrectWeather(_ typeGetting: TypeGettingCurrectWeather) -> Observable<Currect> {
        guard let url = URLComponemtsCurrect(typeGetting).url else { return Observable.error(ApiError.invalidURL) }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        
        return session.rx.data(request: request).map(Currect.self)
    }
    
    func getForecastWeather(_ typeGetting: TypeGettingCurrectWeather, countTimestamps: Int) -> Observable<Forecast> {
        guard let url = URLComponemtsForecast(typeGetting, countTimestamps: countTimestamps).url else { return Observable.error(ApiError.invalidURL) }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        
        return session.rx.data(request: request).map(Forecast.self)
    }
    
    func getCities(_ query: String) -> Observable<SuggestionsResponse> {
        var urlComponents = DadataApi.baseUrlComponents
        urlComponents.path += DadataApi.Requests.address
        guard let url = urlComponents.url else { return Observable.error(ApiError.invalidURL) }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Token " + DadataApi.apiKey, forHTTPHeaderField: "Authorization")
        
        var requestParams = SuggestionsRequest(query: query,
                                               upperScaleLimit: .init(value: .city),
                                               lowerScaleLimit: .init(value: .city))
        request.httpBody = try? requestParams.toJSON()
        
        return  session.rx.data(request: request).map(SuggestionsResponse.self)
    }
}

public extension ObservableType where Element == Data {
  func map<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T> where T: Decodable {
    return self.map { data -> T in
      let decoder = decoder ?? JSONDecoder()
      return try decoder.decode(type, from: data)
    }
  }
}
