//
//  ViewControllerForFiveDaysWeather.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 02.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class ViewControllerForFiveDaysWeather: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    struct Weather {
        var icon: UIImage
        var titleString: String
        var maxTempString: String
        var minTempString: String
    }

    
    @IBOutlet var tableView: UITableView!
    
    var array: [Weather] = []
    var dayArray: [String] = []
    var descriptionArray: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIndetifier", for: indexPath)
            as! TableViewCell
       
       cell.commonInit(image: array[indexPath.row].icon, title: array[indexPath.row].titleString, maxTemp: array[indexPath.row].maxTempString, minTemp: array[indexPath.row].minTempString)
       
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CellIndetifier")
        
        getObjectsFromApi(attribute: .fiveDays, city: "Samara" ) { (response) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                guard let temp = response?.list?.first?.main?.temp else { return }
                
                let listAtMidnight = response?.list?.filter({($0.dtTxt?.contains("00:00:00"))!})
                let listAtThreeOclock = response?.list?.filter({($0.dtTxt?.contains("03:00:00"))!})
                let listAtSixOclock = response?.list?.filter({($0.dtTxt?.contains("06:00:00"))!})
                let listAtNineOclock = response?.list?.filter({($0.dtTxt?.contains("09:00:00"))!})
                let listAtTwelveOclock = response?.list?.filter({($0.dtTxt?.contains("12:00:00"))!})
                let listAtFifteenOclock = response?.list?.filter({($0.dtTxt?.contains("15:00:00"))!})
                let listAtEighteenOclock = response?.list?.filter({($0.dtTxt?.contains("18:00:00"))!})
                let listAtTwentyOneOclock = response?.list?.filter({($0.dtTxt?.contains("21:00:00"))!})

                let dateFormatter = DateFormatter()
                
                
                listAtFifteenOclock?.enumerated().forEach { (index, item) in
                    
                    let minTemp = listAtThreeOclock?[index].main?.tempMin
                    //Плохой код :(  и на английском месяц
                    dateFormatter.dateFormat = "Y-MM-d H:mm:ss"
                    let dateObj = dateFormatter.date(from: item.dtTxt!)
                    dateFormatter.dateFormat = "d MMMM"
                    let dateString =  dateFormatter.string(from: dateObj!)
                    
                    let icon =  item.weather?.first?.icon
                    let url = URL(string: "https://openweathermap.org/img/w/\(icon!).png")
                    guard let data = try? Data(contentsOf: url!) else {return}
                    
                    let element  = Weather(icon: UIImage(data: data)!, titleString: dateString, maxTempString: String(format:"%.1f",(item.main?.temp)! - 273), minTempString:String(format:"%.1f",minTemp! - 273))
                    
                    self.array.insert(element, at: self.array.count)
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: .automatic)
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
                    self.tableView.endUpdates()

                }
            })
        }
    }
}


