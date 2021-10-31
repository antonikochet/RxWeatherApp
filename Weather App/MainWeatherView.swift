//
//  MainWeatherView.swift
//  Weather App
//
//  Created by Антон Кочетков on 31.10.2021.
//

import UIKit

class MainWeatherView: UIView {
   
    lazy var dateLabel: UILabel = {
        let label = createLabel(title: "Date", textStyle: .body)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = createLabel(title: "Time", textStyle: .largeTitle)
        return label
    }()
    
    lazy var cityLabel: UILabel = {
        let label = createLabel(title: "City", textStyle: .body)
        return label
    }()
    
    lazy var imageWeather: UIImageView = {
        let image = UIImage(systemName: "cloud.rain")
        image?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = createLabel(title: "10", textStyle: .largeTitle)
        label.font = UIFont.systemFont(ofSize: 80, weight: .thin)
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var dayOfWeekLabel: UILabel = {
        let label = createLabel(title: "day of week", textStyle: .title3)
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(dateLabel)
        addSubview(timeLabel)
        addSubview(cityLabel)
        addSubview(imageWeather)
        addSubview(temperatureLabel)
        addSubview(dayOfWeekLabel)
        addSubview(lineView)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            
            imageWeather.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageWeather.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 3/5),
            imageWeather.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3/5),
            imageWeather.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 48),
    
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: imageWeather.bottomAnchor, constant: 16),
            temperatureLabel.leftAnchor.constraint(equalTo: leftAnchor),
            temperatureLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfWeekLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 32),
            
            lineView.topAnchor.constraint(equalTo: dayOfWeekLabel.bottomAnchor, constant: 8),
            lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 64),
            lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -64),
            lineView.heightAnchor.constraint(equalToConstant: 2),

        ])
    
        super.updateConstraints()
    }
    
    private func createLabel(title: String, textStyle:UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
