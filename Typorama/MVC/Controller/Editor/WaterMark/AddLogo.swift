//
//  AddLogo.swift
//  Typorama
//
//  Created by Apple on 07/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc
enum LogoType : Int {
    
    case Text
    case Photo
}

@objc protocol AddLogoDelegate: class {
    
    @objc optional func addLogo(view: AddLogo, Logo type: LogoType)
}

class AddLogo: UIView {
    
    weak var delegate : AddLogoDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Alert: UIView!
    
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Photo: UIButton!
    @IBOutlet weak var btn_Text: UIButton!
        
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: AppDelegateObj.window!.frame)
        AppDelegateObj.window?.addSubview(self)
        // 3. Setup view from .xib file
        configureXIB()
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        configureXIB()
    }
    func configureNib() -> UIView {
                
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    func configureXIB() {
        
        
        self.contentView = configureNib()
        self.contentView.frame = bounds
//        self.contentView.backgroundColor = .clear
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.contentView)
        
        self.lbl_Title.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        
        for btn in [self.btn_Photo, self.btn_Text, self.btn_Cancel] {
            
            btn!.clipsToBounds = true
            btn!.layer.cornerRadius = 8
            btn!.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
            btn!.titleLabel!.numberOfLines = 0
        }
        
        self.vw_Alert.backgroundColor = COLOR_GrayL210
        self.vw_Alert.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.vw_Alert.clipsToBounds = true
        self.vw_Alert.layer.cornerRadius = 8
    }
    
    func show() {
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {() -> Void in
            self.vw_Alert.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
    }
    
    @IBAction func action_Button(sender: UIButton) {
        
        if sender == self.btn_Photo {
            
            self.delegate?.addLogo?(view: self, Logo: LogoType.Photo)
        }
        else if sender == self.btn_Text {
            
            self.delegate?.addLogo?(view: self, Logo: LogoType.Text)
        }
        
        self.hide()        
    }
    
    func hide() {
        
        self.vw_Alert.transform = .identity
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.vw_Alert.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
            self.vw_Alert.isHidden = true
            self.removeFromSuperview()
        })
    }
}
