//
//  Reminder.swift
//  hynt
//
//  Created by Apple on 8/14/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class Reminder: NSObject {
    var rid:Int32?
    var fromUserId:Int32?
    var torecipients:[String]?
    var desc:String?
    var toType:String?
    var recurrence:String?
    var dateAndTime:String?
    var minutes:Int32 = 0
    var isSelf:Int32?
    var isMin:Int32?
    var rImage:UIImage?
    var rAudio:Data?
    var isVisit:Int32?
    var isTriggered:Int32?
    
    static var currentReminder = { () -> Reminder in
        let reminderInfo = Reminder()
        
        return reminderInfo
    }()
}
