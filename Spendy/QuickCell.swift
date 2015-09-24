//
//  QuickCell.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class QuickCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var amoutSegment: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let font = UIFont.systemFontOfSize(17)
        let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
        amoutSegment.setTitleTextAttributes(attributes as [NSObject : AnyObject], forState: UIControlState.Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
