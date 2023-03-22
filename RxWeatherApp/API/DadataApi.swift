//
//  DadataApi.swift
//  RxWeatherApp
//
//  Created by антон кочетков on 15.03.2023.
//

import Foundation

struct DadataApi {
    static let apiKey = "9b362193dbff06d153128cff652444ce66ce29ea"
    static let baseUrlComponents: URLComponents = {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "suggestions.dadata.ru"
        url.path = "/suggestions/api/4_1/rs/"
        return url
    }()
    
    struct Requests {
        static let address = "suggest/address"
    }
}
