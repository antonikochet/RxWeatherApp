//
//  CitiesTableViewModel.swift
//  RxWeatherApp
//
//  Created by антон кочетков on 15.03.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class CitiesTableViewModel {
    // Input
    let viewWillAppear = PublishRelay<Void>()
    let searchQuerySubject = PublishRelay<String>()
    let didSelectCity = PublishRelay<IndexPath>()
    
    // Output
    let cities: Driver<[CityCellViewModel]>

    private let disposeBag = DisposeBag()
    
    init() {
        let initial = viewWillAppear
            .flatMapLatest { _ in
                UserDefaults.standard.rx.observe([String].self, CustomUserDefaults.NameOfValue.arrayOfCities.rawValue)
            }
            .do(onNext: { print($0 ?? "not cities in userDefaults") })
            .compactMap { $0 }
            .map { $0.map { CityCellViewModel(name: $0, temp: "", timeUpdate: "") } }
        
        let searchCitiesObs = searchQuerySubject
            .distinctUntilChanged()
            .filter { $0.count > 0 }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        
        let searchCities = searchCitiesObs
            .asObservable()
            .flatMapLatest { query in
                return ApiManager.shared.getCities(query)
            }
            .map { $0.suggestions.compactMap { $0.data.city } }
            .map { $0.map { CityCellViewModel(name: $0, temp: "", timeUpdate: "") } }
        
        let isSearchCities = searchCitiesObs
            .asObservable()
            .map { !$0.isEmpty }
        
        cities = Observable.merge(searchCities, initial)
            .asDriver(onErrorJustReturn: [])
        
        let didSelect = didSelectCity
            .asObservable()
            .do(onNext: { print($0) })
            .withLatestFrom(cities) { indexPath, cities in
                return cities[indexPath.row]
            }
            .map { $0.name }
        
        Observable.combineLatest(isSearchCities, didSelect)
            .subscribe { (isSearch, city) in
                if isSearch {
                    var cities = CustomUserDefaults.arrayOfCities
                    if !cities.contains(city) {
                        cities.append(city)
                        CustomUserDefaults.arrayOfCities = cities
                    }
                    print("поиск", city)
                } else {
                    print("выбор", city)
                }
            }
            .disposed(by: disposeBag)
    }
}
