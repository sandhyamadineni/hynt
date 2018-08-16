//
//  HYLoginViewController.swift
//  hynt
//
//  Created by Apple on 8/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class HYSignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var mobileNumber:JVFloatLabeledTextField!
    @IBOutlet var password:JVFloatLabeledTextField!
    @IBOutlet var countryCodeBtn:UIButton!
    @IBOutlet var faceBookBtn:UIButton!
    @IBOutlet var googleBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodeBtn.setTitle("IN".flag() + " +91", for: .normal)
        
        mobileNumber.customize(placeholder: "Enter Mobile Number", title: "Mobile Number")
        mobileNumber.setLeftPaddingPoints(10)
        mobileNumber.setRightPaddingPoints(10)
        password.customize(placeholder: "Enter Password", title: "Password")
        password.setLeftPaddingPoints(10)
        password.setRightPaddingPoints(10)
        
        
        let imageView2 = UIButton(type: .custom)
        imageView2.backgroundColor = UIColor.orange
        imageView2.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView2.contentMode = .scaleAspectFit
        imageView2.tag = 1
        imageView2.addTarget(self, action: #selector(changeShowHide), for: .touchUpInside)
        imageView2.setImage(UIImage.init(named: "hidePass"), for: .normal)
        imageView2.setImage(UIImage.init(named: "showPass"), for: .selected)
        password.rightView = imageView2
        password.rightViewMode = .always
        password.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mobileNumber.text = "9040505667"
        password.text = "password@1"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mobileNumber.text = ""
        password.text = ""
    }
    
    
    @objc func changeShowHide(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        password.isSecureTextEntry = !password.isSecureTextEntry
    }
    
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) {
        print("unwind from Login")
    }
    
    func isLoginFormValid() -> Bool {
        let num = "+91" + mobileNumber.text!
        if (num.isMobileValid() && (password.text!).isPwdValid())  {
            return true
        }
        return false
    }
    
    @IBAction func loginUser() {
        
        if (isLoginFormValid()) {
            if (dbPointer != nil) {
                let luser = User.init()
                luser.mobileNumber = "+91" + mobileNumber.text!
                do {
                    luser.password = try (password.text)?.encryptMessage(encryptionKey: encryptionKeyString)
                }
                catch { print("Error message")}
                if dt.selectIfUserExists(db: dbPointer, user: luser) != 0 {
                    print(User.currentUser.userName ?? "")
                    performSegue(withIdentifier: "loginUser", sender: nil)
                }
                else {
                    let errorAlert = UIAlertController.init(title: "Warning!", message: "User not registered. Try register", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    present(errorAlert, animated: true, completion: nil)
                }
            }
        }
        else {
            let alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Password is not valid")
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
