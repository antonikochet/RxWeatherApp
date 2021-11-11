//
//  CitiesTableViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 07.11.2021.
//

import UIKit

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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        if arrayCities.contains(where: { $0 == textField }) {
            alertErrorController(title: "Предупреждение", message: "Город '\(textField)' уже есть в списке")
        } else {
            delegate?.addNewCity(name: textField)
            navigationController?.popViewController(animated: true)
        }
        
    }
}

extension CitiesTableViewController: UITableViewDataSource {
    
    private var arrayCities: [String] {
        return delegate?.arrayCities ?? []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let nameCity = arrayCities.get(index: indexPath.row) {
            cell.textLabel?.text = nameCity
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath)
            delegate?.removeCity(name:cell?.textLabel?.text ?? "")
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

extension CitiesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectCity(name: arrayCities[indexPath.row])
        navigationController?.popViewController(animated: true)
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
