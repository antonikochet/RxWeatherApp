//
//  HourForecastView.swift
//  Weather App
//
//  Created by Антон Кочетков on 10.11.2021.
//

import UIKit

class HourForecastView: UIView {

    lazy var temperatureLabel: UILabel = {
        let label = UILabel.createLabel(title: "?", textStyle: .body)
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImage(systemName: "questionmark")
        image?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel.createLabel(title: "?", textStyle: .body)
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(timeLabel)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        super.updateConstraints()
    }
    
    func updateView(forecast: ForecastWeather) {
        temperatureLabel.text = String(forecast.temperature)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: forecast.time)
        
        let image = UIImage(systemName: forecast.statusWeather.imageName)
        image?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
    }
}
