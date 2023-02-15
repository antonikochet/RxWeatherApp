//
//  Error.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation

struct ErrorServer: Codable {
    let cod: String
    let message: String
    
    var description: String {
        return "Ошибка \(cod) - \(message)"
    }
}
