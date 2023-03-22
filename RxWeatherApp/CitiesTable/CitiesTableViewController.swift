//
//  CitiesTableViewController.swift
//  Weather App
//
//  Created by Антон Кочетков on 07.11.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CitiesTableViewController: UIViewController {
    private let cityTextField = UITextField()
    private let searchButton = UIButton()
    private let tableView = UITableView()
    
    private var viewModel: CitiesTableViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupScreen()
        setupCityTextField()
        setupTableView()
        setupSearchButton()
    }
    private func setupScreen() {
        view.backgroundColor = .white
    }
    private func setupCityTextField() {
        cityTextField.placeholder = "Введите город"
        cityTextField.borderStyle = .roundedRect
        cityTextField.clearButtonMode = .whileEditing
        cityTextField.delegate = self
        
        view.addSubview(cityTextField)
        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
        }
    }
    private func setupTableView() {
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.Identifier)
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(16)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    private func setupSearchButton() {
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)
        searchButton.contentMode = .scaleAspectFit
        searchButton.setImage(image, for: .normal)
        searchButton.tintColor = .black
        searchButton.addTarget(self, action: #selector(actionSearchCity), for: .touchUpInside)
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(cityTextField.snp.height)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(cityTextField.snp.trailing).offset(8)
            make.width.equalToSuperview().multipliedBy(1/16)
        }
    }
    
    @objc private func actionSearchCity() {
        guard let textField = cityTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard textField.count != 0 else { return }
//        if arrayWeather.contains(where: { $0.city == textField }) {
//            alertErrorController(title: "Предупреждение", message: "Город '\(textField)' уже есть в списке")
//        } else {
//            delegate?.addNewCity(name: textField)
//            navigationController?.popViewController(animated: true)
//        }
    }
    
    func bind(to viewModel: CitiesTableViewModel) {
        self.viewModel = viewModel
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        cityTextField.rx.text.orEmpty
            .asObservable()
            .bind(to: viewModel.searchQuerySubject)
            .disposed(by: disposeBag)
        
        viewModel.cities
            .drive(tableView.rx.items(cellIdentifier: CityTableViewCell.Identifier)) {
                (index, vm: CityCellViewModel, cell: CityTableViewCell) in
                cell.set(vm)
        }
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .asObservable()
            .bind(to: viewModel.didSelectCity)
            .disposed(by: disposeBag)
    }
}

extension CitiesTableViewController {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete && indexPath.section == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
//            delegate?.removeCity(name:cell.nameCity.text ?? "")
            tableView.deleteRows(at: [indexPath], with: .left)
        }
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
