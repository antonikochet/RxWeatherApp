//
//  ViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//
//TODO: 1) вынести работу с сетью и данными в отдельный класс
//TODO: 2) сделать определение по местоположению
//TODO: 3) сделать кастомную ячейку для городов
//TODO: 4) исправить ошибку при начальной загрузки у 3 часового нет изображения

import UIKit

protocol TableOfCityDelegate: NSObject {
    func addNewCity(name: String)
    func selectCity(name: String)
    func removeCity(name: String)
    var arrayCities: [String] { get }
}

class MainViewController: UIViewController {

    private var currectCity: String?
    private var dictionaryOfCityWeather: [String: ViewWeather] = [:]
    
    lazy var weatherView = {
        return MainWeatherView(frame: view.frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundView()
        view.addSubview(weatherView)
        setupBarButtoItem()
        if let viewWeather = CustomUserDefaults.firstDataCity {
            dictionaryOfCityWeather[viewWeather.city] = viewWeather
            currectCity = viewWeather.city
            DispatchQueue.main.async {
                self.weatherView.updateView(viewWeather)
            }
        }
        
        updateAllCityWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CustomUserDefaults.arrayOfCities = Array(dictionaryOfCityWeather.keys)
        CustomUserDefaults.firstDataCity = dictionaryOfCityWeather[currectCity ?? ""]
    }
    
    private func getWeather() {
        let api = ApiManager()
        guard let nameCity = currectCity else {
            alertErrorController(title: "Ошибка", message: "Город не выбран")
            return
        }
        let typeGetting = TypeGettingCurrectWeather.city(nameCity)
        api.getWeather(for: typeGetting, countTimestamps: 7) { [weak self] currect, forecast, error in
            guard error == nil else {
                self?.alertErrorController(title: "Ошибка", message: error!.description)
                return
            }
            if currect != nil,
               forecast != nil {
                let viewWeather = ViewWeather(currect!, forecast!)
                self?.dictionaryOfCityWeather.updateValue(viewWeather, forKey: nameCity)
                self?.weatherView.updateView(viewWeather)
            }
        }
    }
    
    private func updateAllCityWeather() {
        let arrayCity = CustomUserDefaults.arrayOfCities
        let api = ApiManager()
        var errorServer: ErrorServer?
        for nameCity in arrayCity {
            let typeGetting = TypeGettingCurrectWeather.city(nameCity)
            api.getWeather(for: typeGetting, countTimestamps: 7) { [weak self] currect, forecast, error in
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
        getWeather()
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
    
    var arrayCities: [String] {
        return Array(dictionaryOfCityWeather.keys)
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
    
}
