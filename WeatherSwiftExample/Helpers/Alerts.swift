//
//  Alerts.swift
//  WeatherSwiftExample
//
//  Created by Ольга Забалуева on 17.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class Alerts {

    static func showAlert(element: UIViewController, message: String){
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let subAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(subAlert)
        
        element.present(alert, animated: true, completion: nil)
    }
}
