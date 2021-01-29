//
//  SocialSharing.swift
//  Typorama
//
//  Created by Lakum on 13/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MessageUI
import FBSDKShareKit
import TwitterKit

class DocumentInfo: NSObject {
    
    var kURL : String  = ""
    var kUTI : String  = ""
    var kCaption : String  = ""
    var kfileNameExtension : String  = ""
    
    var kAlertTitle = "Error"
    var kAlertMessageFormat = ""
        
    init(type: ShareType) {
        
        if type == .Instagram {
            
            self.kURL = "instagram://"
            self.kUTI = "com.instagram.photo"
            self.kfileNameExtension = "instagram.ig"
            self.kAlertMessageFormat = String(format: "Please install the %@ application", type.rawValue)
        }
        else {
            
            self.kURL = "whatsapp://"
            self.kUTI = "net.whatsapp.image"
            self.kfileNameExtension = "whatsAppTmp.wai"
            self.kAlertMessageFormat = String(format: "Please install the %@ application", type.rawValue)
        }
    }
}

enum ShareType : String {
    
    case Save
    case Instagram
    case Facebook
    case WhatsApp
    case Mail
    case Message
    case Messenger
    case Twitter
    case Other
}
 
protocol SocialSharingDelegate: class {
    
    func socialShare(type: ShareType, success: Bool, error: Error?)
}
    
class SocialSharing: NSObject {

    weak var delegate : SocialSharingDelegate?
    
    var type : ShareType = .Save
    
    private let documentInteractionController = UIDocumentInteractionController()
    
    
    static var instance: SocialSharing!
    class func shared() -> SocialSharing {
        
        self.instance = (self.instance ?? SocialSharing())
        return self.instance
    }
    
    func shareImage(image: UIImage, With type: ShareType, delegate: SocialSharingDelegate) {
     
        self.delegate = delegate
        self.type = type
        let vc = self.delegate as! UIViewController
        if type == .Save {
            
            AppSingletonObj.manageMBProgress(isShow: false)
            PhotosAlbum.shared().savePhoto(image: image, InAlbum: AppName, completionBlock: { (success) in

                AppSingletonObj.manageMBProgress(isShow: false)
                self.delegate?.socialShare(type: self.type, success: true, error: nil)
            })
        }
        else if type == .Mail {
            
            self.sendMail(image: image, From: vc)
        }
        else if type == .Message {
            
            self.sendMessage(image: image, From: vc)
        }
        else if type == .Facebook {
         
            self.faceBook(image: image, From: vc)
        }
        else if type == .Messenger {
         
            self.faceBookMessenger(image: image, From: vc)
        }
        else if type == .Twitter {
         
            self.twitter(image: image, From: vc)
        }
        else if type == .Instagram || type == .WhatsApp {
         
            self.postImageViaDocumentController(image: image, info: DocumentInfo(type: type), vc: vc)
        }
        else {
         
            self.postImageViaActivityViewController(image: image, From: vc)
        }
    }
    
    func sendMail(image: UIImage, From vc: UIViewController) {
         
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["budgetboxapp@gmail.com"])
            mailComposerVC.setSubject("Posterooh")
            mailComposerVC.setMessageBody("Check out Budget Box", isHTML: false)
            
            let pngData = image.pngData()
            mailComposerVC.addAttachmentData(pngData!, mimeType: "image/png", fileName: "Posterooh.png")
            
