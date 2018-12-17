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
        
        guard let cityName = сityNameTextField.text else {return}
        
        getObjectsFromApi(attribute: .oneDay, city: "\(cityName)"){ (response) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                disableMyButton?.isEnabled = true
                guard let baseTemperature = response?.main?.temp,
                      let windSpeed = response?.wind?.speed,
                      let weatherDescription = response?.weather?.first?.description,
                      let humidity = response?.main?.humidity,
                      let weatherIcon = response?.weather?.first?.icon
                        else {
                            let alert = UIAlertController(title: "Ошибка", message: "Данных по этому городу нет", preferredStyle: .alert)
                            let subAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alert.addAction(subAlert)
                            self.present(alert, animated: true, completion: nil)
                            return
                }
                
                self.translateWord(wordRu: weatherDescription, translations: .engToRu ) {(response) in
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
    
                        guard let wordEng = response?.text?.first else {
                            print("Ошибка при десериализации объекта при переводе на английский язык")
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
                UserDefaults.standard.set(String(format:"%.1f", baseTemperature - 273) + " ℃", forKey: "cacheTemp")
                UserDefaults.standard.set(String(format:"%.0f", windSpeed) + " м/с", forKey: "cacheWind")
                UserDefaults.standard.set(String(format:"%.0f", humidity) + " %", forKey: "cacheHumidity")
                
                let iconUrl = URL(string: "https://openweathermap.org/img/w/\(weatherIcon).png")
                guard let data = try? Data(contentsOf: iconUrl!) else {return}
                
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
        guard let data = try? Data(contentsOf: iconUrl!) else {return}
        
        fileManager.createFile(atPath: paths, contents: data, attributes: nil)
    }
    
    func getImage(){
        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if fileManager.fileExists(atPath: path){
            self.weatherImageView.image = UIImage(contentsOfFile: path)
        } else{
            print("No Image")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        сityNameTextField.text = UserDefaults.standard.object(forKey: "cacheCity") as? String
        temperatureTextField.text = UserDefaults.standard.object(forKey: "cacheTemp") as? String
        windSpeedTextField.text = UserDefaults.standard.object(forKey: "cacheWind") as? String
        descriptionTextField.text = UserDefaults.standard.object(forKey: "cacheDescription") as? String
        humidityTextField.text = UserDefaults.standard.object(forKey: "cacheHumidity") as? String
        weatherImageView.image = UserDefaults.standard.object(forKey: "cacheIcon") as? UIImage
        
        updateButtonTapped(self)
    }
}

