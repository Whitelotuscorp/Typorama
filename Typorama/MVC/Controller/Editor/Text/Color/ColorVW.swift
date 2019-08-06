//
//  ColorVW.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol ColorVWDelegate: class {
    
    @objc optional func color(view: ColorVW, didSelected color: UIColor)
}

class ColorVW: UIView {
    
    weak var delegate : ColorVWDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var clc_Color: UICollectionView!
    
    @IBOutlet weak var lbl_Opacity: UILabel!
    
    @IBOutlet weak var sld_Opacity: UISlider!
    
    var muary_Color = NSMutableArray()
    
    var color : UIColor = .white
    
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
        
        self.lbl_Opacity.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Opacity.textColor = COLOR_Black
        
        self.sld_Opacity.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        let nib_CellC = UINib(nibName: "cell_c_Color", bundle: nil)
        self.clc_Color.register(nib_CellC, forCellWithReuseIdentifier: "cell_c_Color")
        
        let layout_Cat = self.clc_Color.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: self.clc_Color.frame.height, height: self.clc_Color.frame.height)
        self.clc_Color.collectionViewLayout = layout_Cat
        
        self.muary_Color = NSMutableArray(array: ARRAY_Color)
        self.color = self.muary_Color[0] as! UIColor
        self.clc_Color.reloadData()
    }
    
    @IBAction func action_ChangeColorAlpha(_ sender: Any) {
        
        self.callDalegateMehod()
    }
    
    func callDalegateMehod() {
        
        let new_Color = self.color.withAlphaComponent(CGFloat(self.sld_Opacity!.value))
        self.delegate?.color?(view: self, didSelected: new_Color)
    }
}

extension ColorVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Color = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Color", for: indexPath) as! cell_c_Color
        
        cell.vw_Color.backgroundColor = (self.muary_Color[indexPath.row] as! UIColor)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.color = self.muary_Color[indexPath.row] as! UIColor
        self.sld_Opacity.value = 1.0
        self.callDalegateMehod()
    }
}

