//
//  InboxCustomCell.swift
//  hynt
//
//  Created by Apple on 8/15/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class InboxCustomCell: UITableViewCell {
    
    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var mobileLbl:UILabel!
    @IBOutlet var descLbl:UILabel!
    @IBOutlet var timeLbl:UILabel!
    @IBOutlet var backView:UIView!
    @IBOutlet var dotView:UIView!
    @IBOutlet var profilePic:UIImageView!
    @IBOutlet var deleteReminder:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 10
        dotView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
