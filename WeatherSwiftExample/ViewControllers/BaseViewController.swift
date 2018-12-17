//
//  BaseViewController.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 04.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController{

    let baseUrl = "http://api.openweathermap.org/data/2.5/"
    let appId = "&APPID=96e1acdb11e7e23103af509121e8c25f"
    
    enum UrlAttribute : String {
        case oneDay = "weather?q="
        case fiveDays = "forecast?q="
    }
    
    enum Translations: String {
        case ruToEng = "ru-en"
        case engToRu = "en-ru"
    }
    
    func getObjectsFromApi(attribute: UrlAttribute, city: String, completion: @escaping (JsonResponse?) -> Void){
        
        let regex = try! NSRegularExpression(pattern: "[А-я]+", options: [])
        let matches = regex.matches(in: city, options: [], range: NSRange(location: 0, length: city.count))

        let match = matches.first.map {
            String(city[Range($0.range, in: city)!])
        }
        if (match != nil){
            translateWord(wordRu: match!, translations: .ruToEng) {(response) in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    guard let cityEng = response?.text?.first else {
                        Alerts.showAlert(element: self, message: "Ошибка при десериализации объекта при переводе.")
                        return
                    }
                    let fullUrl = "\(self.baseUrl)\(attribute.rawValue)\(cityEng)\(self.appId)"
                    guard let url = URL(string: fullUrl) else {
                        Alerts.showAlert(element: self, message: "Ошибка преобразования URL")
                        return }
                    self.addNewSession(url: url, completion: completion)
                })
            }
        }
        else {
            let fullUrl = "\(self.baseUrl)\(attribute.rawValue)\(city)\(self.appId)"
            guard let url = URL(string: fullUrl) else {
                Alerts.showAlert(element: self, message: "Ошибка преобразования URL")
                return }
            self.addNewSession(url: url, completion: completion)
        }
    }
    
    func addNewSession(url: URL, completion: @escaping (JsonResponse?) -> Void){
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil{
                Alerts.showAlert(element: self, message: "Ошибка создания сессии")
                print(error!)
            }
            else {
                guard let data = data
                    else {
                        Alerts.showAlert(element: self, message: "Полученных данных нет.")
                        return
                }
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let topAnswerer = try decoder.decode(JsonResponse.self, from: data)
                    completion(topAnswerer)
                }
                catch let jsonError {
                    Alerts.showAlert(element: self, message: "Произошла ошибка десериализации.")
                    print (jsonError)
                }
            }
        }.resume()
    }
    
    func translateWord(wordRu: String, translations: Translations,  completion: @escaping (JsonTranslateResponse?) -> Void){
        
        let fullUrl = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20181205T161427Z.cce92144cf1f9c6a.46d2dd5b3cff3f23da459985fa95dc728746322c&text=\(wordRu)&lang=\(translations.rawValue)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
       
        guard let url = URL(string: fullUrl)
            else {
                Alerts.showAlert(element: self, message: "Невозможно преобразовать URL.")
                return
            }
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil{
                Alerts.showAlert(element: self, message: "Такого интернет адреса не существует.")
                print(error!)
            }
            else {
                guard let data = data
                    else {
                        Alerts.showAlert(element: self, message: "Полученных данных нет.")
                        return
                }
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let topAnswerer = try decoder.decode(JsonTranslateResponse.self, from: data)
                    completion(topAnswerer)
                }
                catch let jsonError {
                    Alerts.showAlert(element: self, message: "Произошла ошибка десериализации.")
                    print (jsonError)
                }
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background.jpg")!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard CheckInternet.connection() else{
            Alerts.showAlert(element: self, message: "Соединение с интернетом отсутствует")
            return
        }
    }
}
