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
            // TODO: change back to just note
            noteLabel.text = transaction.note
            // display Meal here to debug
            // noteLabel.text = "\(transaction.note!) (\(transaction.category()!.name!))"
            // TODO: use system currency
            if let amount = transaction.amount {
                amountLabel.text = transaction.formattedAmount()
            }
            dateLabel.text = transaction.dateOnly()
            // TODO: retrieve balance amount
            balanceLabel.text = "$Balance"

            if let icon = transaction.category()?.icon {
                iconView.image = UIImage(named: icon)
            }

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
