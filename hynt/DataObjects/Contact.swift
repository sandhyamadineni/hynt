//
//  Contact.swift
//  hynt
//
//  Created by Apple on 8/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var cName:String?
    var mobileNumber:String? 
    
    static var currentContact = { () -> Contact in
        let contactInfo = Contact()
        
        return contactInfo
    }()
}
