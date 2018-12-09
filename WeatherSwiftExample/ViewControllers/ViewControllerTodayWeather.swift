//
//  ViewController.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 22.11.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class ViewControllerTodayWeather: BaseViewController {
    
    @IBOutlet var сityNameTextField: UITextField!
    @IBOutlet var temperatureTextField: UITextField!
    @IBOutlet var windSpeedTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBAction func UpdateButtonTapped(_ sender: Any) {
        
        guard let city = сityNameTextField.text else {return}
        
        getObjectsFromApi(attribute: .oneDay, city: "\(city)"){ (response) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                guard let temp = response?.main?.temp,
                      let windSpeed = response?.wind?.speed,
                    let description = response?.weather?.first?.description
                    else { return }
                
                self.TranslateWord(wordRu: description, translations: .engToRu ) {(response) in
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        guard let wordEng = response?.text?.first else {
                            print("Ошибка при десериализации объекта при переводе на английский язык")
                            return
                        }
                        self.descriptionTextField.text = wordEng
                    })
                }
                
                UserDefaults.standard.set(city, forKey: "cacheCity")
                UserDefaults.standard.set(String(format:"%.1f", temp - 273) + " ℃", forKey: "cacheTemp")
                UserDefaults.standard.set(String(format:"%.0f", windSpeed) + " м/с", forKey: "cacheWind")
                
                self.temperatureTextField.text = String(format:"%.1f", temp - 273) + " ℃"
                self.windSpeedTextField.text = String(format:"%.0f", windSpeed) + " м/с"
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        сityNameTextField.text = UserDefaults.standard.object(forKey: "cacheCity") as? String
        temperatureTextField.text = UserDefaults.standard.object(forKey: "cacheTemp") as? String
        windSpeedTextField.text = UserDefaults.standard.object(forKey: "cacheWind") as? String

        UpdateButtonTapped(self)
    }
}

