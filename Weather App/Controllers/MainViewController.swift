//
//  ViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//

import UIKit

protocol UpdateCitiesDelegate: NSObject {
    func addNewCity(name: String)
    func selectCity(name: String)
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
    
    
}
