//
//  WebServiceManager.swift
//  QED
//
//  Created by Apple on 11/07/16.
//  Copyright © 2016 whitelotuscorporation. All rights reserved.
//

import UIKit

let VERSION_KEY = "VERSION_KEY"
let DB_NAME = "db_Typorama"
let DB_TYPE = "sqlite"
let DB_UPGRADE_NAME = "db_Typorama"
let DB_UPGRADE_TYPE = "plist"

class DataManager: NSObject {

    var db = FMDatabase()
    var rs = FMResultSet()
    var databaseQueue = FMDatabaseQueue()
    
    static var instance: DataManager!
    
    
    //MARK: - Copy DataBase
    
    func getDBPath() -> String {
        
        let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray;
        let filePath = (documentsPath[0] as AnyObject).appendingPathComponent(String(format: "%@.%@", DB_NAME, DB_TYPE)) as String
        return filePath
    }
    
    class func copyDBIfNeeded() {
        
        let filemanager = FileManager.default
        
        var success = Bool()
        success = filemanager.fileExists(atPath: DataManager.init().getDBPath())
        print(DataManager.init().getDBPath())
        if success == false {
            
            let defaultDBPath = Bundle.main.path(forResource: DB_NAME, ofType: DB_TYPE)
            let data = NSData(contentsOfFile: defaultDBPath!)
            
            data?.write(toFile: DataManager.init().getDBPath(), atomically: true)
        }
    }
    
    //MARK: - database update if needed in ios
    
    func versionNumberString() -> String? {
        
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion = infoDictionary?["CFBundleVersion"] as? String
        return majorVersion
    }
    
   class func upgradeDatabaseIfRequired() {
        
        var previousVersion : String = ""
        let currentVersion : String = DataManager.init().versionNumberString()!
        
        if let mversion = AppDelegateGet.string(forKey: VERSION_KEY) {
            
            previousVersion = mversion
        }
        
        print(previousVersion)
        
        if previousVersion == "" || previousVersion.compare(currentVersion, options: .numeric) == .orderedAscending {
            
            let plistPath = Bundle.main.path(forResource: DB_UPGRADE_NAME, ofType: DB_UPGRADE_TYPE)
            let plist : NSArray = NSArray(contentsOfFile: plistPath!)!
            
            if previousVersion == "" {
                
                for value in plist {
                    
                    let dict = value as! NSDictionary
                    
                    let version = dict.value(forKey: "version") as! String
                    print(version)
                    let sqlQueries = dict.value(forKey: "sql") as! NSArray
                    
                    for query in sqlQueries {
                        
                        DataManager.initDB().EXECUTE_Query(query: query as! String)
                    }
                }
            }
            else {
                
                for value in plist {
                    
                    let dict = value as! NSDictionary
                    let version = dict.value(forKey: "version") as! String
                    print(version)
                    
                    if previousVersion.compare(version, options: .numeric) == .orderedAscending {
                        
                        let sqlQueries = dict.value(forKey: "sql") as! NSArray
                        
                        for query in sqlQueries {
                            
                            DataManager.initDB().EXECUTE_Query(query: query as! String)
                        }
                    }
                }
            }
            
            AppDelegateGet.set(currentVersion, forKey: VERSION_KEY)
            AppDelegateGet.synchronize()
        }
    }
    
    //MARK: - init Database
    
    class func initDB() -> DataManager {
        
        var isInit : Bool = true
        if (self.instance != nil) {
         
            isInit = false
        }
        
        self.instance = (self.instance ?? DataManager())
        
        if isInit {
            
            self.instance.databaseQueue = FMDatabaseQueue(path: self.instance.getDBPath())
        }
        return self.instance
    }
    
    func initFMDB() {
        
        self.db.close()
        self.db = FMDatabase(path: self.getDBPath())
    }
    
    func stringNullCheck(str: String) -> String {
        
        if str.count == 0 {
            
            return ""
        }
        else {
            
            return str
        }
    }
    
    
    //MARK: - Query
    // EXECUTE update type query
    func EXECUTE_Query(query: String) {
     
        self.initFMDB()
        
        if self.db.open() {
          
           self.db.executeUpdate(query, withArgumentsIn: nil)
        }
        self.db.close()
    }
    
    // Retrieve only one column value
    func CHECKDATA_ExistOrNot(query: String) -> Bool {
        self.initFMDB()
        var isExist : Bool = false
        if self.db.open() {
            
            self.rs = self.db.executeQuery(query, withArgumentsIn: nil)
            while self.rs.next() {
                
                isExist = true
                break
            }
        }
        self.db.close()
        return isExist
    }
    
    // Retrieve only one column value
    func RETRIEVE_LastId(query: String) -> String {
        self.initFMDB()
        var str_Id = String(format: "")
        if self.db.open() {
            
            self.rs = self.db.executeQuery(query, withArgumentsIn: nil)
            
            while self.rs.next() {
                
                str_Id = self.stringNullCheck(str: self.rs.string(forColumn: "id"))
            }
        }
        self.db.close()
        return str_Id
    }
    
    // Retrieve Settings value
    func RETRIEVE_Logo(query: String) -> infoLogo {
        
        self.initFMDB()
        let info_Logo = infoLogo()
        if self.db.open() {
            
            self.rs = self.db.executeQuery(query, withArgumentsIn: nil)
            
            while self.rs.next() {
                
                
                info_Logo.l_id = self.stringNullCheck(str: self.rs.string(forColumn: "l_id"))
                info_Logo.lp_id = self.stringNullCheck(str: self.rs.string(forColumn: "lp_id"))
            }
        }
        self.db.close()
        return info_Logo
    }
    func RETRIEVE_LogoList(query: String) -> NSMutableArray {
        
        self.initFMDB()
        let muary_Data = NSMutableArray()
        if self.db.open() {
            
            self.rs = self.db.executeQuery(query, withArgumentsIn: nil)
            
            while self.rs.next() {
                
                let infoLL = infoLogoList()
                infoLL.l_id = self.stringNullCheck(str: self.rs.string(forColumn: "l_id"))
                infoLL.l_type = LogoType(rawValue: Int(self.rs.string(forColumn: "l_type"))!)!
                infoLL.l_image = self.stringNullCheck(str: self.rs.string(forColumn: "l_image"))
                infoLL.l_text = self.stringNullCheck(str: self.rs.string(forColumn: "l_text"))
                infoLL.l_font = self.stringNullCheck(str: self.rs.string(forColumn: "l_font"))
                infoLL.l_shadow = Float(self.rs.string(forColumn: "l_shadow"))!
                infoLL.l_color = self.stringNullCheck(str: self.rs.string(forColumn: "l_color"))
                infoLL.l_opacity = Float(self.rs.string(forColumn: "l_opacity"))!
                infoLL.l_size = self.stringNullCheck(str:self.rs.string(forColumn: "l_size"))
                infoLL.l_origin = self.stringNullCheck(str:self.rs.string(forColumn: "l_origin"))
                infoLL.l_super_size = self.stringNullCheck(str:self.rs.string(forColumn: "l_super_size"))
                
                muary_Data.add(infoLL)
            }
        }
        self.db.close()
        return muary_Data
    }
}
