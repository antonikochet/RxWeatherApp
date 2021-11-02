//
//  ViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//

import UIKit

class MainViewController: UIViewController {

    lazy var weatherView = {
        return MainWeatherView(frame: view.frame)
    }()
    
    lazy var updateDataButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.counterclockwise")
        image?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(weatherView)
        view.addSubview(updateDataButton)
        setupConstraints()
        updateDataButton.addTarget(self, action: #selector(updateDataForThisCity), for: .touchUpInside)
        weatherView.backgroundColor = .orange
    }
    
    private func getCurrectWeather() {
        let api = ApiManager()
        let typeGetting = TypeGettingCurrectWeather.city("Санкт-Петер")
        api.getCurrectWeather(typeGetting) { [weak self] answer in
            DispatchQueue.main.async {
                switch answer {
                    case .success(let weather):
                        let viewWeather = ViewWeather(weather as! CurrectWeather)
                            self?.weatherView.updateView(viewWeather)
                    case .failure(let error):
                        self?.alertErrorController(title: "Ошибка", message: "Ошибка \(error.cod) - \(error.message)")
                }
            }
            
        }
    }
    
    @objc private func updateDataForThisCity() {
        getCurrectWeather()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            updateDataButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            updateDataButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            updateDataButton.heightAnchor.constraint(equalToConstant: 32),
            updateDataButton.widthAnchor.constraint(equalToConstant: 32)])
        
    }
    
}

