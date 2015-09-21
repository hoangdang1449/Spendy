//
//  TransactionCell.swift
//  Spendy
//
//  Created by Dave Vo on 9/19/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    var transaction: Transaction! {
        didSet {
            noteLabel.text = transaction.note
            // TODO: use system currency
            println("amount before cast: \(transaction.amount)")
            if let amount = transaction.amount {
                amountLabel.text = String(format: "$%.02f", amount.doubleValue)

            }
            dateLabel.text = transaction.dateOnly()
            // TODO: retrieve balance amount
            balanceLabel.text = "$Balance"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
