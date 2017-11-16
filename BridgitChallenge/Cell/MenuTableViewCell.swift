//
//  MenuTableViewCell.swift
//  BridgitChallenge
//
//  Created by Nan Chen on 2017-11-13.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var titleLabel: UILabel!
    
}
