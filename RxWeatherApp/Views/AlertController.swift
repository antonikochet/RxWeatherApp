//
//  AlertController.swift
//  Weather App
//
//  Created by Антон Кочетков on 03.11.2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertErrorController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertOK)
        
        present(alertController, animated: true, completion: nil)
    }
}
