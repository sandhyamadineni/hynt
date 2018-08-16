//
//  AppDelegate.swift
//  hynt
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import DropDown
import JVFloatLabeledTextField

var encryptionKeyString = "com.sandhya.hynt"


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension JVFloatLabeledTextField {
    func customize(placeholder:String, title:String) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabelActiveTextColor = UIColor.blue;
        self.floatingLabelFont = UIFont.init(name: "Courier", size: 13)
        self.textAlignment = .left;
        self.setPlaceholder(placeholder, floatingTitle: title)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightPasswordImage() {
        let imageView2 = UIButton(type: .custom)
        imageView2.backgroundColor = UIColor.orange
        imageView2.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView2.contentMode = .scaleAspectFit
        imageView2.setImage(UIImage.init(named: "hidePass"), for: .normal)
        imageView2.setImage(UIImage.init(named: "showPass"), for: .selected)
        self.rightView = imageView2
        self.rightViewMode = .always
        self.isSecureTextEntry = true
    }
}

extension String {
    func flag() -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in self.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }
        return String(usv)
    }
}

extension UIAlertController {
    
    static func getCustomNonActionAlert(title:String, msg:String) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        return alert
    }
}


let dt = Database()
var dbPointer:OpaquePointer? = nil

@UIApplicationMain
class HYAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        
        UserDefaults.standard.set(false, forKey: "fromNewReminder")
        
        if (UserDefaults.standard.object(forKey:"userId") == nil) {
            UserDefaults.standard.set(1, forKey: "userId")
        }
        
        if (UserDefaults.standard.object(forKey:"reminderId") == nil) {
            UserDefaults.standard.set(1, forKey: "reminderId")
        }
        
        UserDefaults.standard.synchronize()
        
        
        dbPointer = dt.openDataBase()
        if dbPointer != nil {
            print("db created")
            if (dt.createRegisterTable(db: dbPointer)) {
                print("table created")
                
            }
        }
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

