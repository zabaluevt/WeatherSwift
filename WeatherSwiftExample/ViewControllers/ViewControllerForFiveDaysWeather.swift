//
//  ViewControllerForFiveDaysWeather.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 02.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class ViewControllerForFiveDaysWeather: BaseViewController {
    
    @IBOutlet var temperatureTomorrow: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getObjectsFromApi(attribute: .fiveDays, city: "Samara" ) { (response) in
           
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                guard let temp = response?.list?.first?.main?.temp else { return }
                self.temperatureTomorrow.text = String(format:"%.1f", temp - 273)
                                
                //let flatmapArray = response?.list?.first(where: { ($0.dtTxt?.contains("0"))!})
               // let flatmapArray = response?.list?.filter{($0.dtTxt ==  "2018-12-11 03:00:00")}.first
                
            })
        }
    }
}


