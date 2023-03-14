//
//  ViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//
//TODO: 1) вынести работу с сетью и данными в отдельный класс

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    private let imageWeather = UIImageView()
    private let cityLabel = UILabel()
    private let descriptionWeatherLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let feelsLikeTemperatureLabel = UILabel()
    private let stackConditionsWeatherView = UIStackView()
    private let stackHourForestView = UIStackView()
    private let backgroundView = UIImageView()
    private let leftBarButtonItem = UIBarButtonItem()
    private let rightBarButtonItem = UIBarButtonItem()
    
    private let button = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Обновить", for: .normal)
    }
    
    func bind(to viewModel: MainViewModel) {
        rx.viewWillAppear
            .asObservable()
            .bind(to: viewModel.viewWillAppearSubject)
            .disposed(by: disposeBag)
        button.rx.tap
            .asObservable()
            .bind(to: viewModel.updateWeather)
            .disposed(by: disposeBag)
        
        viewModel.statusImageName
            .map { UIImage(systemName: $0) }
            .drive(imageWeather.rx.image)
            .disposed(by: disposeBag)
        viewModel.city
            .drive(cityLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.weatherDesctiption
            .drive(descriptionWeatherLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.temperature
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.feelsLikeTemperature
            .drive(feelsLikeTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.isSunsetBackground
            .map { $0 ? UIImage(named: "sunset") : UIImage(named: "night") }
            .drive(backgroundView.rx.image)
            .disposed(by: disposeBag)
        viewModel.conditionsWeather
            .drive(stackConditionsWeatherView.rx.items) { (_, element, view) in
                let myView = (view as? ConditionsWeatherView) ?? ConditionsWeatherView()
                myView.setTypeConditionsWeather(element)
                return myView
            }
            .disposed(by: disposeBag)
        viewModel.forecastsWeather
            .drive(stackHourForestView.rx.items) { (_, element, view) in
                let myView = (view as? HourForecastView) ?? HourForecastView()
                myView.updateView(forecast: element)
                return myView
            }
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        setupBarButtomItem()
        setupImageWeather()
        setupCityLabel()
        setupDescriptionWeatherLabel()
        setupTemperatureLabel()
        setupFeelsLikeTemperatureLabel()
        setupStackHourForestView()
        setupStackConditionsWeatherView()
        setupBackgroundView()
    }
    private func setupBarButtomItem() {
        let imageLeft = UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysTemplate)
        let leftButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        leftButton.setImage(imageLeft, for: .normal)
        leftButton.tintColor = .white
        leftBarButtonItem.customView = leftButton
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let imageRight = UIImage(systemName: "arrow.counterclockwise")?.withRenderingMode(.alwaysTemplate)
        let rightButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        rightButton.setImage(imageRight, for: .normal)
        rightButton.tintColor = .white
        rightBarButtonItem.customView = rightButton
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    private func setupImageWeather() {
        let image = UIImage(systemName: "questionmark")
        image?.withRenderingMode(.alwaysOriginal)
        imageWeather.image = image
        imageWeather.contentMode = .scaleAspectFit
        imageWeather.tintColor = .white
        
        view.addSubview(imageWeather)
        imageWeather.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(64)
            make.size.equalTo(48)
        }
    }
    private func setupCityLabel() {
        cityLabel.textColor = .white
        cityLabel.textAlignment = .center
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageWeather.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.lessThanOrEqualTo(100)
        }
    }
    private func setupDescriptionWeatherLabel() {
        descriptionWeatherLabel.textColor = .white
        descriptionWeatherLabel.textAlignment = .center
        descriptionWeatherLabel.adjustsFontSizeToFitWidth = true
        descriptionWeatherLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        view.addSubview(descriptionWeatherLabel)
        descriptionWeatherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
        }
    }
    private func setupTemperatureLabel() {
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: 150, weight: .ultraLight)
        temperatureLabel.adjustsFontSizeToFitWidth = true
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(8)
            make.height.equalToSuperview().multipliedBy(1/7)
        }
    }
    private func setupFeelsLikeTemperatureLabel() {
        feelsLikeTemperatureLabel.textColor = .white
        feelsLikeTemperatureLabel.textAlignment = .center
        feelsLikeTemperatureLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        view.addSubview(feelsLikeTemperatureLabel)
        feelsLikeTemperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(8)
        }
    }
    private func setupStackConditionsWeatherView() {
        stackConditionsWeatherView.axis = .horizontal
        stackConditionsWeatherView.distribution = .fillEqually
        
        view.addSubview(stackConditionsWeatherView)
        stackConditionsWeatherView.snp.makeConstraints { make in
            make.bottom.equalTo(stackHourForestView.snp.top).inset(-24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    private func setupStackHourForestView() {
        stackHourForestView.axis = .horizontal
        stackHourForestView.distribution = .fillEqually
        
        view.addSubview(stackHourForestView)
        stackHourForestView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(80)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    private func setupBackgroundView() {
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        backgroundView.center = view.center
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.sendSubviewToBack(backgroundView)
    }
}
