//
//  extension+Int.swift
//  RxWeatherApp
//
//  Created by антон кочетков on 15.02.2023.
//

import Foundation

extension Int {
    var tempString: String {
        if self > 0 {
            return "+\(self)°"
        } else {
            return "\(self)°"
        }
       
    }
}
