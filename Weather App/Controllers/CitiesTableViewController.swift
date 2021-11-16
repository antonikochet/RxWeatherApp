//
//  CitiesTableViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 07.11.2021.
//

import UIKit

protocol TableOfCityDelegate: AnyObject {
    func addNewCity(name: String)
    func selectCity(name: String)
    func removeCity(name: String)
    var arrayWeather: [ViewWeather] { get }
    var viewWeatherLocation: ViewWeather? { get }
}

class CitiesTableViewController: UIViewController {

    weak var delegate: TableOfCityDelegate?
    
    lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите город"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "magnifyingglass")
        image?.withRenderingMode(.alwaysOriginal)
        button.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(actionSearchCity), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.Identifier)
        table.rowHeight = 80
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(cityTextField)
        view.addSubview(tableView)
        view.addSubview(searchButton)
        setupConstrains()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchButton.heightAnchor.constraint(equalTo: cityTextField.heightAnchor),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.leadingAnchor.constraint(equalTo: cityTextField.trailingAnchor, constant: 8),
            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/16),
            
            tableView.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    @objc private func actionSearchCity() {
        guard let textField = cityTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard textField.count != 0 else { return }
        if arrayWeather.contains(where: { $0.city == textField }) {
            alertErrorController(title: "Предупреждение", message: "Город '\(textField)' уже есть в списке")
        } else {
            delegate?.addNewCity(name: textField)
            navigationController?.popViewController(animated: true)
        }
        
    }
}

extension CitiesTableViewController: UITableViewDataSource {
    
    private var arrayWeather: [ViewWeather] {
        return delegate?.arrayWeather ?? []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                if delegate?.viewWeatherLocation != nil {
                    return 1
                } else {
                    return 0
                }
            case 1:
                return arrayWeather.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.Identifier, for: indexPath) as! CityTableViewCell
        switch indexPath.section {
            case 0:
                if let weatherCity = delegate?.viewWeatherLocation {
                    cell.set(weatherCity: weatherCity)
                }
            case 1:
                if let weatherCity = arrayWeather.get(index: indexPath.row) {
                    cell.set(weatherCity: weatherCity)
                }
            default:
                break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete && indexPath.section == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
            delegate?.removeCity(name:cell.nameCity.text ?? "")
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

}

extension CitiesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                if let name = delegate?.viewWeatherLocation?.city {
                    delegate?.selectCity(name: name)
                }
                navigationController?.popViewController(animated: true)
            case 1:
                delegate?.selectCity(name: arrayWeather[indexPath.row].city)
                navigationController?.popViewController(animated: true)
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .lightGray
        switch section {
            case 0:
                label.text = "Местоположение"
            case 1:
                label.text = "Города"
            default:
                break
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension CitiesTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Array {
    func get(index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
