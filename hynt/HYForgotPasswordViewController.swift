//
//  HYForgotPasswordViewController.swift
//  hynt
//
//  Created by Apple on 8/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import DropDown

class HYForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var numberFld:JVFloatLabeledTextField!
    @IBOutlet var securityFld:UITextField!
    @IBOutlet var countryFlagBtn:UIButton!
    let securityDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overFullScreen
        view.isOpaque = false
        view.backgroundColor = .clear
        
        countryFlagBtn.setTitle("IN".flag() + " +91", for: .normal)
        
        numberFld.customize(placeholder: "Enter Number", title: "Mobile Number")
        let imageView = UIButton(type: .custom)
        imageView.frame = CGRect.init(x: 0, y: 2, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        imageView.addTarget(self, action: #selector(securityFldselected), for: .touchUpInside)
        imageView.setImage(UIImage.init(named: "dropDown"), for: .normal)
        
        securityFld.addTarget(self, action: #selector(securityFldselected), for: UIControlEvents.editingDidBegin)
        securityFld.addTarget(self, action: #selector(securityFldChanged), for: UIControlEvents.valueChanged)
        securityFld.rightView = imageView
        securityFld.rightViewMode = .always
        
        securityDropDown.anchorView = securityFld
        securityDropDown.width = securityFld.frame.size.width
        securityDropDown.dataSource = ["-- Select --", "Question 1", "Qusetion 2"]
        securityDropDown.selectRow(0)
        securityDropDown.direction = .bottom
        securityDropDown.selectionBackgroundColor = UIColor.green
        securityDropDown.textFont = UIFont.init(name: "Courier", size: 15)!
        securityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.securityFld.text = item
        }
    }
    

    @IBAction func backToLoginScreen(sender:Any) {
        if numberFld.isFocused {
            numberFld.resignFirstResponder()
        }
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    @objc func securityFldselected() {
        securityFld.resignFirstResponder()
        if securityDropDown.isHidden {securityDropDown.show()}
        else{ securityDropDown.hide()}
    }
    
    @objc func securityFldChanged(sender:UITextField) {
        securityFld.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
