//
//  ViewControllerForFiveDaysWeather.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 02.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class ViewControllerForFiveDaysWeather: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    var array: [Weather] = []
    var todayFiltered, tommorowFiltered, oneDayLaterFiltered, twoDaysLaterFiltered, threeDaysLatterFiltered: [List]?
    
    struct Weather {
        var icon: UIImage
        var titleString: String
        var maxTempString: String
        var minTempString: String
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showDetails", sender: todayFiltered)
            break
        case 1:
            performSegue(withIdentifier: "showDetails", sender: tommorowFiltered)
            break
        case 2:
            performSegue(withIdentifier: "showDetails", sender: oneDayLaterFiltered)
            break
        case 3:
            performSegue(withIdentifier: "showDetails", sender: twoDaysLaterFiltered)
            break
        case 4:
            performSegue(withIdentifier: "showDetails", sender: threeDaysLatterFiltered)
            break
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showDetails" {
            let model = sender as! [List]
            let controller = segue.destination as! ViewControllerModal
            controller.list = model
        }
    }
    
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        let tommorow = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let oneDayLater = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
        let twoDaysLater = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
        let threeDaysLatter = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 4, to: Date())!)
    
        getObjectsFromApi(attribute: .fiveDays, city: "Samara" ) { (response) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                
                self.todayFiltered = response?.list?.filter({($0.dtTxt?.contains(today))!})
                self.tommorowFiltered = response?.list?.filter({($0.dtTxt?.contains(tommorow))!})
                self.oneDayLaterFiltered = response?.list?.filter({($0.dtTxt?.contains(oneDayLater))!})
                self.twoDaysLaterFiltered = response?.list?.filter({($0.dtTxt?.contains(twoDaysLater))!})
                self.threeDaysLatterFiltered = response?.list?.filter({($0.dtTxt?.contains(threeDaysLatter))!})
               
                self.addRow(day: today, filtered: self.todayFiltered!)
                self.addRow(day: tommorow, filtered: self.tommorowFiltered!)
                self.addRow(day: oneDayLater, filtered: self.oneDayLaterFiltered!)
                self.addRow(day: twoDaysLater, filtered: self.twoDaysLaterFiltered!)
                self.addRow(day: threeDaysLatter, filtered: self.threeDaysLatterFiltered!)
            })
        }
    }
    
    func addRow(day: String, filtered: [List]) -> Void {
        
        let maxTemp = (filtered.max(by: { (a, b) -> Bool in
            return a.main!.temp! < b.main!.temp!
        })?.main?.temp)! - 273
        
        let minTemp = (filtered.min(by: { (a, b) -> Bool in
            return a.main!.temp! < b.main!.temp!
        })?.main?.temp)! - 273
        
        let icon = filtered.first?.weather?.first?.icon
        let url = URL(string: "https://openweathermap.org/img/w/\(icon!).png")
        guard let data = try? Data(contentsOf: url!) else {return}
        
        let element  = Weather(icon: UIImage(data: data)!, titleString: day, maxTempString: String(format:"%.1f",maxTemp), minTempString:String(format:"%.1f", minTemp))
        
        self.array.insert(element, at: self.array.count)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: .automatic)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        self.tableView.endUpdates()
    }
}
