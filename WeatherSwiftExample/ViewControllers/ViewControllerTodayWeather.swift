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
    @IBOutlet var humidityTextField: UITextField!
    @IBOutlet var weatherImageView: UIImageView!
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        let disableMyButton = sender as? UIButton
        disableMyButton?.isEnabled = false
        
        guard let cityName = сityNameTextField.text else {
            Alerts.showAlert(element: self, message: "Введите название города.")
            return
        }
        
        getObjectsFromApi(attribute: .oneDay, city: "\(cityName)"){ (response) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                disableMyButton?.isEnabled = true
                guard let baseTemperature = response?.main?.temp,
                      let windSpeed = response?.wind?.speed,
                      let weatherDescription = response?.weather?.first?.description,
                      let humidity = response?.main?.humidity,
                      let weatherIcon = response?.weather?.first?.icon
                        else {
                            Alerts.showAlert(element: self, message: "Данных по этому городу нет.")
                            return
                        }
                
                self.translateWord(wordRu: weatherDescription, translations: .engToRu ) {(response) in
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        guard let wordEng = response?.text?.first else {
                            Alerts.showAlert(element: self, message: "Ошибка при десериализации объекта при переводе на английский язык.")
                            return
                        }
                        self.descriptionTextField.text = wordEng
                        
                        UserDefaults.standard.set(wordEng, forKey: "cacheDescription")
                    })
                }
                
                self.temperatureTextField.text = String(format:"%.1f", baseTemperature - 273) + " ℃"
                self.windSpeedTextField.text = String(format:"%.0f", windSpeed) + " м/с"
                self.humidityTextField.text = String(format:"%.0f", humidity) +  " %"
                
                UserDefaults.standard.set(cityName, forKey: "cacheCity")
                UserDefaults.standard.set(String(format:"%.1f", baseTemperature - 273), forKey: "cacheTemperature")
                UserDefaults.standard.set(String(format:"%.0f", windSpeed), forKey: "cacheWind")
                UserDefaults.standard.set(String(format:"%.0f", humidity), forKey: "cacheHumidity")
                
                let iconUrl = URL(string: "https://openweathermap.org/img/w/\(weatherIcon).png")
                guard let data = try? Data(contentsOf: iconUrl!) else {
                    Alerts.showAlert(element: self, message: "Ошибка получения иконки.")
                    return
                }
                
                //Необходимо доработать сохранение иконки на девайс
                //self.saveImageDocumentDirectory(icon: iconUrl)
                //self.getImage()
                self.weatherImageView.image = UIImage(data: data)
                UserDefaults.standard.set(data, forKey: "cacheIcon")
            })
        }
    }
    
    func saveImageDocumentDirectory(icon: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("apple.png")
        let iconUrl = URL(string: "https://openweathermap.org/img/w/\(icon).png")
        guard let data = try? Data(contentsOf: iconUrl!) else {
            Alerts.showAlert(element: self, message: "Ошибка получения иконки.")
            return
            
        }
        
        fileManager.createFile(atPath: paths, contents: data, attributes: nil)
    }
    
    func getImage(){
        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if fileManager.fileExists(atPath: path){
            self.weatherImageView.image = UIImage(contentsOfFile: path)
        } else{
            Alerts.showAlert(element: self, message: "Ошибка получения иконки.")
            print("No Image")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        сityNameTextField.text = UserDefaults.standard.object(forKey: "cacheCity") as? String
        descriptionTextField.text = UserDefaults.standard.object(forKey: "cacheDescription") as? String
        weatherImageView.image = UserDefaults.standard.object(forKey: "cacheIcon") as? UIImage
        
        if let cachedTemperature = UserDefaults.standard.object(forKey: "cacheTemperature") as? String{
            temperatureTextField.text = cachedTemperature + " ℃"
        }
        if let cachedWindSpeed = UserDefaults.standard.object(forKey: "cacheWind") as? String {
            windSpeedTextField.text = cachedWindSpeed + " м/с"
        }
        if let cachedHumidity = UserDefaults.standard.object(forKey: "cacheHumidity") as? String{
            humidityTextField.text = cachedHumidity
        }
        
        updateButtonTapped(self)
    }
}

