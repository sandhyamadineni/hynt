//
//  CarouselCustomView.swift
//  hynt
//
//  Created by Apple on 8/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CarouselCustomView: UIView {

    @IBOutlet var backView:UIView!
    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var phoneLbl:UILabel!
    @IBOutlet var desLbl:UILabel!
    @IBOutlet var dateLbl:UILabel!
    @IBOutlet var timeLblLbl:UILabel!
    @IBOutlet var viewMoreLbl:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
