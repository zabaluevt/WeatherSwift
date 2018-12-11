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
                
                let listAtMidnight = response?.list?.filter({($0.dtTxt?.contains("00:00:00"))!})
                let listAtThreeOclock = response?.list?.filter({($0.dtTxt?.contains("03:00:00"))!})
                let listAtSixOclock = response?.list?.filter({($0.dtTxt?.contains("06:00:00"))!})
                let listAtNineOclock = response?.list?.filter({($0.dtTxt?.contains("09:00:00"))!})
                let listAtTwelveOclock = response?.list?.filter({($0.dtTxt?.contains("12:00:00"))!})
                let listAtFifteenOclock = response?.list?.filter({($0.dtTxt?.contains("15:00:00"))!})
                let listAtEighteenOclock = response?.list?.filter({($0.dtTxt?.contains("18:00:00"))!})
                let listAtTwentyOneOclock = response?.list?.filter({($0.dtTxt?.contains("21:00:00"))!})
                
            })
        }
    }
}


