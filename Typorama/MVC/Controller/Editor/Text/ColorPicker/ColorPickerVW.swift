//
//  ColorPickerVW.swift
//  DemoGradient
//
//  Created by Apple on 19/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol ColorPickerVWDelegate: class {
    
    @objc optional func colorPicker(view: ColorPickerVW, DidSelect color: UIColor)
}

class ColorPickerVW: UIView {
    
    weak var delegate : ColorPickerVWDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Color: UIView!
    
    @IBOutlet var btn_Done: UIButton!
    
    @IBOutlet var lbl_Title: UILabel!
      
    @IBOutlet var colorPicker: ILSaturationBrightnessPickerView!
    @IBOutlet var huePicker: ILHuePickerView!
    
    @IBOutlet weak var lyl_B_Color: NSLayoutConstraint!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
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
        self.contentView.backgroundColor = .clear
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.contentView)
        
        self.vw_Color.backgroundColor = COLOR_GrayL240
        
        self.btn_Done.setTitleColor(COLOR_Black, for: .normal)
        self.btn_Done.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        
        self.lbl_Title.textColor = COLOR_Black
        self.lbl_Title.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        
        self.colorPicker.clipsToBounds = true
        self.colorPicker.layer.cornerRadius = 3
        self.colorPicker.layer.borderWidth = 1.0
        self.colorPicker.layer.borderColor = COLOR_GrayL174.cgColor
        
        self.huePicker.clipsToBounds = true
        self.huePicker.layer.cornerRadius = 3
        self.huePicker.layer.borderWidth = 0.0
        
        self.lyl_B_Color.constant = self.frame.height
        self.updateFocusIfNeeded()
        self.layoutIfNeeded()
    }
    
    func show() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {() -> Void in
            
            self.lyl_B_Color.constant = 0.0
            self.layoutIfNeeded()
            
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
    }
    
    func hide() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            
            self.lyl_B_Color.constant = self.frame.height
            self.layoutIfNeeded()
        }, completion: {(finished: Bool) -> Void in

            self.removeFromSuperview()
        })
    }
    
    @IBAction func action_Done(_ sender: UIButton) {
        
        self.hide()
    }
}
