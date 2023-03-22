//
//  SuggestionsRequest.swift
//  RxWeatherApp
//
//  Created by антон кочетков on 15.03.2023.
//

import Foundation

struct SuggestionsResponse: Decodable {
    let suggestions: [SuggestionResponse]
}

struct SuggestionResponse: Decodable {
    let data: SuggestionDataResponse
}

struct SuggestionDataResponse: Decodable {
    let city: String?
}

public enum ScaleLevel: String, Encodable {
    case country = "country"
    case region = "region"
    case area = "area"
    case city = "city"
    case settlement = "settlement"
    case street = "street"
    case house = "house"
}

public struct ScaleBound: Encodable{
    public var value: ScaleLevel?
    
    public init(value: ScaleLevel?){ self.value = value }
}

struct SuggestionsRequest: Encodable {
    let query: String
    var upperScaleLimit: ScaleBound?
    var lowerScaleLimit: ScaleBound?
    
    mutating func toJSON() throws -> Data {
        if let upper = upperScaleLimit,
            let lower = lowerScaleLimit,
            upper.value == nil || lower.value == nil {
            upperScaleLimit = nil
            lowerScaleLimit = nil
        }
        return try JSONEncoder().encode(self)
    }
    
    enum CodingKeys: String, CodingKey {
        case query
        case upperScaleLimit = "from_bound"
        case lowerScaleLimit = "to_bound"
    }
}
