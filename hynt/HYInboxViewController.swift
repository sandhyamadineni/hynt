//
//  InboxViewController.swift
//  hynt
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HYInboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var inboxTbl:UITableView!
    @IBOutlet var search:UISearchBar!
    
    var todayDate = NSDate()
    var minDate = NSDate()
    var maxDate = NSDate()
    var dateSelected = NSDate()
    var rList = [Reminder]()
    var searchRList = [Reminder]()
    var isInboxSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inboxTbl.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dbPointer != nil {
            print("db created")
            if (dt.createRemindertable(db: dbPointer)) {
                print("table created")
                rList = dt.selectIfReminderExists(db: dbPointer, toId: User.currentUser.mobileNumber!)
                inboxTbl.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isInboxSearch = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchStr:String = (searchBar.text != nil) ? searchBar.text! : ""
        isInboxSearch = false
        if !searchStr.isEmpty {
            isInboxSearch = true
        }
        searchRList = rList.filter{ ((($0.desc)?.lowercased())?.hasPrefix(searchStr.lowercased()))! }
        print(searchRList)
        inboxTbl.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInboxSearch {
            search.placeholder = "\(searchRList.count) Reminders"
            return searchRList.count
        }
        search.placeholder = "\(rList.count) Reminders"
        return rList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell", for: indexPath) as! InboxCustomCell
        tableView.separatorStyle = .none
        
        var dR:Reminder? = nil
        if isInboxSearch == false {
            dR = rList[indexPath.row]
        }
        else {
            dR = searchRList[indexPath.row]
        }
        
        let cUser:User? = dt.selectUserForId(db: dbPointer, uid: (dR?.fromUserId!)!)
        
        if (cUser != nil) {
            cell.nameLbl.text =  cUser?.userName
            cell.mobileLbl.text =  cUser?.mobileNumber
        }
        else {
            cell.nameLbl.text =  "Not available"
            cell.mobileLbl.text =  "Not available"
        }
        
        
        cell.descLbl.text = (dR?.desc != nil) ? dR?.desc : ""
        cell.timeLbl.text = (dR?.dateAndTime != nil) ? dR?.dateAndTime : ""
        cell.deleteReminder.tag = indexPath.row
        cell.deleteReminder.addTarget(self, action: #selector(deleteFromInbox), for: .touchUpInside)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @objc func deleteFromInbox(sender:UIButton) {
        let reminderIndex:Int = sender.tag
        let re:Reminder? = isInboxSearch ? searchRList[reminderIndex] : rList[reminderIndex]
        
        if (re != nil) {
            if (dt.deleteReminder(db: dbPointer, remainder: re!)) {
                if isInboxSearch {
                    searchRList.remove(at: reminderIndex)
                }
                else {
                    rList.remove(at: reminderIndex)
                }
            }
        }
        inboxTbl.reloadData()
    }
    
    func timeFromDate(date:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy h:mm"
        let dateStr = formatter.date(from: date)
        formatter.dateFormat = "h:mm a"
        let str = formatter.string(from:dateStr!)
        return str
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
