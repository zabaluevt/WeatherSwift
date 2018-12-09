//
//  APIRequests.swift
//  WeatherSwiftExample
//
//  Created by Ольга Забалуева on 02.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//
import UIKit

class APIRequests: UIViewController {
    let baseUrl = "http://api.openweathermap.org/"
    let stringForToday = "weather"
    let stringForFiveDays = "forecast"
    
    static func GetRequestFromApi() -> Void {
//        getObjectsFromApi(path: "data/2.5/weather?id=499099"){ (response) in
//
//            let queue = DispatchQueue.global(qos: .utility)
//            queue.async{
//                //sleep(2)
//                //self.temperatureOutlet.text = String(format:"%.1f", response?.main?.temp ?? "")
//
//                print("Success")
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                guard let temp = response?.main?.temp else { return }
//
//                self.temperatureOutlet.text = String(format:"%.1f", temp - 273)
//                self.WindSpeed.text = String(format:"%.1f", response?.wind?.speed ?? "")
//            })
//        }
        getObjectsFromApiUrl(path: "", completion: nil){
            
        }
        }
    
    }
    func getObjectsFromApiUrl(path: String, completion: @escaping (JsonResponse?) -> Void){
        let fullUrl = "\(baseUrl)\(path)" + "&APPID=96e1acdb11e7e23103af509121e8c25f"
        guard let url = URL(string: fullUrl)
            else { return }
        
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil{
                print(error!)
            }
            else {
                guard let data = data
                    else { return }
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let topAnswerer = try decoder.decode(JsonResponse.self, from: data)
                    completion(topAnswerer)
                }
                catch let jsonError {
                    print (jsonError)
                }
            }
            }.resume()
    }
    
}
