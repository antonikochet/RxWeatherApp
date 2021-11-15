//
//  ViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//
//TODO: 1) вынести работу с сетью и данными в отдельный класс
//TODO: 2) исправить ошибку при начальной загрузки у 3 часового нет изображения

import UIKit

class MainViewController: UIViewController {

    private var currectCity: String?
    private var dictionaryOfCityWeather: [String: ViewWeather] = [:]
    private let location = "Текущие местоположение"
    
    lazy var weatherView = {
        return MainWeatherView(frame: view.frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundView()
        view.addSubview(weatherView)
        setupBarButtoItem()
        if LocationManager.shared.isAuthorization,
           let viewWeather = CustomUserDefaults.locationData {
            dictionaryOfCityWeather[location] = viewWeather
            currectCity = location
            DispatchQueue.main.async {
                self.weatherView.updateView(viewWeather)
            }
        } else if let viewWeather = CustomUserDefaults.firstDataCity {
            dictionaryOfCityWeather[viewWeather.city] = viewWeather
            currectCity = viewWeather.city
            DispatchQueue.main.async {
                self.weatherView.updateView(viewWeather)
            }
        }
        getLocation()
        updateAllCityWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CustomUserDefaults.arrayOfCities = Array(dictionaryOfCityWeather.keys)
        CustomUserDefaults.firstDataCity = dictionaryOfCityWeather[currectCity ?? ""]
        if LocationManager.shared.isAuthorization,
           let viewWeather = dictionaryOfCityWeather[location] {
            CustomUserDefaults.locationData = viewWeather
        } else {
            CustomUserDefaults.locationData = nil
        }
    }
    
    private func getWeather() {
        guard let city = currectCity else {
            alertErrorController(title: "Ошибка", message: "Город не найден")
            return
        }
        guard city != location else { return }
        
        ApiManager.shared.getWeather(for: TypeGettingCurrectWeather.city(city), countTimestamps: 7) { [weak self] currect, forecast, error in
            guard error == nil else {
                self?.alertErrorController(title: "Ошибка", message: error!.description)
                return
            }
            if currect != nil,
               forecast != nil {
                let viewWeather = ViewWeather(currect!, forecast!)
                self?.dictionaryOfCityWeather.updateValue(viewWeather, forKey: viewWeather.city)
                self?.weatherView.updateView(viewWeather)
            }
        }
    }
    
    private func getLocation() {
        LocationManager.shared.getLocation { location in
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            let typeGetting = TypeGettingCurrectWeather.location(lat: lat, lon: lon)
            ApiManager.shared.getWeather(for: typeGetting, countTimestamps: 7) { [weak self] currect, forecast, error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    strongSelf.alertErrorController(title: "Ошибка", message: "Погода не найдена по местоположению")
                    return
                }
                if currect != nil,
                   forecast != nil {
                    var viewWeather = ViewWeather(currect!, forecast!)
                    viewWeather.city = strongSelf.location
                    strongSelf.dictionaryOfCityWeather.updateValue(viewWeather, forKey: strongSelf.location )
                    strongSelf.weatherView.updateView(viewWeather)
                    strongSelf.currectCity = strongSelf.location
                }
            }
        }
    }
    
    private func updateAllCityWeather() {
        let arrayCity = CustomUserDefaults.arrayOfCities
        var errorServer: ErrorServer?
        for nameCity in arrayCity {
            if nameCity == location {
                continue
            }
            let typeGetting = TypeGettingCurrectWeather.city(nameCity)
            ApiManager.shared.getWeather(for: typeGetting, countTimestamps: 7) { [weak self] currect, forecast, error in
                guard error == nil else {
                    errorServer = error
                    return
                }
                if currect != nil,
                   forecast != nil {
                    let viewWeather = ViewWeather(currect!, forecast!)
                    self?.dictionaryOfCityWeather.updateValue(viewWeather, forKey: nameCity)
                }
            }
        }
        guard errorServer != nil else { return }
        self.alertErrorController(title: "Ошибка", message: errorServer!.description)
    }
    
    @objc private func updateDataForThisCity() {
        if currectCity == location {
            getLocation()
        } else {
            getWeather()
        }
        
    }
    
    @objc private func showViewTableCity() {
        let tableViewController = CitiesTableViewController()
        tableViewController.delegate = self
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    private func setupBarButtoItem() {
        let imageLeft = UIImage(systemName: "list.bullet")
        imageLeft?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:imageLeft, style: .plain, target: self, action: #selector(showViewTableCity))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        let imageRight = UIImage(systemName: "arrow.counterclockwise")
        imageRight?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageRight, style: .done, target: self, action: #selector(updateDataForThisCity))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func updateBackgroundView() {
        let hour = Calendar.current.component(.hour, from: Date())
        var backgroundImage: UIImage?
        switch hour {
            case 6...18:
                backgroundImage = UIImage(named: "sunset")
            default:
                backgroundImage = UIImage(named: "night")
        }
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
}

extension MainViewController: TableOfCityDelegate{
    
    var arrayWeather: [ViewWeather] {
        let arrayWeather = Array(dictionaryOfCityWeather.values)
        return arrayWeather.filter { $0.city != location }
    }
    
    func addNewCity(name: String) {
        currectCity = name
        getWeather()
    }
    
    func selectCity(name: String) {
        currectCity = name
        guard let currectWeather = dictionaryOfCityWeather[currectCity!] else { return }
        weatherView.updateView(currectWeather)
    }
    
    func removeCity(name: String) {
        if name != currectCity {
            dictionaryOfCityWeather.removeValue(forKey: name)
        } else {
            let arrayCities = Array(dictionaryOfCityWeather.keys.filter { $0 != name })
            if let firstCity = arrayCities.first {
                currectCity = firstCity
                weatherView.updateView(dictionaryOfCityWeather[firstCity]!)
            }
            dictionaryOfCityWeather.removeValue(forKey: name)
        }
    }
    
    var viewWeatherLocation: ViewWeather? {
        return dictionaryOfCityWeather[location]
    }
    
}

