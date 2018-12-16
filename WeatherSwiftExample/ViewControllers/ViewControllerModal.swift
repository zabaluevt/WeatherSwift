//
//  ViewControllerModal.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 16.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class ViewControllerModal: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    var list: [List] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AdditionTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AdditionCellIndetifier")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionCellIndetifier", for: indexPath)
            as! AdditionTableViewCell
        
        let time:String = list[indexPath.row].dtTxt!.components(separatedBy: " ")[1]
        
        let icon = list[indexPath.row].weather?.first?.icon
        let url = URL(string: "https://openweathermap.org/img/w/\(icon!).png")
        let data = try? Data(contentsOf: url!)
        
        cell.commonInit(time: time, degrees: String(format:"%.1f", ((list[indexPath.row].main?.temp)! - 273)), icon: UIImage(data: data!)!)
        
        return cell
    }
}
