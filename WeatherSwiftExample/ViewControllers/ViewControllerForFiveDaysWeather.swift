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
    
    var refreshControl = UIRefreshControl()
    var arrayWeather: [Weather] = []
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
        return arrayWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIndetifier", for: indexPath)
            as! TableViewCell
       
       cell.commonInit(image: arrayWeather[indexPath.row].icon, title: arrayWeather[indexPath.row].titleString, maxTemp: arrayWeather[indexPath.row].maxTempString, minTemp: arrayWeather[indexPath.row].minTempString)
        return cell
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //убираем select с выбранной ячейки
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CellIndetifier")
        makeRequest()
     
        //swipe down
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(){
        arrayWeather = []
        makeRequest()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func makeRequest(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        let tommorowDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let oneDayLaterDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
        let twoDaysLaterDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
        let threeDaysLatterDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 4, to: Date())!)
        
        getObjectsFromApi(fullUrl: .fiveDays, city: "Samara" ) { (response) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                
                self.todayFiltered = response?.list?.filter({($0.dtTxt?.contains(todayDate))!})
                self.tommorowFiltered = response?.list?.filter({($0.dtTxt?.contains(tommorowDate))!})
                self.oneDayLaterFiltered = response?.list?.filter({($0.dtTxt?.contains(oneDayLaterDate))!})
                self.twoDaysLaterFiltered = response?.list?.filter({($0.dtTxt?.contains(twoDaysLaterDate))!})
                self.threeDaysLatterFiltered = response?.list?.filter({($0.dtTxt?.contains(threeDaysLatterDate))!})
                
                self.addRow(day: todayDate, filtered: self.todayFiltered!)
                self.addRow(day: tommorowDate, filtered: self.tommorowFiltered!)
                self.addRow(day: oneDayLaterDate, filtered: self.oneDayLaterFiltered!)
                self.addRow(day: twoDaysLaterDate, filtered: self.twoDaysLaterFiltered!)
                self.addRow(day: threeDaysLatterDate, filtered: self.threeDaysLatterFiltered!)
            })
        }
    }
    
    func addRow(day: String, filtered: [List]) -> Void {
        let maxTemperature = (filtered.max(by: { (item1, item2) -> Bool in
            return item1.main!.temp! < item2.main!.temp!
        })?.main?.temp)! - 273
        let minTemperature = (filtered.min(by: { (item1, item2) -> Bool in
            return item1.main!.temp! < item2.main!.temp!
        })?.main?.temp)! - 273
        let iconWeather = filtered.first?.weather?.first?.icon
        let url = URL(string: "https://openweathermap.org/img/w/\(iconWeather!).png")
        
        guard let data = try? Data(contentsOf: url!) else {
            Alerts.showAlert(element: self, message: "Ошибка получения иконки.")
            return
        }
        
        let element  = Weather(icon: UIImage(data: data)!, titleString: day, maxTempString: String(format:"%.1f",maxTemperature), minTempString:String(format:"%.1f", minTemperature))
        
        self.arrayWeather.insert(element, at: self.arrayWeather.count)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: .automatic)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        self.tableView.endUpdates()
    }
}
