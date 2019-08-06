//
//  AppSingleton.swift
//  QED
//
//  Created by Apple on 13/07/19.
//  Copyright © 2016 whitelotuscorporation. All rights reserved.
//

import UIKit
//import FontAwesome_swift

class AppSingleton: NSObject {

    static var instance: AppSingleton!
    
    class func sharedInstance() -> AppSingleton {
        
        self.instance = (self.instance ?? AppSingleton())
        return self.instance
    }
    
    //MARK: - Login Validation
    func isLoginCheck() -> Bool {
        
        let str_UserId = AppDelegateGET.string(forKey: pref_LoginUserID)
        let str_isLogin = AppDelegateGET.bool(forKey: pref_isLoginSuccessfully)
        
        if (str_UserId != nil && str_UserId != "" && str_isLogin == true) {
            
            return true
        }
        else {
            
            return false
        }
    }
    
    func manageMBProgress(isShow: Bool) {
        
        DispatchQueue.main.async(execute: { () -> Void in
          
            if (isShow == true) {
                
                MBProgressHUD.showAdded(to: AppDelegateObj.window!, animated: true)
            }
            else {
                
                MBProgressHUD.hide(for: AppDelegateObj.window!, animated: true)
            }
        })
    }
    
    func setBarButtonWithTitle(title: String, target: UIViewController, selecter:Selector) -> UIBarButtonItem {
        
        let BackButton = UIButton(type: .custom)
        BackButton.titleLabel?.font = UIFont.init(name: "Avenir-Book", size: 20)
        BackButton.contentHorizontalAlignment = .center
        BackButton.setTitle(title, for: .normal)
        BackButton.setTitleColor(UIColor.white, for: .normal)
        BackButton.sizeToFit()
        BackButton.addTarget(target, action:selecter, for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: BackButton)
        
        return barButton
    }
    
    func setBarButtonWithImage(image: String, With size: CGSize, target: UIViewController, selecter:Selector) -> UIBarButtonItem {
        
        let BackButton = UIButton()
        BackButton.setImage(UIImage.init(named: image), for: .normal)
        BackButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        BackButton.addTarget(target, action:selecter, for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: BackButton)
        
        return barButton
    }
//    
//    func setBarButtonWithFoneAwesome(icon: String, With size: CGFloat, target: UIViewController, selecter:Selector) -> UIBarButtonItem {
//        
//        let BackButton = UIButton(type: .custom)
//        BackButton.titleLabel?.font =  UIFont.fontAwesomeOfSize(size)
//        BackButton.setTitle(String.fontAwesomeIconWithCode(icon), for: .normal)
//        BackButton.setTitleColor(UIColor.white, for: .normal)
//        BackButton.sizeToFit()
//        BackButton.addTarget(target, action:selecter, for: UIControl.Event.touchUpInside)
//        let barButton = UIBarButtonItem(customView: BackButton)
//        
//        return barButton
//    }
    
    //MARK: - UIAlertView
    func alertShow(title: String?, message: String?, delegate: AnyObject?, btnTitle: String?, tag:Int){
        
        let alert_Fill = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: btnTitle)
        alert_Fill.tag = tag
        alert_Fill.show()
    }
    
    //MARK: - FilePath & Write
    
    func getFilePath(name: String) -> String {
        
        let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray;
        let logsPath = (documentsPath[0] as AnyObject).appendingPathComponent("Images") as String
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: logsPath) {
           
            do {
                
                try fileManager.createDirectory(atPath: logsPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError {
                
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        
        
        if name == "" {

            return logsPath
        }
        else {
            
            let filePath = (logsPath as AnyObject).appendingPathComponent(name) as String
            return filePath
        }
    }
    
    func writeFile(filePath: String?, data:NSData?){
        
        data?.write(toFile: filePath!, atomically: true)
    }
    
    func changeNumberFormat(phone: String) -> String {
        
        if phone.count > 2 {
            
            let muary_Str = NSMutableArray(array: Array(phone).map { String($0) })
            muary_Str.insert("(", at: 0)
            muary_Str.insert(") ", at: muary_Str.count > 4 ? 4 : muary_Str.count)
            
            if muary_Str.count > 8 {
                
                muary_Str.insert("-", at: 8 )
            }
            
            return muary_Str.componentsJoined(by: "")
        }
        else {
            
            return phone
        }
    }
    func removeCharacter(phone: String) -> String {
        
        var str_Phone = phone.replacingOccurrences(of: " ", with: "")
        str_Phone = str_Phone.replacingOccurrences(of: "(", with: "")
        str_Phone = str_Phone.replacingOccurrences(of: ")", with: "")
        str_Phone = str_Phone.replacingOccurrences(of: "-", with: "")
        return str_Phone
    }
    
    func changeDateFormat(date: String, from: String, to: String) -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = from
        
        if let c_date = dateFormat.date(from: date) {
            
            dateFormat.dateFormat = to
            return dateFormat.string(from: c_date).lowercased()
        }
        else {
            
            return date
        }
    }
    
    func localToUTC() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter.string(from: Date())
    }
    
    func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"        
        return dateFormatter.string(from: Date())
    }
    
    func UTCToLocal(date:String) -> String {
        
        if date != "" {
         
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let dt = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd MMMM, yyyy hh:mm a"
            return dateFormatter.string(from: dt!)
        }
        else {
            
            return date
        }
    }
}
