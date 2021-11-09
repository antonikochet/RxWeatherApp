//
//  ViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//
//TODO: 1) сделать изменение фона в зависимости от времени
//TODO: 2) сделать определение по местоположению
//TODO: 3) сделать кастомную ячейку для городов
//TODO: 4) сделать view для 3 часового интервала

import UIKit

protocol UpdateCitiesDelegate: NSObject {
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
        view.addSubview(weatherView)
        weatherView.backgroundColor = .orange
        setupBarButtoItem()
        if let viewWeather = CustomUserDefaults.firstDataCity {
            dictionaryOfCityWeather[viewWeather.city] = viewWeather
            DispatchQueue.main.async {
                self.weatherView.updateView(viewWeather)
            }
        }
        currectCity = CustomUserDefaults.arrayOfCities.first
        //TODO: сделать метод ассинхронным
        updateAllCityWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CustomUserDefaults.arrayOfCities = Array(dictionaryOfCityWeather.keys)
        CustomUserDefaults.firstDataCity = dictionaryOfCityWeather[currectCity ?? ""]
    }
    private func getCurrectWeather() {
        let api = ApiManager()
        guard let nameCity = currectCity else {
            alertErrorController(title: "Ошибка", message: "Город не выбран")
            return
        }
        let typeGetting = TypeGettingCurrectWeather.city(nameCity)
        api.getCurrectWeather(typeGetting) { [weak self] answer in
            DispatchQueue.main.async {
                switch answer {
                    case .success(let weather):
                        let viewWeather = ViewWeather(weather as! CurrectWeather)
                            self?.weatherView.updateView(viewWeather)
                        self?.dictionaryOfCityWeather[nameCity] = viewWeather
                    case .failure(let error):
                        self?.alertErrorController(title: "Ошибка", message: "Ошибка \(error.cod) - \(error.message)")
                }
            }
            
        }
    }
    
    private func updateAllCityWeather() {
        let arrayCity = CustomUserDefaults.arrayOfCities
        let api = ApiManager()
        var errorServer: ErrorServer?
        for nameCity in arrayCity {
            let typeGetting = TypeGettingCurrectWeather.city(nameCity)
            api.getCurrectWeather(typeGetting) { [weak self] answer in
                switch answer {
                    case .success(let weather):
                        let viewWeather = ViewWeather(weather as! CurrectWeather)
                        self?.dictionaryOfCityWeather[viewWeather.city] = viewWeather
                    case .failure(let error):
                        errorServer = error
                }
            }
        }
        guard errorServer != nil else { return }
        self.alertErrorController(title: "Ошибка", message: "Ошибка \(errorServer!.cod) - \(errorServer!.message)")
    }
    
    @objc private func updateDataForThisCity() {
        getCurrectWeather()
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
}

extension MainViewController: UpdateCitiesDelegate{
    
    var arrayCities: [String] {
        return Array(dictionaryOfCityWeather.keys)
    }
    func addNewCity(name: String) {
        currectCity = name
        getCurrectWeather()
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
