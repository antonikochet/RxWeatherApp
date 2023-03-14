//
//  extension+Array.swift
//  RxWeatherApp
//
//  Created by антон кочетков on 15.02.2023.
//

import Foundation

extension Array {
    init(repeating: (() -> Element), count: Int) {
        self = []
        for _ in 0..<count {
            self.append(repeating())
        }
    }
}
