//
//  MainWeatherView.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//

import UIKit

class MainWeatherView: UIView {
   
    lazy var descriptionWeatherLabel: UILabel = {
        let label = UILabel.createLabel(title: "Description", textStyle: .body)
        return label
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel.createLabel(title: "City", textStyle: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 150, weight: .bold)
        return label
    }()
    
    lazy var imageWeather: UIImageView = {
        let image = UIImage(systemName: "questionmark")
        image?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel.createLabel(title: "?", textStyle: .largeTitle)
        label.font = UIFont.systemFont(ofSize: 150, weight: .ultraLight)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel.createLabel(title: "Ощущается как ?", textStyle: .body)
        return label
    }()
    
    lazy var stackConditionsWeatherView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: Array(repeating: ConditionsWeatherView.init, count: 3))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackHourForestView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: Array(repeating: HourForecastView.init, count: 6))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.center = center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(_ weather: ViewWeather) {
        descriptionWeatherLabel.text = weather.weatherDesctiption
        cityLabel.text = weather.city
        imageWeather.image = UIImage(systemName: weather.statusWeaher.imageName)
        temperatureLabel.text = weather.temperature.tempString
        feelsLikeTemperatureLabel.text = "Ощущается как \(weather.feelsLikeTemperature.tempString)"
        
        let highLow: ConditionsWeatherView? = stackConditionsWeatherView.arrangedSubviews[0] as? ConditionsWeatherView
        highLow?.setTypeConditionsWeather(.highLow(weather.highTemperature, weather.lowTemperature))
        let wind: ConditionsWeatherView? = stackConditionsWeatherView.arrangedSubviews[1] as? ConditionsWeatherView
        wind?.setTypeConditionsWeather(.wind(weather.windSpeed))
        let humidity: ConditionsWeatherView? = stackConditionsWeatherView.arrangedSubviews[2] as? ConditionsWeatherView
        humidity?.setTypeConditionsWeather(.humidity(weather.humidity))
        
        updateBackgroundView(sunrize: weather.sunrise, sunset: weather.sunset)
        
        if weather.arrayForecast.count >= stackHourForestView.arrangedSubviews.count {
            for (index, view) in stackHourForestView.arrangedSubviews.enumerated() {
                let forecast = weather.arrayForecast[index]
                let hourForecastView = view as! HourForecastView
                hourForecastView.updateView(forecast: forecast)
            }
        }
        
    }
    private func addSubviews() {
        addSubview(imageWeather)
        addSubview(cityLabel)
        addSubview(descriptionWeatherLabel)
        addSubview(temperatureLabel)
        addSubview(feelsLikeTemperatureLabel)
        addSubview(stackConditionsWeatherView)
        addSubview(stackHourForestView)
        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            imageWeather.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageWeather.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            imageWeather.heightAnchor.constraint(equalToConstant: 48),
            imageWeather.widthAnchor.constraint(equalToConstant: 48),
    
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: imageWeather.bottomAnchor, constant: 8),
            cityLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/14),
            cityLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3),
            
            descriptionWeatherLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionWeatherLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: descriptionWeatherLabel.bottomAnchor, constant: 8),
            temperatureLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/7),

            feelsLikeTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),
            feelsLikeTemperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stackConditionsWeatherView.bottomAnchor.constraint(equalTo: stackHourForestView.topAnchor, constant: -64),
            stackConditionsWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackConditionsWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackConditionsWeatherView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/10),
            
            stackHourForestView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64),
            stackHourForestView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackHourForestView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackHourForestView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/10),
            
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    
        super.updateConstraints()
    }
    
    private func updateBackgroundView(sunrize: Date, sunset: Date){
        var backgroundImage: UIImage?
        let now = Date()
        if now > sunrize && now < sunset {
            backgroundImage = UIImage(named: "sunset")
        } else {
            backgroundImage = UIImage(named: "night")
        }
        backgroundView.image = backgroundImage
    }
}


extension UILabel {
    static func createLabel(title: String, textStyle:UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

}

extension Array {
    init(repeating: (() -> Element), count: Int) {
        self = []
        for _ in 0..<count {
            self.append(repeating())
        }
    }
}

extension Int {
    var tempString: String {
        if self > 0 {
            return "+\(self)°"
        } else {
            return "\(self)°"
        }
       
    }
}
