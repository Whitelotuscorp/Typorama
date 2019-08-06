//
//  WaterMark_VW.swift
//  Typorama
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class WaterMarkVW: UIView {
    
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var lbl_Upgrade: UILabel!
    
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
        
        self.contentView.backgroundColor = COLOR_GrayL210
        
        self.lbl_Upgrade.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Upgrade.textColor = COLOR_White
        self.lbl_Upgrade.backgroundColor = COLOR_GrayD060
        self.lbl_Upgrade.clipsToBounds = true
        self.lbl_Upgrade.layer.cornerRadius = 5
    }
}