            vc.present(mailComposerVC, animated: true, completion: nil)
        }
        else {
            
            self.delegate?.socialShare(type: self.type, success: true, error: nil)
            AppSingletonObj.alertShow(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", From: vc, btnTitle: "OK")
        }
    }
    
    func sendMessage(image: UIImage, From vc: UIViewController) {
         
        if MFMessageComposeViewController.canSendText() {
            
            let controller = MFMessageComposeViewController()
            controller.body = "Check out Budget Box"
            controller.messageComposeDelegate = self
            
            let pngData = image.pngData()
            controller.addAttachmentData(pngData!, typeIdentifier: "image/png", filename: "Posterooh.png")
            
            vc.present(controller, animated: true, completion: nil)
        }
        else {
            
            self.delegate?.socialShare(type: self.type, success: true, error: nil)
            AppSingletonObj.alertShow(title: "Could Not Send Message", message: "Your device could not send message.", From: vc, btnTitle: "OK")
        }
    }
    
    func faceBook(image: UIImage, From vc: UIViewController) {
        
        let photo = SharePhoto(image: image, userGenerated: true)
        let content = SharePhotoContent()
        content.photos = [photo]
        
        let dialog = ShareDialog()
        dialog.fromViewController = vc
        dialog.delegate = self
        dialog.shareContent = content
        dialog.mode = ShareDialog.Mode.shareSheet
        dialog.show()
    }
    
    func faceBookMessenger(image: UIImage, From vc: UIViewController) {
        
//        let photo = FBSDKSharePhoto(image: image, userGenerated: true)
//        let content = FBSDKSharePhotoContent()
//        content.photos = [photo as Any]
//
//        let contentM = FBSDKShareMessenger
//        contentM.

        let element = ShareMessengerGenericTemplateElement()
        element.title = "Posterooh"
        element.subtitle = "wow! Amazing."
        element.imageURL = URL(string: "http://wlctest.online/InvestWise/assets/uploads/profile/applogo_1024.png")
        
        let content = ShareMessengerGenericTemplateContent()
        content.element = element;
        
        let messageDialog = MessageDialog()
        messageDialog.shareContent = content
        messageDialog.delegate = self
        
        if messageDialog.canShow {
            messageDialog.show()
        }
        else {

            self.delegate?.socialShare(type: self.type, success: false, error: nil)
            AppSingletonObj.alertShow(title: "Facebook Messenger not installed", message: "You don't have the Facebook Messenger on your device, download it from App Store", From: vc, btnTitles: ["Cancel", "OK"]) { (success, button) in

            }
        }
        
//        let photo = FBSDKSharePhoto(image: image, userGenerated: true)
//        let content = FBSDKSharePhotoContent()
//        content.photos = [photo as Any]
//
//        let contentM = FBSDKShareMessengerMediaTemplateContent()
//
//        let dialog = FBSDKMessageDialog()
//        dialog.shareContent = contentM
//
//        if dialog.canShow {
//
//            dialog.show()
//        }
//        else {
//
//            self.delegate?.socialShare(type: self.type, success: false, error: nil)
//            AppSingletonObj.alertShow(title: "Facebook Messenger not installed", message: "You don't have the Facebook Messenger on your device, download it from App Store", From: vc, btnTitles: ["Cancel", "OK"]) { (success, button) in
//
//            }
//        }
    }
    
    func twitter(image: UIImage, From vc: UIViewController) {
     
//        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
//            // App must have at least one logged-in user to compose a Tweet
//            let composer = TWTRComposer()
//            composer.setImage(image)
//
//            composer.show(from: vc) { (result) in
//                
//                self.delegate?.socialShare(type: self.type, success: true, error: nil)
//            }
//        }
//        else {
//            // Log in, and then check again
//            
//            TWTRTwitter.sharedInstance().logIn(with: vc) { (session, error) in
//        
//                if session != nil { // Log in succeeded
//                    
//                    self.twitter(image: image, From: vc)
//                } else {
//                    
//                    self.delegate?.socialShare(type: self.type, success: false, error: error)
//                    AppSingletonObj.alertShow(title: "No Twitter Accounts Available", message: error?.localizedDescription, From: vc, btnTitle: "OK")
//                }
//            }
//        }
    }
    
    func postImageViaDocumentController(image: UIImage, info: DocumentInfo, vc: UIViewController) {
                
        let instagramURL = NSURL(string: info.kURL)
        
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(info.kfileNameExtension)
            
            do {
                try image.jpegData(compressionQuality: 1.0)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            } catch {
                print(error)
            }

            let rect = CGRect.zero
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            
            
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = info.kUTI
            
            documentInteractionController.annotation = [info.kCaption: "Posterooh"]
            documentInteractionController.presentOpenInMenu(from: rect, in: vc.view, animated: true)
        }
        else {
            
            AppSingletonObj.alertShow(title: info.kAlertTitle, message: info.kAlertMessageFormat, From: vc, btnTitle: "OK")
        }
        
        self.delegate?.socialShare(type: self.type, success: true, error: nil)
    }
    
    func postImageViaActivityViewController(image: UIImage, From vc: UIViewController) {
     
        let activityItem: [AnyObject] = [image as AnyObject]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        vc.present(avc, animated: true, completion: nil)
        self.delegate?.socialShare(type: self.type, success: true, error: nil)
    }
}

extension SocialSharing: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        self.delegate?.socialShare(type: self.type, success: true, error: nil)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.delegate?.socialShare(type: self.type, success: true, error: nil)
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SocialSharing: SharingDelegate {
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
            
        self.delegate?.socialShare(type: self.type, success: true, error: nil)
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        
        self.delegate?.socialShare(type: self.type, success: false, error: error)
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
                
        self.delegate?.socialShare(type: self.type, success: false, error: nil)
    }
}

extension SocialSharing: UIDocumentInteractionControllerDelegate {
    
}
