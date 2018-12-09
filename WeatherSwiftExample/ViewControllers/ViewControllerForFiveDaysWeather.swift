//
//  ViewControllerForFiveDaysWeather.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 02.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

//https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20181205T161427Z.cce92144cf1f9c6a.46d2dd5b3cff3f23da459985fa95dc728746322c&text=переводимый&lang=ru-en
class ViewControllerForFiveDaysWeather: BaseViewController {
    
    @IBOutlet var temperatureTomorrow: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getObjectsFromApi(attribute: .fiveDays, city: "Samara" ) { (response) in
            
            let queue = DispatchQueue.global(qos: .utility)
            queue.async{
                print("Json parsed")
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                guard let temp = response?.list?.first?.main?.temp else { return }
                self.temperatureTomorrow.text = String(format:"%.1f", temp - 273)
            })
        }
    }
}


