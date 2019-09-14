//
//  AppSingleton.swift
//  Wedding
//
//  Created by Shiv on 20/01/18.
//  Copyright © 2018 Shiv. All rights reserved.
//

import UIKit

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
    
    //MARK: - Email Validation
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK: - FilePath & Write    
    func getFilePath(filename: String?) -> String{
        
        let documentsPath: NSArray = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as NSArray;
        let filePath = (documentsPath[0] as AnyObject).appendingPathComponent(filename!) as String
        
        return filePath
    }
    
    func writeFile(filePath: String?, data:NSData?){
        
        data?.write(toFile: filePath!, atomically: true)
    }
    
    func changeDateFormat(date:String, Change format: String, To formatTo: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dt_Change = dateFormatter.date(from: date)
        dateFormatter.dateFormat = formatTo
        return dateFormatter.string(from: dt_Change!)
    }
    
    func changeStringToDate(date:String, With format: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)!
    }
    
    func changeDateToString(date:Date, With format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    //MARK: - UIAlertView
    func alertShow(title: String?, message: String?, From controller: UIViewController? ,btnTitle: String?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
    func alertShow(title: String?, message: String?, From controller: UIViewController? ,btnTitle: String?, CompletionHandler:@escaping (_ code: Bool) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (alert: UIAlertAction!) in
            
             CompletionHandler(true)
        }))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    func setBarButtonWithTitle(title: String, target: UIViewController, selecter:Selector) -> UIBarButtonItem {
        
        let BackButton = UIButton(type: .custom)
        BackButton.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)!
        BackButton.setTitle(title, for: .normal)
//        BackButton.setTitleColor(kCOLOR_Blue, for: .normal)
        BackButton.sizeToFit()
        BackButton.addTarget(target, action:selecter, for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: BackButton)
        
        return barButton
    }
    
    func setBarButtonWithImage(image: String, target: UIViewController, selecter:Selector) -> UIBarButtonItem {
        
        let BackButton = UIButton()
        BackButton.setImage(UIImage.init(named: image), for: .normal)
        BackButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        BackButton.addTarget(target, action:selecter, for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: BackButton)
        
        return barButton
    }
    
//    func setBarButtonWithFoneAwesome(icon: String, With size: CGFloat, target: UIViewController, selecter:Selector) -> UIBarButtonItem {
//
//        let BackButton = UIButton()
//        BackButton.titleLabel?.font = UIFont.fontAwesome(ofSize: size)
//        BackButton.setTitle(String.fontAwesomeIcon(code: icon), for: .normal)
//        BackButton.setTitleColor(kCOLOR_Blue, for: .normal)
//        BackButton.sizeToFit()
//        BackButton.addTarget(target, action:selecter, for: UIControlEvents.touchUpInside)
//        let barButton = UIBarButtonItem(customView: BackButton)
//
//        return barButton
//    }
    
    func openCamera(from: UIViewController)  {
        
        let optionMenu = UIAlertController(title: "Set Photo!", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take photo", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            self.action_ChoosePhoto(type: .camera, With: from)
        })
        let photoAction = UIAlertAction(title: "Choose from library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            self.action_ChoosePhoto(type: .photoLibrary, With: from)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
        optionMenu.addAction(cancelAction)
        
        from.present(optionMenu, animated: true, completion: nil)
    }

    func action_ChoosePhoto(type: UIImagePickerController.SourceType, With from: UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            
            let imag = UIImagePickerController()
            imag.delegate = (from as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            imag.sourceType = type
            imag.allowsEditing = true
            from.present(imag, animated: true, completion: nil)
        }
    }
    
    func newViewController(identifier: String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func changeImageColor(_ icon: UIImageView, With color: UIColor) {
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = color
        }
    }

    func addActivityIndicatorOnImage(imgvw: UIImageView) {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = imgvw.center
        activityIndicator.hidesWhenStopped = true
        imgvw.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func removeActivityIndicatorOnImage(imgvw: UIImageView) {
        
        for vw in imgvw.subviews  {
            
            if vw.isKind(of: UIActivityIndicatorView.self) {
             
                vw.removeFromSuperview()
            }
        }
    }
    
    func image(with view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
//        let color = UIColor.init(patternImage: self.imageWithGradient(img: image))
//        return self.setImageClipMask(image, color: color)
    }
    
    func imageWithGradient(img:UIImage!) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor.black.cgColor
        let top = UIColor.white.cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
//        let startPoint = CGPoint(x: img.size.width/2, y: 0)
//        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        let point = self.calculatePoints(for: 45)
        let startPoint = point[0]
        let endPoint = point[1]
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    func tanx(_ 𝜽: CGFloat) -> CGFloat {
        return tan(𝜽 * CGFloat.pi / 180)
    }
    func calculatePoints(for angle: CGFloat) -> [CGPoint] {
        
        var ang = (-angle).truncatingRemainder(dividingBy: 360)
        
        if ang < 0 { ang = 360 + ang }
        
        let n: CGFloat = 0.5
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero

        
        switch ang {
            
        case 0...45, 315...360:
            let a = CGPoint(x: 0, y: n * tanx(ang) + n)
            let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
            
            startPoint = a
            endPoint = b
            
        case 45...135:
            let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            startPoint = a
            endPoint = b
            
        case 135...225:
            let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
            let b = CGPoint(x: 0, y: n * tanx(ang) + n)
            startPoint = a
            endPoint = b
            
        case 225...315:
            let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            startPoint = a
            endPoint = b
            
        default:
            let a = CGPoint(x: 0, y: n)
            let b = CGPoint(x: 1, y: n)
            startPoint = a
            endPoint = b
            
        }
        
        return [startPoint, endPoint]
    }
    
    func setImageClipMask(_ image: UIImage?, color: UIColor?) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: (image?.size.height)!)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.clip(to: rect, mask: (image?.cgImage)!)
        context?.setFillColor(color!.cgColor)
        context?.fill(rect)
        let img_clip = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img_clip
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
    
    func randomNumber(last: Int, min: Int, max: Int, isCheck: Bool = false) -> Int {
        
        var randomInt = Int.random(in: min ..< max)
        var count = 0
        while last == randomInt {
            
            randomInt = Int.random(in: min ..< max)
            
            if isCheck == true && count > 10 {
                
                break
            }
            
            count += 1
        }
        return randomInt
    }
    
    func randomNumber(min: Int, max: Int) -> Int {
        
        let randomInt = Int.random(in: min ..< max)
        return randomInt
    }
    
    func randomDecimal(min: Float, max: Float) -> Float {
        
        let randomFlt = Float.random(in: min ..< max)
        return randomFlt
    }
    
    func createImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return UIImage() }
        
        return UIImage.init(cgImage: cgImage)
    }
    
    func takeScreenShotMethod(view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image!
    }
}
