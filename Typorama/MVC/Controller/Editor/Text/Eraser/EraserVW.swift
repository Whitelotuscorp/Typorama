//
//  EraserVW.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol EraserVWDelegate: class {
    
    @objc optional func eraser(view: EraserVW, didChangeValue slider: UISlider)
    @objc optional func eraserUndoLast(view: EraserVW)
}

class EraserVW: UIView {
    
    weak var delegate : EraserVWDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var btn_Undo: UIButton!
    @IBOutlet weak var lbl_Size: UILabel!
    @IBOutlet weak var lbl_Intensity: UILabel!
    
    @IBOutlet weak var sld_Size: UISlider!
    @IBOutlet weak var sld_Intensity: UISlider!
    
    
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
        
        self.sld_Size.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        self.sld_Intensity.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        self.lbl_Intensity.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Intensity.textColor = COLOR_Black
        
        self.lbl_Size.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Size.textColor = COLOR_Black
        
        self.btn_Undo.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.btn_Undo.titleLabel!.textAlignment = .center
        self.btn_Undo.titleLabel!.numberOfLines = 0
        self.btn_Undo.setTitleColor(COLOR_White, for: .normal)
        self.btn_Undo.backgroundColor = COLOR_GrayD060
        self.btn_Undo.clipsToBounds = true
        self.btn_Undo.layer.cornerRadius = 5
    }
    @IBAction func action_Undo(_ sender: UIButton) {
        
        self.delegate?.eraserUndoLast?(view: self)
    }
    @IBAction func action_ChangeSlider(_ slider: UISlider) {
        
        self.delegate?.eraser?(view: self, didChangeValue: slider)
    }
}

