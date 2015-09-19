//
//  TimeCell.swift
//  Spendy
//
//  Created by Dave Vo on 9/19/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit
import SevenSwitch

@objc protocol TimeCellDelegate {
    optional func timeCell(timeCell: TimeCell, didChangeValue value: Bool)
}

class TimeCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var switchView: UIView!
    
    var onSwitch: SevenSwitch!
    
    var delegate: TimeCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch = SevenSwitch(frame: CGRect(x: 0, y: 0, width: 42, height: 25))
        
        onSwitch.thumbTintColor = UIColor.whiteColor()
        onSwitch.activeColor =  UIColor.clearColor()
        onSwitch.inactiveColor =  UIColor.clearColor()
        onSwitch.onTintColor =  UIColor(netHex: 0x55AEED)
        onSwitch.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        onSwitch.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        
        switchView.addSubview(onSwitch)
        
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        if delegate != nil {
            delegate?.timeCell?(self, didChangeValue: onSwitch.on)
        }
    }

}
