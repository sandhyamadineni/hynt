//
//  ProfileViewController.swift
//  hynt
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HYProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var profileTbl: UITableView!
    final let cellNames  = ["profileImageCell", "infoCell", "mobileInfoCell", "emailInfoCell", "changePasswordCell", "logoutCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTbl.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNames[indexPath.row], for: indexPath)
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
                //let imgView = cell.viewWithTag(1) as! UIImageView
                let nameView = cell.viewWithTag(2) as! UILabel
                nameView.text = User.currentUser.userName
            break
        case 1:
                //let inboxView = cell.viewWithTag(3) as! UILabel
                //let upComingView = cell.viewWithTag(4) as! UILabel
            break
        case 2:
            let mobileView = cell.viewWithTag(5) as! UILabel
            mobileView.text = User.currentUser.mobileNumber
            break
        case 3:
            let emailView = cell.viewWithTag(6) as! UILabel
            emailView.text = User.currentUser.email
            break
        
        default:
            print("default")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200
        case 1:
            return 100
        case 2,3,4:
            return 60
        case 5:
            return 70
        default:
            return 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangePassword" {
            
        }
    }
    
    @IBAction func goToLogin(sender:Any) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
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
