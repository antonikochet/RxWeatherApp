//
//  MainViewModel.swift
//  RxWeatherApp
//
//  Created by антон кочетков on 15.02.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    // Input
    let viewWillAppearSubject = PublishRelay<Void>()
    let updateWeather = PublishRelay<Void>()
    
    // Output
    let statusImageName: Driver<String>
    let city: Driver<String>
    let weatherDesctiption: Driver<String>
    let temperature: Driver<String>
    let feelsLikeTemperature: Driver<String>
    let isSunsetBackground: Driver<Bool>
    let conditionsWeather: Driver<[ConditionsWeather]>
    let forecastsWeather: Driver<[ForecastWeather]>
    
    private let disposeBag = DisposeBag()
    
    init() {
        let initial = viewWillAppearSubject
            .flatMapLatest { _ in
                MainViewModel.request()
            }
            .observe(on: MainScheduler.instance)
            .share()
        
        let update = updateWeather
            .flatMapLatest {
                MainViewModel.request()
            }
            .observe(on: MainScheduler.instance)
            .share()
        
        let currectWeather = Observable.merge(initial, update)
        
        statusImageName = currectWeather
            .map { $0.statusWeaher.imageName }
            .asDriver(onErrorJustReturn: "")
        city = currectWeather
            .map { $0.city }
            .asDriver(onErrorJustReturn: "-")
        weatherDesctiption = currectWeather
            .map { $0.weatherDesctiption }
            .asDriver(onErrorJustReturn: "")
        temperature = currectWeather
            .map { $0.temperature.tempString }
            .asDriver(onErrorJustReturn: "")
        feelsLikeTemperature = currectWeather
            .map { "Ощущается как \($0.feelsLikeTemperature.tempString)" }
            .asDriver(onErrorJustReturn: "")
        isSunsetBackground = currectWeather
            .map { viewWeather in
                let now = Date()
                return now > viewWeather.sunrise && now < viewWeather.sunset
            }
            .asDriver(onErrorJustReturn: false)
        conditionsWeather = currectWeather
            .map { viewWeather -> [ConditionsWeather] in
                [
                    .highLow(viewWeather.highTemperature, viewWeather.lowTemperature),
                    .wind(viewWeather.windSpeed),
                    .humidity(viewWeather.humidity)
                ]
            }
            .asDriver(onErrorJustReturn: [])
        forecastsWeather = currectWeather
            .map { $0.arrayForecast }
            .asDriver(onErrorJustReturn: [])
    }
    
    static func request() -> Observable<ViewWeather> {
        let requestCurrect = ApiManager.shared.getCurrectWeather(.city("Москва"))
        let requestForecast = ApiManager.shared.getForecastWeather(.city("Москва"), countTimestamps: 7)
        return Observable.combineLatest(requestCurrect, requestForecast, resultSelector: { currect, forecast in
            return ViewWeather(currect, forecast)
        })
        
    }
}
