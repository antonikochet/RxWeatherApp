//
//  WeatherProvider.swift
//  Weather App
//
//  Created by Антон Кочетков on 11.11.2021.
//

import Foundation

protocol AlertErrorDelegate: AnyObject {
    func showError(error: ErrorServer)
}

protocol ReactViewDelegate: AnyObject {
    func updateView(weather: ViewWeather)
}

class WeatherProvider {
    
    private var currectCity: String?
    private var dictionaryOfCityWeather: [String: ViewWeather] = [:]
    private let location = "Текущие местоположение"
    
    weak var delegateError: AlertErrorDelegate?
    weak var delegateReact: ReactViewDelegate?
    
    func loadDataFromUserDefaults() {
        if LocationManager.shared.isAuthorization,
           let viewWeather = CustomUserDefaults.locationData {
            dictionaryOfCityWeather[location] = viewWeather
            currectCity = location
            delegateReact?.updateView(weather: viewWeather)
        } else if let viewWeather = CustomUserDefaults.firstDataCity {
            dictionaryOfCityWeather[viewWeather.city] = viewWeather
            currectCity = viewWeather.city
            delegateReact?.updateView(weather: viewWeather)
        }
    }
    
    func saveDataToUserDefaults() {
        CustomUserDefaults.arrayOfCities = Array(dictionaryOfCityWeather.keys)
        CustomUserDefaults.firstDataCity = dictionaryOfCityWeather[currectCity ?? ""]
        if LocationManager.shared.isAuthorization,
           let viewWeather = dictionaryOfCityWeather[location] {
            CustomUserDefaults.locationData = viewWeather
        } else {
            CustomUserDefaults.locationData = nil
        }
    }
    
    func getWeather() {
        guard let city = currectCity else {
            delegateError?.showError(error: ErrorServer(cod: "", message: "Город не найден"))
            return
        }
        guard city != location else { return }
        
//        ApiManager.shared.getWeather(for: TypeGettingCurrectWeather.city(city), countTimestamps: 7) { [weak self] currect, forecast, error in
//            guard error == nil else {
//                self?.delegateError?.showError(error: error!)
//                return
//            }
//            if currect != nil,
//               forecast != nil {
//                let viewWeather = ViewWeather(currect!, forecast!)
//                self?.dictionaryOfCityWeather.updateValue(viewWeather, forKey: viewWeather.city)
//                self?.delegateReact?.updateView(weather: viewWeather)
//            }
//        }
    }
    
    func getLocation() {
        LocationManager.shared.getLocation { location in
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            let typeGetting = TypeGettingCurrectWeather.location(lat: lat, lon: lon)
//            ApiManager.shared.getWeather(for: typeGetting, countTimestamps: 7) { [weak self] currect, forecast, error in
//                guard let strongSelf = self else { return }
//                guard error == nil else {
//                    strongSelf.delegateError?.showError(error: ErrorServer(cod: "", message: "Погода не найдена по местоположению"))
//                    return
//                }
//                if currect != nil,
//                   forecast != nil {
//                    var viewWeather = ViewWeather(currect!, forecast!)
//                    viewWeather.city = strongSelf.location
//                    strongSelf.dictionaryOfCityWeather.updateValue(viewWeather, forKey: strongSelf.location )
//                    strongSelf.delegateReact?.updateView(weather: viewWeather)
//                    strongSelf.currectCity = strongSelf.location
//                }
//            }
        }
    }
    
    func updateAllCityWeather() {
        let arrayCity = CustomUserDefaults.arrayOfCities
        var errorServer: ErrorServer?
        for nameCity in arrayCity {
            if nameCity == location {
                continue
            }
            let typeGetting = TypeGettingCurrectWeather.city(nameCity)
//            ApiManager.shared.getWeather(for: typeGetting, countTimestamps: 7) { [weak self] currect, forecast, error in
//                guard error == nil else {
//                    errorServer = error
//                    return
//                }
//                if currect != nil,
//                   forecast != nil {
//                    let viewWeather = ViewWeather(currect!, forecast!)
//                    self?.dictionaryOfCityWeather.updateValue(viewWeather, forKey: nameCity)
//                }
//            }
        }
        guard errorServer != nil else { return }
        self.delegateError?.showError(error: errorServer!)
    }
    
    func updateDataForThisCity() {
        if currectCity == location {
            getLocation()
        } else {
            getWeather()
        }
    }
}
