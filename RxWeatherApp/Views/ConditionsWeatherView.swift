//
//  ConditionsWeatherView.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ConditionsWeatherView: UIView {

    private var typeConditionsWeather: ConditionsWeather?
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let dataLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupImageView()
        setupNameLabel()
        setupDataLabel()
        setupStackView()
    }
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        stackView.addArrangedSubview(imageView)
    }
    private func setupNameLabel() {
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        nameLabel.adjustsFontSizeToFitWidth = true
        
        stackView.addArrangedSubview(nameLabel)
    }
    private func setupDataLabel() {
        dataLabel.textColor = .white
        dataLabel.textAlignment = .center
        dataLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        dataLabel.adjustsFontSizeToFitWidth = true
        
        stackView.addArrangedSubview(dataLabel)
    }
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTypeConditionsWeather(_ newValue: ConditionsWeather) {
        typeConditionsWeather = newValue
        let image = UIImage(systemName: newValue.imageName)
        image?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        nameLabel.text = newValue.nameLabel
        dataLabel.text = newValue.stringDataView
    }
}
