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
        
        getObjectsFromApi(fullUrl: .oneDay, city: "\(cityName)"){ (response) in
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
                        guard let wordRu = response?.text?.first else {
                            Alerts.showAlert(element: self, message: "Ошибка при десериализации объекта при переводе на английский язык.")
                            return
                        }
                        self.descriptionTextField.text = wordRu
                        self.cache(dictionary: ["cacheDescription": wordRu])
                    })
                }
                
                self.temperatureTextField.text = String(format:"%.1f", baseTemperature - 273) + " ℃"
                self.windSpeedTextField.text = String(format:"%.0f", windSpeed) + " м/с"
                self.humidityTextField.text = String(format:"%.0f", humidity) +  " %"
                
                let iconUrl = URL(string: "https://openweathermap.org/img/w/\(weatherIcon).png")
                guard let data = try? Data(contentsOf: iconUrl!) else {
                    Alerts.showAlert(element: self, message: "Ошибка получения иконки.")
                    return
                }
                
                self.saveImageDocumentDirectory(data: data)
                self.weatherImageView.image = UIImage(data: data)
                
                let dictionary: [String:Any] = ["cacheCity": cityName, "cacheTemperature": String(format:"%.1f", baseTemperature - 273), "cacheWind": String(format:"%.0f", windSpeed), "cacheHumidity": String(format:"%.0f", humidity)]
                self.cache(dictionary: dictionary)
            })
        }
    }
    func cache(dictionary: [String: Any]){
        for (key, value) in dictionary{
            UserDefaults.standard.set(value, forKey: key)
        }
    }
    
    func saveImageDocumentDirectory(data: Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("icon.jpg")
        
        fileManager.createFile(atPath: paths as String, contents: data, attributes: nil)
        }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage() {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("icon.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            self.weatherImageView.image = UIImage(contentsOfFile: imagePAth)
        }else{
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
            humidityTextField.text = cachedHumidity + " %"
        }
        self.getImage()
        
        updateButtonTapped(self)
    }
}

