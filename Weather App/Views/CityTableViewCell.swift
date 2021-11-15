//
//  CityTableViewCell.swift
//  Weather App
//
//  Created by Антон Кочетков on 12.11.2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    static let Identifier = "CityCell"
    
    lazy var nameCity: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 30)
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeUpdateLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameCity)
        addSubview(tempLabel)
        addSubview(timeUpdateLabel)
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(weatherCity: ViewWeather) {
        nameCity.text = weatherCity.city
        tempLabel.text = weatherCity.temperature.tempString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        timeUpdateLabel.text = dateFormatter.string(from: weatherCity.dateUpdate)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            nameCity.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameCity.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameCity.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 8/10),
            nameCity.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
        
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            tempLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 6/10),
            tempLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/10),
        
            timeUpdateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            timeUpdateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timeUpdateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/10),
            timeUpdateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3/10)
            ])
        
        super.updateConstraints()
    }
}
