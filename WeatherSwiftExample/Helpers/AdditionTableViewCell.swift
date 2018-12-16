//
//  AdditionTableViewCell.swift
//  WeatherSwiftExample
//
//  Created by Тимофей Забалуев on 16.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import UIKit

class AdditionTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var IconImageView: UIImageView!
    
    func commonInit(time: String, degrees: String, icon: UIImage){
        timeLabel.text = time
        degreesLabel.text = degrees
        IconImageView.image = icon
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        // Configure the view for the selected state
    }
    
}
