//
//  CurrectWeather.swift
//  Weather App
//
//  Created by Антон Кочетков on 02.11.2021.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let currectWeather = try? newJSONDecoder().decode(CurrectWeather.self, from: jsonData)

import Foundation

// MARK: - CurrectWeather
struct Currect: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: SysCurrect
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - SysCurrect
struct SysCurrect: Codable {
    let type, id: Int
    let message: Double?
    let country: String
    let sunrise, sunset: Int
}
