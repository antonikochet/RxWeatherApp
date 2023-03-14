//
//  HourForecastView.swift
//  Weather App
//
//  Created by Антон Кочетков on 10.11.2021.
//

import UIKit

class HourForecastView: UIView {

    private let temperatureLabel = UILabel()
    private let imageView = UIImageView()
    private let timeLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupTemperatureLabel()
        setupImageView()
        setupTimeLabel()
        setupStackView()
    }
    private func setupTemperatureLabel() {
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        temperatureLabel.adjustsFontSizeToFitWidth = true
        
        stackView.addArrangedSubview(temperatureLabel)
    }
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        stackView.addArrangedSubview(imageView)
    }
    private func setupTimeLabel() {
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        timeLabel.adjustsFontSizeToFitWidth = true
        
        stackView.addArrangedSubview(timeLabel)
    }
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateView(forecast: ForecastWeather) {
        temperatureLabel.text = forecast.temperature.tempString
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: forecast.timeZone)
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: forecast.time)
        
        let image = UIImage(systemName: forecast.statusWeather.imageName)
        image?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
    }
}
