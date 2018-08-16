//
//  Database.swift
//  hynt
//
//  Created by Apple on 8/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SQLite3

class Database: NSObject {
    
    func getDocPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func filePath(filePath strPath:String) -> (value:Bool, fileURLPath:URL) {
        let path = getDocPath().appendingPathComponent(strPath)
        if !FileManager.default.fileExists(atPath: path.path) {
            return (false, path)
        }
        return (true, path)
    }
    
    /*func createDataBase() -> Bool {
        let result = filePath(filePath: "db.sqlite")
        if !result.value {
            if sqlite3_open(result.fileURLPath.path, &database) != SQLITE_OK {
                print("file does not created")
                return false
            }
        }
        return true
    }*/
    
    func openDataBase() -> OpaquePointer? {
        var opDb:OpaquePointer? = nil
        print(getDocPath())
        let result = getDocPath().appendingPathComponent("db.sqlite")
        if sqlite3_open(result.path, &opDb) != SQLITE_OK {
            return opDb
        }
        return opDb
    }
    
    // UserTable
    
    func createRegisterTable(db:OpaquePointer?) -> Bool {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS USER(
        Id INT PRIMARY KEY NOT NULL,
        Name CHAR(255), Email CHAR(255), Password CHAR(255), Mobile CHAR(255), CountryCode CHAR(255), SecurityQ CHAR(255), Ans CHAR(255));
        """
        
        var createTableStatement: OpaquePointer? = nil
        var result = true
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
            } else {
                result = false
            }
        } else {
            result = false
        }
        sqlite3_finalize(createTableStatement)
        return result
    }
    
    // Reminder table
    
    func createRemindertable(db:OpaquePointer?) -> Bool {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS REMINDER(
        Id INT PRIMARY KEY NOT NULL, Fromuserid integer NOT NULL,
        Isown INT, Tosend CHAR(255), Description CHAR(255), Totype CHAR(255), Recurrence CHAR(255), Ismin INT, Triggertime CHAR(25), Minutes INT, Image BLOB, Audio BLOB, Istriggered INT, Isshown INT, FOREIGN KEY (Fromuserid) REFERENCES USER(Id));
        """
        
        var createTableStatement: OpaquePointer? = nil
        var result = true
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
            } else {
                result = false
            }
        } else {
            result = false
        }
        sqlite3_finalize(createTableStatement)
        return result
    }
    
    // Insert data into reminder
    
    func insertIntoReminderTable(db:OpaquePointer?, reminder:Reminder) -> Bool {
        let insertString = """
                            INSERT INTO REMINDER(Id, Fromuserid, Isown, Tosend, Description, Totype, Recurrence, Ismin, Triggertime, Minutes, Image, Audio, Istriggered, Isshown) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
                            """
        
        var insertStatement:OpaquePointer? = nil
        var result = false
        var idValue = UserDefaults.standard.integer(forKey: "reminderId")
        
        let rec = reminder.torecipients?.joined(separator: ",")
        
        if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(idValue))
            sqlite3_bind_int(insertStatement, 2, reminder.fromUserId!)
            sqlite3_bind_int(insertStatement, 3, reminder.isSelf!)
            sqlite3_bind_text(insertStatement, 4, (rec! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (reminder.desc! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (reminder.toType! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (reminder.recurrence! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 8, reminder.isMin!)
            sqlite3_bind_text(insertStatement, 9, (reminder.dateAndTime! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 10, reminder.minutes)
            sqlite3_bind_int(insertStatement, 13, Int32(Int(0)))
            sqlite3_bind_int(insertStatement, 14, Int32(Int(0)))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                //print(selectIfUserExists(db: db, user: user))
                idValue += 1
                UserDefaults.standard.set(idValue, forKey: "reminderId")
                UserDefaults.standard.synchronize()
                result = true
            }
        }
        sqlite3_finalize(insertStatement)
        return result
    }
    
    func selectIfReminderExists(db:OpaquePointer?, toId:String) -> [Reminder] {
        let selectString = """
        SELECT * FROM REMINDER WHERE Tosend = '\(toId)' ORDER BY Triggertime DESC;
        """
        var selectStatement:OpaquePointer? = nil
        var reminderList:[Reminder] = [Reminder]()
        if sqlite3_prepare_v2(db, selectString, -1, &selectStatement, nil) == SQLITE_OK {
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
                let data = Reminder()
                data.rid = sqlite3_column_int(selectStatement, 0)
                data.fromUserId = sqlite3_column_int(selectStatement, 1)
                data.isSelf = sqlite3_column_int(selectStatement, 2)
                let toSend = String(cString: sqlite3_column_text(selectStatement, 3))
                data.torecipients = toSend.components(separatedBy: ",")
                data.desc = String(cString: sqlite3_column_text(selectStatement, 4))
                data.toType = String(cString: sqlite3_column_text(selectStatement, 5))
                data.recurrence = String(cString: sqlite3_column_text(selectStatement, 6))
                data.dateAndTime = String(cString: sqlite3_column_text(selectStatement, 8))
                data.isTriggered = sqlite3_column_int(selectStatement, 12)
                data.isVisit = sqlite3_column_int(selectStatement, 13)
                reminderList.append(data)
            }
        }
        return reminderList
    }
    
    func insertIntoUserTable(db:OpaquePointer?, user:User) -> Bool {
        let insertString = """
                            INSERT INTO USER(Id, Name, Email, Password, Mobile, CountryCode, SecurityQ, Ans) Values(?, ?, ?, ?, ?, ?, ?, ?);
                            """
        
        var insertStatement:OpaquePointer? = nil
        var result = false
        var idValue = UserDefaults.standard.integer(forKey: "userId")
        if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(idValue))
            sqlite3_bind_text(insertStatement, 2, (user.userName! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (user.email! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (user.password! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (user.mobileNumber! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (user.countryCode! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (user.security! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (user.answer! as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print(selectIfUserExists(db: db, user: user))
                idValue += 1
                UserDefaults.standard.set(idValue, forKey: "userId")
                UserDefaults.standard.synchronize()
                result = true
            }
        }
        sqlite3_finalize(insertStatement)
        return result
    }
    
    func selectUserForId(db:OpaquePointer?, uid:Int32) -> User? {
        
        var user:User? = User()
        
        let selectString = """
        SELECT * FROM USER WHERE Id = \(uid);
        """
        var selectStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectString, -1, &selectStatement, nil) == SQLITE_OK {
            if sqlite3_step(selectStatement) == SQLITE_ROW {
                user = User()
                user?.uid = sqlite3_column_int(selectStatement, 0)
                user?.userName = String(cString: sqlite3_column_text(selectStatement, 1))
                user?.email = String(cString: sqlite3_column_text(selectStatement, 2))
                user?.password = String(cString: sqlite3_column_text(selectStatement, 3))
                user?.mobileNumber = String(cString: sqlite3_column_text(selectStatement, 4))
                user?.countryCode = String(cString: sqlite3_column_text(selectStatement, 5))
                user?.security = String(cString: sqlite3_column_text(selectStatement, 6))
                user?.answer = String(cString: sqlite3_column_text(selectStatement, 7))
            }
        }
        return user
    }
    
    func selectIfUserExists(db:OpaquePointer?, user:User) -> Int {
        let num = user.mobileNumber
        var pwd = ""
        do {
            pwd = (try (user.password)?.decryptMessage(encryptionKey: encryptionKeyString))!
        }catch{print("Error message")}
        let selectString = """
                            SELECT COUNT(*), * FROM USER WHERE Mobile = '\(num!)';
                            """
        var selectStatement:OpaquePointer? = nil
        let value = 0
        if sqlite3_prepare_v2(db, selectString, -1, &selectStatement, nil) == SQLITE_OK {
            if sqlite3_step(selectStatement) == SQLITE_ROW {
                let value = sqlite3_column_int(selectStatement, 0)
                
                if (value != 0) {
                    let password = String(cString: sqlite3_column_text(selectStatement, 4))
                    var dePwd = ""
                    do {
                        dePwd = try password.decryptMessage(encryptionKey: encryptionKeyString)
                    }catch{print("Error message")}
                    
                    if (pwd == dePwd) {
                        User.currentUser.uid = sqlite3_column_int(selectStatement, 1)
                        User.currentUser.userName = String(cString: sqlite3_column_text(selectStatement, 2))
                        User.currentUser.email = String(cString: sqlite3_column_text(selectStatement, 3))
                        User.currentUser.password = String(cString: sqlite3_column_text(selectStatement, 4))
                        User.currentUser.mobileNumber = String(cString: sqlite3_column_text(selectStatement, 5))
                        User.currentUser.countryCode = String(cString: sqlite3_column_text(selectStatement, 6))
                        User.currentUser.security = String(cString: sqlite3_column_text(selectStatement, 7))
                        User.currentUser.answer = String(cString: sqlite3_column_text(selectStatement, 8))
                        return Int(value)
                    }
                    return 0
                }
                return Int(value)
            }
        }
        return value
    }
    
    func updatePassword(db:OpaquePointer?, newPass:String) -> Bool {
        let updateString = """
        UPDATE USER SET Password ='\(newPass)' WHERE Password = '\(User.currentUser.password!)';
        """
        var updateStmt:OpaquePointer? = nil
        var value = false
        if sqlite3_prepare_v2(db, updateString, -1, &updateStmt, nil) == SQLITE_OK {
            if sqlite3_step(updateStmt) == SQLITE_DONE {
                User.currentUser.password = newPass
                value = true
            }
        }
        sqlite3_finalize(updateStmt)
        return value
    }
    
    func deleteReminder(db:OpaquePointer?, remainder:Reminder) -> Bool {
        let deleteString = """
        DELETE FROM REMINDER WHERE Id = \(remainder.rid!);
        """
        var deleteStmt:OpaquePointer? = nil
        var value = false
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStmt, nil) == SQLITE_OK {
            if sqlite3_step(deleteStmt) == SQLITE_DONE {
                value = true
            }
        }
        sqlite3_finalize(deleteStmt)
        return value
    }
    
    /*func checkIfUserTableExistsOrNot() -> Bool {
     
    }
    
    func insertDataIntoUserTable(insertStmt insert:String) -> Bool {
        
        
        if sqlite3_prepare_v2(database, insert, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        return true
    }
    
    func inserDataToUSer(userData user:User) {
        var insertStatement: OpaquePointer? = nil
        let insertString = "INSERT INTo User (id, name, email, mobile, contryCode, password, securityQ, answer, terms) values (?, ?, ?, ?, ?, ?, ?, ?, ?)"

        if sqlite3_prepare_v2(database, insertString, -1, &insertStatement, nil) == SQLITE_OK {
            let name: NSString = user.userName! as NSString
            let email: NSString = user.email! as NSString
            let mobile: NSString = user.mobileNumber! as NSString
            let country: NSString = user.countryCode! as NSString
            let pwd: NSString = user.password! as NSString
            let sec: NSString = user.security! as NSString
            let ans: NSString = user.answer! as NSString
            
            
            sqlite3_bind_int(insertStatement, 1, Int32(user.uid!))
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, email.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, mobile.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, country.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, pwd.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, sec.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, ans.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 9, Int32(user.terms!))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    } */
}
