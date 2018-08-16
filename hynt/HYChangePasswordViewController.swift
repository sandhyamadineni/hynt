//
//  ChangePasswordViewController.swift
//  hynt
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HYChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var currentPass:UITextField!
    @IBOutlet var newPass:UITextField!
    @IBOutlet var confirmPass:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let imageView = UIButton(type: .custom)
        imageView.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 1
        imageView.addTarget(self, action: #selector(changeShowHide), for: .touchUpInside)
        imageView.setImage(UIImage.init(named: "hidePass"), for: .normal)
        imageView.setImage(UIImage.init(named: "showPass"), for: .selected)

        let imageView1 = UIButton(type: .custom)
        imageView1.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView1.addTarget(self, action: #selector(changeShowHide), for: .touchUpInside)
        imageView1.contentMode = .scaleAspectFit
        imageView1.tag = 2
        imageView1.setImage(UIImage.init(named: "hidePass"), for: .normal)
        imageView1.setImage(UIImage.init(named: "showPass"), for: .selected)

        let imageView2 = UIButton(type: .custom)
        imageView2.contentMode = .scaleAspectFit
        imageView2.tag = 3
        imageView2.addTarget(self, action: #selector(changeShowHide), for: .touchUpInside)
        imageView2.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView2.setImage(UIImage.init(named: "hidePass"), for: .normal)
        imageView2.setImage(UIImage.init(named: "showPass"), for: .selected)

        self.currentPass.rightViewMode = .always
        self.currentPass.rightView = imageView
        self.newPass.rightViewMode = .always
        self.newPass.rightView = imageView1
        self.confirmPass.rightViewMode = .always
        self.confirmPass.rightView = imageView2
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPass {
            newPass.becomeFirstResponder()
        }
        else if newPass == textField {
            confirmPass.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func changeShowHide(sender:UIButton) -> Void {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 1:
            self.currentPass.isSecureTextEntry = !self.currentPass.isSecureTextEntry
            break
        case 2:
            self.newPass.isSecureTextEntry = !self.newPass.isSecureTextEntry
            break
        case 3:
            self.confirmPass.isSecureTextEntry = !self.confirmPass.isSecureTextEntry
            break
        default:
            print("Nothing")
        }
    }
    
    @IBAction func changePwd(sender:Any) {
        
        self.view.endEditing(true)
        
        guard ((currentPass.text)?.isPwdValid())! else {
            let alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Password is not valid")
            return present(alert, animated: true, completion: nil)
        }
        
        var pwd = ""
        do {
            pwd = try (User.currentUser.password)!.decryptMessage(encryptionKey: encryptionKeyString)
        }
        catch{print("Error message")}
        
        guard pwd == currentPass.text else {
            let alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Password is not valid")
            return present(alert, animated: true, completion: nil)
        }
        
        guard ((newPass.text)?.isPasswordValid(confirm: confirmPass.text!))! else {
            let alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "New and confirm password should be same")
            return present(alert, animated: true, completion: nil)
        }
        
        guard pwd != newPass.text else {
            let alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Current and new password should not be same")
            return present(alert, animated: true, completion: nil)
        }
        
        var enNewPwd = ""
        do {
            enNewPwd = try (newPass.text!).encryptMessage(encryptionKey: encryptionKeyString)
        }catch{ print("Error message") }
        
        guard dt.updatePassword(db: dbPointer, newPass: enNewPwd) else {
            let alert = UIAlertController.getCustomNonActionAlert(title: "Error!", msg: "Failed to update password ")
            return present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController.init(title: "Congrats!", message: "Password updated successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
        
        /*if ((currentPass.text)?.isPwdValid())! {
            
            var pwd = ""
            do {
                pwd = try (User.currentUser.password)!.decryptMessage(encryptionKey: encryptionKeyString)
            }
            catch{print("Error message")}
            
            if pwd == currentPass.text {
                if ((newPass.text)?.isPasswordValid(confirm: confirmPass.text!))! {
                    if pwd != newPass.text {
                        var enNewPwd = ""
                        do {
                            enNewPwd = try (newPass.text!).encryptMessage(encryptionKey: encryptionKeyString)
                        }catch{ print("Error message") }
                        if dt.updatePassword(db: dbPointer, newPass: enNewPwd) {
                            (UIAlertController.init()).passwordUpdated()
                        }
                        else {
                            (UIAlertController.init()).failedToUpdatePassword()
                        }
                    }
                    else {
                        (UIAlertController.init()).passAndNewPassIsSame()
                    }
                }
                else {
                    (UIAlertController.init()).showConfirmPasswordErrorAlert()
                }
            }
            else {
                let alert = UIAlertController.getPasswordErrorAlert()
                present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController.getPasswordErrorAlert()
            present(alert, animated: true, completion: nil)
        }*/
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
