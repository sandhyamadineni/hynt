//
//  LoginViewController.swift
//  hynt
//
//  Created by Apple on 8/9/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import UIFloatLabelTextView
import JVFloatLabeledTextField
import DropDown
import SQLite3
import libPhoneNumber_iOS
import RNCryptor


extension  String{
    func isNameValid() -> Bool {
        if !self.isEmpty && self.count > 3 {
            return true
        }
        return false
    }
    
    func isEmailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isMobileValid() -> Bool {
        let util:NBPhoneNumberUtil = NBPhoneNumberUtil()
        do {
            let num:NBPhoneNumber = try util.parse(withPhoneCarrierRegion: self)
            return util.isValidNumber(num)
        }catch{
            let num = self
            let reg = "^[5-9][0-9]{7,9}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reg)
            let result  = predicate.evaluate(with: num)//predicate.evaluate(with: number)
            return result
        }
    }
    
    func isPwdValid() -> Bool {
        return !self.isEmpty && self.count > 6
    }
    
    
    func isPasswordValid(confirm:String) -> Bool {
         return !self.isEmpty && self.count > 6 && self == confirm
    }
    
    func encryptMessage( encryptionKey: String) throws -> String {
        let messageData = self.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }
    
    func decryptMessage( encryptionKey: String) throws -> String {
        
        let encryptedData = Data.init(base64Encoded: self)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
}

extension HYSignUpViewController {
    func clearFields() {
        nameFld.text = ""
        passFld.text = ""
        mobileFld.text = ""
        emailFld.text = ""
        confirmFld.text = ""
        securityDrop.selectRow(0)
        termsConditionsBtn.isSelected = false
    }
}


class HYSignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameFld:JVFloatLabeledTextField!
    @IBOutlet var emailFld:JVFloatLabeledTextField!
    @IBOutlet var mobileFld:JVFloatLabeledTextField!
    @IBOutlet var passFld:JVFloatLabeledTextField!
    @IBOutlet var confirmFld:JVFloatLabeledTextField!
    @IBOutlet var chooseSecurityLbl:UILabel!
    
    @IBOutlet var flagBtn:UIButton!
    @IBOutlet var securityQ:UITextField!
    @IBOutlet var termsConditionsBtn:UIButton!
    let securityDrop = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        nameFld.customize(placeholder: "Enter Name", title: "Full Name")
        emailFld.customize(placeholder: "Enter Email", title: "Email")
        mobileFld.customize(placeholder: "Enter Mobile", title: "Mobile Number")
        passFld.customize(placeholder: "Enter Password", title: "Password")
        confirmFld.customize(placeholder: "Enter Confirm Password", title: "Confirm Password")
        
        let imageView2 = UIButton(type: .custom)
        imageView2.backgroundColor = UIColor.orange
        imageView2.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView2.contentMode = .scaleAspectFit
        imageView2.tag = 1
        imageView2.addTarget(self, action: #selector(changeShowHide), for: .touchUpInside)
        imageView2.setImage(UIImage.init(named: "hidePass"), for: .normal)
        imageView2.setImage(UIImage.init(named: "showPass"), for: .selected)
        passFld.rightView = imageView2
        passFld.rightViewMode = .always
        passFld.isSecureTextEntry = true
        
        let imageView1 = UIButton(type: .custom)
        imageView1.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView1.addTarget(self, action: #selector(changeShowHide), for: .touchUpInside)
        imageView1.contentMode = .scaleAspectFit
        imageView1.tag = 2
        imageView1.setImage(UIImage.init(named: "hidePass"), for: .normal)
        imageView1.setImage(UIImage.init(named: "showPass"), for: .selected)
        confirmFld.rightViewMode = .always
        confirmFld.rightView = imageView1
        confirmFld.isSecureTextEntry = true
        
        let imageView = UIButton(type: .custom)
        imageView.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        imageView.addTarget(self, action: #selector(securityQselected), for: .touchUpInside)
        imageView.setImage(UIImage.init(named: "dropDown"), for: .normal)
        
        securityQ.addTarget(self, action: #selector(securityQselected), for: UIControlEvents.editingDidBegin)
        securityQ.addTarget(self, action: #selector(securityQChanged), for: UIControlEvents.valueChanged)
        securityQ.rightView = imageView
        securityQ.rightViewMode = .always
        
        securityDrop.anchorView = chooseSecurityLbl
        securityDrop.width = securityQ.frame.size.width
        securityDrop.dataSource = ["-- Select --", "Question 1", "Qusetion 2"]
        securityDrop.selectRow(0)
        securityDrop.direction = .top
        securityDrop.selectionBackgroundColor = UIColor.green
        securityDrop.textFont = UIFont.init(name: "Courier", size: 15)!
        securityDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.securityQ.text = item
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        flagBtn.setTitle("IN".flag() + " +91", for: .normal)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearFields()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func goBackToLogin(sender:Any) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func securityQselected() {
        securityQ.resignFirstResponder()
        if securityDrop.isHidden {securityDrop.show()}
        else{ securityDrop.hide()}
    }
    
    @objc func securityQChanged(sender:UITextField) {
        securityQ.resignFirstResponder()
    }
    
    @IBAction func termsConditionsBtnSelected(sender:UIButton) {
        termsConditionsBtn.isSelected = !termsConditionsBtn.isSelected
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == securityQ {
            securityQ.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameFld:
            emailFld.becomeFirstResponder()
        case emailFld:
            mobileFld.becomeFirstResponder()
        case passFld:
            confirmFld.becomeFirstResponder()
        case securityQ:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func changeShowHide(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 1:
            passFld.isSecureTextEntry = !passFld.isSecureTextEntry
        case 2:
            confirmFld.isSecureTextEntry = !confirmFld.isSecureTextEntry
        default:
            print("nothing")
        }
    }
    
    func isFormValid() -> Bool {
        let num = "+91" + mobileFld.text!
        if (nameFld.text?.isNameValid())! && (emailFld.text?.isEmailValid())! && num.isMobileValid() && (passFld.text?.isPasswordValid(confirm: confirmFld.text!))! && securityQ.text != "-- Select --" && termsConditionsBtn.isSelected  {
            return true
        }
        return false
    }
    
    func encryptMessage(message: String, encryptionKey: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }
    
    func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
        
        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
    
    @IBAction func registerUser() {
        if isFormValid() {
            
            var keyPwd:String = ""
            do {
                keyPwd = try (passFld.text!).encryptMessage( encryptionKey: encryptionKeyString)
                print(keyPwd)
            }
            catch{
                print("error message")
            }
            
            let num = "+91" + mobileFld.text!
            let user = User.init(name: nameFld.text!, email: emailFld.text!, mobile: num, code: "+91", pwd: keyPwd, sec: securityQ.text!, ans: "answer")
            if dt.insertIntoUserTable(db: dbPointer, user:user) {
                print("data inserted")
                performSegue(withIdentifier: "registerUser", sender: nil)
            }
        }
        else {
            let alert = UIAlertController.init(title: "Warning!", message: "Please enter the valid field names", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
