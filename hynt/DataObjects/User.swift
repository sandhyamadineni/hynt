//
//  User.swift
//  hynt
//
//  Created by Apple on 8/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class User: NSObject {
    var uid:Int32?
    var userName:String?
    var email:String?
    var mobileNumber:String?
    var countryCode:String?
    var password:String?
    var profileImage:UIImage?
    var security:String?
    var answer:String?
    var terms:Int?
    
    override init() {
        super.init()
    }
    
    static var currentUser = { () -> User in
        let userInfo = User()
        
        return userInfo
    }()
    
    init(name:String, email:String, mobile:String, code:String,pwd:String, sec:String,ans:String) {
        self.userName = name
        self.email = email
        self.mobileNumber = mobile
        self.password = pwd
        self.countryCode = code
        self.security = sec
        self.answer = ans
    }
    
    /*init(_ id:Int, _ name:String, _ email:String,_ number:String, _ countryCode:String, _ pwd:String, _ profile:UIImage,_ securityQ:String,_ ans:String, _ terms:Int) {
        self.uid = id
        self.userName = name
        self.email = email;
        self.mobileNumber = number
        self.countryCode = countryCode
        self.password = pwd
        self.profileImage = profile
        self.security = securityQ
        self.answer = ans
        self.terms = terms
    }*/
}
