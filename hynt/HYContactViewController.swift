//
//  ContactsViewController.swift
//  hynt
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit



class HYContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var cancelBarBtn:UIBarButtonItem!
    @IBOutlet var segment:UISegmentedControl!
    @IBOutlet var searchField: UISearchBar!
    @IBOutlet var contactsTbl: UITableView!
    
    var selected:Int = 0
    var fromValue = false
    var isSearch = false
    var searchList = [HYContact]()
    var searchString = ""
    
    var contactList = [HYContact]()
    var blockedList = [HYContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactList = [ HYContact("Contact 1", "+919895500123", "C"), HYContact("New Contact 1", "+919411153614", "N"), HYContact("New 1", "+918982359898", "N"), HYContact("Nava", "+918345758988", "N")]
        contactsTbl.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fromValue = UserDefaults.standard.bool(forKey: "fromNewReminder")
        
        
        if fromValue {
            self.navigationItem.leftBarButtonItem = cancelBarBtn
            segment.isHidden = true
        }
        else {
            segment.isHidden = false
            self.navigationItem.leftBarButtonItem = nil
        }
        
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func cancelSelected(sender:UIBarButtonItem) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func segmentChange(sender:UISegmentedControl) {
        guard isSearch else {
            contactsTbl.reloadData()
            return
        }
        validateSearchFiledData(searchStr: searchString )
    }
    
    func validateSearchFiledData(searchStr:String) {
        print(searchStr)
        if segment.selectedSegmentIndex == 0 {
            
            searchList = contactList.filter { ((($0.name)?.lowercased())?.hasPrefix(searchStr.lowercased()))! || ($0.mobile?.contains(searchStr))! }
            
        }
        else {
            searchList = blockedList.filter { ((($0.name)?.lowercased())?.hasPrefix(searchStr.lowercased()))! || ($0.mobile?.contains(searchStr))! }
            
        }
        print(searchList)
        contactsTbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        guard isSearch == false else {
           count = searchList.count
            searchField.placeholder = "\(count) contacts"
            return count
        }
        
        if  segment.selectedSegmentIndex == 0  {
            count = contactList.count
        }
        else {
            count = blockedList.count
        }
        searchField.placeholder = "\(count) contacts"
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! HYCustumContactCell
        cell.selectionStyle = .none
        cell.lockImage.tag = indexPath.row
        cell.lockImage.addTarget(self, action: #selector(blockContact(_:)), for: .touchUpInside)

        cell.initialLbl.layer.cornerRadius = cell.initialLbl.frame.size.width/2
        cell.initialLbl.clipsToBounds = true
        cell.initialLbl.backgroundColor = .random()
        
        if fromValue {
            cell.lockImage.isHidden = true
        }
        else {
            cell.lockImage.isHidden = false
        }
        
        guard isSearch == false else {
            if let contact = self.searchList[indexPath.row] as HYContact?   {
                cell.nameLbl.text = contact.name
                cell.mobileLbl.text = contact.mobile
                cell.initialLbl.text = contact.initialC
                if segment.selectedSegmentIndex == 0 {
                    cell.lockImage.setImage( UIImage.init(named: "lock"), for: .normal)
                }
                else {
                    cell.lockImage.setImage( UIImage.init(named: "unlock"), for: .normal)
                }
            }
            return cell
        }
        
        switch segment.selectedSegmentIndex {
        case 0:
            if let contact = self.contactList[indexPath.row] as HYContact?   {
                cell.nameLbl.text = contact.name
                cell.mobileLbl.text = contact.mobile
                cell.initialLbl.text = contact.initialC
                cell.lockImage.setImage(UIImage.init(named: "lock"), for: .normal)
            }
            break
        case 1:
            if let contact = self.blockedList[indexPath.row] as HYContact?   {
                cell.nameLbl.text = contact.name
                cell.mobileLbl.text = contact.mobile
                cell.initialLbl.text = contact.initialC
                cell.lockImage.setImage(UIImage.init(named: "unlock"), for: .normal)
            }
            break
        default:
            print("Default ")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchString = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchStr:String = (searchBar.text != nil) ? searchBar.text! : ""
        
        isSearch = true
        if searchStr == "" {
            searchString = ""
            isSearch = false
        }
        searchString = searchStr
        validateSearchFiledData(searchStr:searchStr)
    }
    
    func handler(sender:UIButton) {
    
        let tag = sender.tag
        
        var c:HYContact? = nil
        
        if isSearch {
            c = searchList[tag]
            if c != nil {
                searchList.remove(at: searchList.index(of: c!)!)
            }
        }
        else if segment.selectedSegmentIndex == 0 {
             c = contactList[tag]
        }
        else {
            c = blockedList[tag]
        }
        
        if c != nil {
            if segment.selectedSegmentIndex == 0 {
                blockedList.append(c!)
                if contactList.contains(c!) {
                    contactList.remove(at: contactList.index(of: c!)!)
                }
            }
            else {
                contactList.append(c!)
                if blockedList.contains(c!) {
                    blockedList.remove(at: blockedList.index(of: c!)!)
                }
            }
        }
        contactsTbl.reloadData()
        
        /*guard isSearch == false else {
            if segment.selectedSegmentIndex == 0 {
                let c = searchList[tag]
                blockedList.append(c)
                contactList.remove(at: tag)
                searchList.remove(at: tag)
            }
            else {
                let c = searchList[tag]
                contactList.append(c)
                blockedList.remove(at: tag)
                searchList.remove(at: tag)
            }
            contactsTbl.reloadData()
            return
        }
        
        if segment.selectedSegmentIndex == 0 {
            let c = contactList[tag]
            blockedList.append(c)
            contactList.remove(at: tag)
        }
        else {
            let c = blockedList[tag]
            contactList.append(c)
            blockedList.remove(at: tag)
        }
        contactsTbl.reloadData()
        */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fromValue {
            let c = contactList[indexPath.row]
            Contact.currentContact.cName = c.name
            Contact.currentContact.mobileNumber =  c.mobile
            tabBarController?.selectedIndex = 1
        }
    }
    
    @objc func blockContact(_ sender:UIButton) {
        
        let alert = UIAlertController.init(title: "Warning!", message: segment.selectedSegmentIndex==1 ? "Are you sure you want to unblock this contact?":"Are you sure you want to block this contact?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "NO", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "YES", style: .default, handler: {action in  self.handler(sender: sender)}))
        self.present(alert, animated: true, completion: nil)
        
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
