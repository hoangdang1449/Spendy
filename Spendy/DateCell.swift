//
//  DateCell.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        datePicker.alpha = 0
        datePicker.backgroundColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onDatePicker(sender: AnyObject) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E, MMM dd, yyyy"
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        dateLabel.text = strDate
    }
    

}
