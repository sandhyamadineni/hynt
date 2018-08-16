//
//  NewViewController.swift
//  hynt
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Photos
import DropDown

extension String {
    func isValidRecipient() -> [String] {
        let str = self.components(separatedBy: ",")
        var re:[String] = [String]()
        for num in str {
            if num.isMobileValid() {
                re.append(num)
            }
        }
        return re
    }
    
    func convertStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy h:mm"
        return formatter.date(from: self)!
    }
    
}

class HYNewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var scroll:UIScrollView!
    @IBOutlet var remainderSwitch:UISwitch!
    @IBOutlet var toRemainder:UITextField!
    @IBOutlet var descriptionView:UITextView!
    @IBOutlet var personalOrOfficial:UILabel!
    @IBOutlet var dropDownAnchor:UIView!
    @IBOutlet var recurrenceLbl:UILabel!
    @IBOutlet var recurrenceAnchor:UIView!
    @IBOutlet var sampleDateTextField: UITextField!
    @IBOutlet var imageCloseBtn:UIButton!
    @IBOutlet var audioCloseBtn:UIButton!
    @IBOutlet var backButton:UIBarButtonItem!
    @IBOutlet var reminderImgBtn:UIButton!
    let imageController = UIImagePickerController.init()
    let dropDown = DropDown()
    let reccurenceDrop = DropDown()
    var recipients:[String] = [String]()
    var descriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.contentSize = CGSize.init(width: self.view.frame.size.width, height: 2000)
        descriptionView.layer.cornerRadius = 5
        descriptionView.layer.borderColor = UIColor.blue.cgColor
        descriptionView.layer.borderWidth = 0.5
        descriptionView.text = "Enter description text"
        descriptionView.textColor = UIColor.gray
        
        dropDown.anchorView = dropDownAnchor
        dropDown.dataSource = ["Personal", "Official"]
        dropDown.selectRow(0)
        dropDown.width = dropDownAnchor.frame.size.width
        dropDown.selectionBackgroundColor = UIColor.green
        dropDown.textFont = UIFont.init(name: "Courier", size: 15)!
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.personalOrOfficial.text = item
        }
        
        reccurenceDrop.anchorView = recurrenceAnchor
        reccurenceDrop.dataSource = ["No Recurrence", "Daily", "Mon to Fri"]
        reccurenceDrop.selectRow(0)
        reccurenceDrop.width = recurrenceAnchor.frame.size.width
        reccurenceDrop.selectionBackgroundColor = UIColor.green
        reccurenceDrop.textFont = UIFont.init(name: "Courier", size: 15)!
        reccurenceDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.recurrenceLbl.text = item
        }
        
        handleDatePicker()
        imageCloseBtn.isHidden = true
        //audioCloseBtn.isHidden = true
        
        if dbPointer != nil {
            print("db created")
            if (dt.createRemindertable(db: dbPointer)) {
                print("table created")
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        
        if Contact.currentContact.mobileNumber != nil {
           toRemainder.text = Contact.currentContact.mobileNumber
        }
        
        if Contact.currentContact.mobileNumber != User.currentUser.mobileNumber {
            remainderSwitch.isOn = false
        }
        
        UserDefaults.standard.set(false, forKey: "fromNewReminder")
        UserDefaults.standard.synchronize()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            descriptionText = ""
            textView.textColor = UIColor.black
        }
        else {
            descriptionText = textView.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.gray
            textView.text = "Enter description text"
        }
        else {
            descriptionText = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func remainderTypeChanged(sender:UISwitch) -> Void {
        if sender.isOn {
            Contact.currentContact.mobileNumber = User.currentUser.mobileNumber
            Contact.currentContact.cName = User.currentUser.userName
            toRemainder.text = User.currentUser.mobileNumber
        }
        else {
            Contact.currentContact.mobileNumber = nil
            Contact.currentContact.cName = nil
            toRemainder.text = ""
        }
    }
    
    @IBAction func contactsSelected(sender:UIButton) -> Void {
        UserDefaults.standard.set(true, forKey: "fromNewReminder")
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func personalOrOfficialChanged(sender:UIButton) {
        if dropDown.isHidden {
            dropDown.show()
        }
        else {
            dropDown.hide()
        }
    }
    
    @IBAction func recurrenceChanged(sender:UIButton) {
        if reccurenceDrop.isHidden {
            reccurenceDrop.show()
        }
        else {
            reccurenceDrop.hide()
        }
    }
    
    @IBAction func specialDateTextFieldClick(_ sender: UITextField) {
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 240))
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        inputView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerFromValueChanged), for: .valueChanged)
        
        
        let doneButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 105, y: 0, width: 100, height: 50))
        
        doneButton.backgroundColor = UIColor.gray
        doneButton.layer.cornerRadius = 5
        doneButton.layer.borderWidth = 1
        doneButton.setTitle("Done", for: .normal)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        
        sampleDateTextField.inputView = inputView
        sampleDateTextField.addTarget(self, action: #selector(editingBegin), for: UIControlEvents.editingDidBegin)
        datePicker.addTarget(self, action: #selector(datePickerFromValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func editingBegin() {
        sampleDateTextField.resignFirstResponder()
    }
    
    func handleDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy h:mm"
        sampleDateTextField.text = formatter.string(from: Date())
    }

    
    @objc func handleDoneButton(sender: UIButton) {
        sampleDateTextField.resignFirstResponder()
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MM/yyyy h:mm"
        sampleDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    

    @IBAction func backSelected(sender:UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func checkPermission() {
        if PHPhotoLibrary.authorizationStatus() == .denied {
//            LocalNotificationManager.showInfoForMobile("Warning!", info: "It seems your privacy settings for the app are disabled. You enable it from your setting to access photos.", inViewController: self, completion: {
//                self.photoBtn.isEnabled = false
//                self.photoBtn.backgroundColor = Style.lightGrayColor()
//            })
        }
        else {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status == .authorized {
                    DispatchQueue.main.async(execute: {
                        self.loadCamera()
                    })
                }
            })
        }
    }
    
    func loadCamera() {
        imageController.sourceType = .photoLibrary
        imageController.allowsEditing = false
        imageController.delegate = self
        self.present(imageController, animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        reminderImgBtn.contentMode = .scaleAspectFit
        reminderImgBtn.setImage(image , for: .normal)
        imageCloseBtn.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showOption() {
        let action = UIAlertController.init(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { action in
            self.checkPermission()
        }))
        
        action.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { action in
            self.checkPermission()
        }))
        
        action.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(action, animated: true, completion: nil)
    }
    
    @IBAction func removeSelectedImage(sender:UIButton) {
        reminderImgBtn.setImage(nil, for: .normal)
        imageCloseBtn.isHidden = true
    }
    
    @IBAction func removeAudio(sender:UIButton) {
        audioCloseBtn.isHidden = true
    }
    
    @IBAction func saveReminderData() {
        var alert:UIAlertController?
        
        if ((toRemainder.text)?.isEmpty)! {
                alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Recipient should not be empty")
            present(alert!, animated: true, completion: nil)
            return
        }
        
        recipients = (toRemainder.text!).isValidRecipient()
        
        if (recipients.count == 0) {
            alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Enter valid recipient")
            present(alert!, animated: true, completion: nil)
            return
        }
        
        Reminder.currentReminder.torecipients = recipients
        Reminder.currentReminder.isSelf = remainderSwitch.isOn ? 1 : 0
        
        if descriptionText.isEmpty {
            alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Enter some message")
            present(alert!, animated: true, completion: nil)
            return
        }
        
        Reminder.currentReminder.desc = descriptionText
        
        let selectedDate:Date = (sampleDateTextField.text!).convertStringToDate()
        let presentdate:Date = getStringFromdate(dateStr: Date()).convertStringToDate()
        
        if selectedDate.compare(presentdate) == .orderedAscending || selectedDate.compare(presentdate) == .orderedSame {
            alert = UIAlertController.getCustomNonActionAlert(title: "Warning!", msg: "Selected date should be greater than present date")
            present(alert!, animated: true, completion: nil)
            return
        }
        
        Reminder.currentReminder.dateAndTime = sampleDateTextField.text
        Reminder.currentReminder.toType = personalOrOfficial.text
        Reminder.currentReminder.recurrence = recurrenceLbl.text
        Reminder.currentReminder.isMin = 0
        let id = User.currentUser.uid
        Reminder.currentReminder.fromUserId = id
        
        if dt.insertIntoReminderTable(db: dbPointer, reminder:Reminder.currentReminder) {
            print("data inserted")
            self.tabBarController?.selectedIndex = 0
            self.tabBarController?.tabBar.isHidden = false
        }
        else {
            let alert = UIAlertController.getCustomNonActionAlert(title: "Error!", msg: "Failed to create reminder")
            present(alert, animated: true, completion: nil)
        }
    }
    
    func getStringFromdate(dateStr:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy h:mm"
        return formatter.string(from:dateStr)
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
