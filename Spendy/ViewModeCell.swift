//
//  ViewModeCell.swift
//  Spendy
//
//  Created by Dave Vo on 9/22/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class ViewModeCell: UITableViewCell {
    
    @IBOutlet weak var modeLabel: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
