//
//  HYContact.swift
//  hynt
//
//  Created by Apple on 8/2/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HYContact: NSObject {
    var name:String?
    var mobile:String?
    var initialC:String?
    
    override init() {
        super.init()
    }
    
    init(_ hname:String, _ hmobile:String, _ hinitialC:String) {
        self.name = hname
        self.mobile = hmobile
        self.initialC = hinitialC
    }
    
}
