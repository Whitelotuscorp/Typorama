//
//  TextEditor_VC.swift
//  Typorama
//
//  Created by Apple on 12/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol TextEditorDelegate: class {
    
    @objc optional func textEditorDidFinishEdit(text: String, With isLine: Bool)
}
    
class TextEditor_VC: UIViewController {

    weak var delegate : TextEditorDelegate?
    
    @IBOutlet weak var vw_Status: UIView!
    
    @IBOutlet weak var imgvw_BG: UIImageView!
    
    @IBOutlet weak var btn_Done: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Quote: UIButton!
    @IBOutlet weak var btn_Dice: UIButton!
    @IBOutlet weak var btn_Line: UIButton!
    
    @IBOutlet weak var swtch_Line: UISwitch!
    
    @IBOutlet weak var txt_Text: UITextField!
    @IBOutlet weak var txtvw_Text: UITextView!
    
    @IBOutlet weak var lbl_CharCount: UILabel!
    
    @IBOutlet weak var toolbar_Menu: UIToolbar!
    @IBOutlet weak var lyl_b_Toolbar: NSLayoutConstraint!
    
    var img_BG : UIImage = UIImage()
    
    var str_Text : String = ""
    
    var isLine : Bool = false
    
    var maxChar = 350
    var lastIndexQuote = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = COLOR_Cream
        self.vw_Status.backgroundColor = COLOR_Cream
        self.imgvw_BG.image = self.img_BG
        
        self.btn_Done.setTitleColor(COLOR_Black, for: .normal)
        self.btn_Done.backgroundColor = .clear
        self.btn_Done.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        
        self.btn_Cancel.setTitleColor(COLOR_Black, for: .normal)
        self.btn_Cancel.backgroundColor = .clear
        self.btn_Cancel.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        
        self.txtvw_Text.text = str_Text
        self.textViewDidChange(self.txtvw_Text)
        
        self.toolbar_Menu.barTintColor = COLOR_GrayD060
        
        self.lbl_CharCount.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size20)
        
        self.btn_Dice.titleLabel?.font = UIFont.fontAwesome(ofSize: APPFONT_Size22, style: .solid)
        self.btn_Dice.setTitle(String.fontAwesomeIcon(name: .dice), for: .normal)
        
        self.btn_Line.titleLabel?.numberOfLines = 2
        self.btn_Line.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.btn_Quote.titleLabel?.numberOfLines = 2
        self.btn_Quote.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        
        self.swtch_Line.isOn = self.isLine
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.txtvw_Text.becomeFirstResponder()
    }
    @IBAction func action_Cancel(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func action_Done(_ sender: UIButton) {
        
        let str_Text = self.txtvw_Text.text //.condenseWhitespace()
        
        self.dismiss(animated: true) {
            
            self.delegate?.textEditorDidFinishEdit?(text: str_Text!, With: self.swtch_Line.isOn)
        }
    }
    
    @IBAction func action_Quote(_ sender: UIButton) {
        
        self.lastIndexQuote = AppSingletonObj.randomNumber(last: self.lastIndexQuote, min: 0, max: ARRAY_Quote.count - 1)
        self.txtvw_Text.text = ARRAY_Quote[self.lastIndexQuote]        
        self.textViewDidChange(self.txtvw_Text)
    }
    
    @IBAction func action_Line(_ sender: UISwitch) {
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                let h_Bottom : CGFloat = (AppDelegateObj.window?.safeAreaInsets.bottom)!
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {() -> Void in
                    self.lyl_b_Toolbar.constant = keyboardSize.height - h_Bottom
                    self.view.layoutIfNeeded()
                }, completion: {(finished: Bool) -> Void in
                    // do something once the animation finishes, put it here
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            
            self.lyl_b_Toolbar.constant = 0
            self.view.updateConstraintsIfNeeded()
        }
    }
}

extension TextEditor_VC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
     
//        textView.text = textView.text.uppercased()
        
        self.lbl_CharCount.text = String(format: "%d", Int(maxChar - textView.text.count))
        if textView.text.count > 0 {
            
            self.txt_Text.isHidden = true
        }
        else {
            
            self.txt_Text.isHidden = false
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.count >= maxChar && text != "" {
            
            return false
        }
        
//        let str_Last = textView.text.suffix(1)
//
//        if textView.text.count > 0 {
//
//            let str_First = String(textView.text.prefix(textView.text.count - 1)) as String
//
//            if str_Last == " " && text == "\n" {
//
//                textView.text = str_First
//            }
//            if str_Last == "\n" && text == " " {
//
//                textView.text = str_First
//            }
//        }
//
//        if textView.text.count == 0 && text == " " {
//
//            return false
//        }
//        else if str_Last == text && text == " " {
//
//            return false
//        }
//        else if text == "\n" {
//
//            return false
//        }
//        else {
        
            return true
//        }
    }
}
