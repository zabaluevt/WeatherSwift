//
//  TableViewCell.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 15.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    func commonInit(image: UIImage, title: String, maxTemp: String, minTemp: String){
        iconImageView.image = image
        titleLabel.text = title
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
