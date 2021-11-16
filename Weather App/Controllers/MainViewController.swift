//
//  ViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//
//TODO: 1) вынести работу с сетью и данными в отдельный класс

import UIKit

class MainViewController: UIViewController {

    private let weatherProvider = WeatherProvider()
    
    lazy var weatherView = {
        return MainWeatherView(frame: view.frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(weatherView)
        setupBarButtoItem()
        weatherProvider.delegateError = self
        weatherProvider.delegateReact = self
        
        weatherProvider.loadDataFromUserDefaults()
        weatherProvider.getLocation()
        weatherProvider.updateAllCityWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        weatherProvider.saveDataToUserDefaults()
    }
    
    @objc private func updateDataForThisCity() {
        weatherProvider.updateDataForThisCity()
    }
    
    @objc private func showViewTableCity() {
        let tableViewController = CitiesTableViewController()
        tableViewController.delegate = weatherProvider
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

extension MainViewController: ReactViewDelegate {
    func updateView(weather: ViewWeather) {
        weatherView.updateView(weather)
    }
}

extension MainViewController: AlertErrorDelegate {
    func showError(error: ErrorServer) {
        alertErrorController(title: "Ошибка", message: error.description)
    }
    
    
}
