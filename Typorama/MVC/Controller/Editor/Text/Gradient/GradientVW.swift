//
//  GradientVW.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class GradientVW: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var sld_Direction: UISlider!
    
    @IBOutlet weak var lbl_Direction: UILabel!
    @IBOutlet weak var lbl_Gradient: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
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
        self.contentView.backgroundColor = .clear
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.contentView)
        
        self.sld_Direction.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        self.lbl_Direction.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Direction.textColor = COLOR_Black
        
        self.lbl_Gradient.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Gradient.textColor = COLOR_White
        self.lbl_Gradient.backgroundColor = COLOR_GrayD060
        self.lbl_Gradient.clipsToBounds = true
        self.lbl_Gradient.layer.cornerRadius = 5
    }
    
    @IBAction func action_ChangeValues(_ sender: UISwitch) {
        
//        if sender.isOn {
//           
//            sender.thumbTintColor = .gray
//        }
//        else {
//            
//            sender.thumbTintColor = .black
//        }
    }
}

