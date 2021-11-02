//
//  ConditionsWeatherView.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import UIKit

class ConditionsWeatherView: UIView {

    private var typeConditionsWeather: ConditionsWeather
    
    lazy var imageView: UIImageView = {
        let image = UIImage(systemName: typeConditionsWeather.imageName)
        image?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.createLabel(title: typeConditionsWeather.nameLabel, textStyle: .body)
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dataLabel: UILabel = {
        let label = UILabel.createLabel(title: typeConditionsWeather.stringDataView, textStyle: .body)
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dataLabel)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(frame: CGRect, type: ConditionsWeather) {
        typeConditionsWeather = type
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
    
    func setTypeConditionsWeather(_ newValue: ConditionsWeather) {
        typeConditionsWeather = newValue
        dataLabel.text = typeConditionsWeather.stringDataView
    }
}
