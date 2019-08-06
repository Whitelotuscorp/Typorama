//
//  ShadowVW.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc
enum ShadowValue : Int {
    
    case color
    case opacity
    case blur
    case x
    case y
}

@objc protocol ShadowVWDelegate: class {
    
    @objc optional func shadow(view: ShadowVW, Change value: Any, With type: ShadowValue)
}

class ShadowVW: UIView {
    
    weak var delegate : ShadowVWDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var clc_Color: UICollectionView!
    
    @IBOutlet weak var lbl_Opacity: UILabel!
    @IBOutlet weak var lbl_Blur: UILabel!
    @IBOutlet weak var lbl_X: UILabel!
    @IBOutlet weak var lbl_Y: UILabel!
    
    @IBOutlet weak var sld_Opacity: UISlider!
    @IBOutlet weak var sld_Blur: UISlider!
    @IBOutlet weak var sld_X: UISlider!
    @IBOutlet weak var sld_Y: UISlider!
    
    var muary_Color = NSMutableArray()
    
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
        
        for lbl in [self.lbl_Opacity, self.lbl_Blur, self.lbl_X, self.lbl_Y] {
            
            lbl!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
            lbl!.textColor = COLOR_Black
        }
        
        self.sld_Opacity.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        self.sld_Blur.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        self.sld_X.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        self.sld_Y.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        let nib_CellC = UINib(nibName: "cell_c_Color", bundle: nil)
        self.clc_Color.register(nib_CellC, forCellWithReuseIdentifier: "cell_c_Color")
        
        let layout_Cat = self.clc_Color.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: self.clc_Color.frame.height, height: self.clc_Color.frame.height)
        self.clc_Color.collectionViewLayout = layout_Cat
        
        self.muary_Color = NSMutableArray(array: ARRAY_Color)
        self.clc_Color.reloadData()
    }
    
    @IBAction func action_ChangeOpacity(_ slider: UISlider) {
     
        self.delegate?.shadow?(view: self, Change: CGFloat(slider.value), With: .opacity)
    }
    
    @IBAction func action_ChangeBlur(_ slider: UISlider) {
        
        self.delegate?.shadow?(view: self, Change: CGFloat(slider.value), With: .blur)
    }
    
    @IBAction func action_ChangeX(_ slider: UISlider) {
        
        self.delegate?.shadow?(view: self, Change: CGFloat(slider.value), With: .x)
    }
    
    @IBAction func action_ChangeY(_ slider: UISlider) {
        
        self.delegate?.shadow?(view: self, Change: CGFloat(slider.value), With: .y)
    }
}

extension ShadowVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Color = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Color", for: indexPath) as! cell_c_Color
        
        cell.vw_Color.backgroundColor = (self.muary_Color[indexPath.row] as! UIColor)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.shadow?(view: self, Change: self.muary_Color[indexPath.row], With: .color)
    }
}

