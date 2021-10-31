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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(weatherView)
        weatherView.backgroundColor = .orange
    }


}

