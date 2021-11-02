//
//  EnumsAPI.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//

import Foundation

enum AnswerServer {
    case success(Codable)
    case failure(ErrorServer)
}

enum TypeGettingCurrectWeather {
    case city(String)
    case id(Int)
    case location(Double, Double)
    
    func generateURLQueryItem() -> [URLQueryItem] {
        switch self {
            case .city(let name):
                return [URLQueryItem(name: "q", value: name)]
            case .id(let id):
                return [URLQueryItem(name: "id", value: String(id))]
            case .location(let lat, let lon):
                return [URLQueryItem(name: "lat", value: String(lat)),
                        URLQueryItem(name: "lon", value: String(lon))]
        }
    }
}

enum Units: String {
    case standart
    case metric
    case imperial
    
    var nameHeader: String {
        return "units"
    }
}

enum Lang: String {
    case ru
    case en
    
    var nameHeader: String {
        return "lang"
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}


