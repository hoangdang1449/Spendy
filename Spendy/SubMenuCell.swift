//
//  SubMenuCell.swift
//  Spendy
//
//  Created by Dave Vo on 9/21/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class SubMenuCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
