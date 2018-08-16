//
//  HYCustumContactCell.swift
//  hynt
//
//  Created by Apple on 8/2/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HYCustumContactCell: UITableViewCell {
    
    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var mobileLbl:UILabel!
    @IBOutlet var initialLbl:UILabel!
    @IBOutlet var lockImage:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
