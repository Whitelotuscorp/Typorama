//
//  ShapeVW.swift
//  Typorama
//
//  Created by Apple on 31/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
@objc protocol ShapeVWDelegate: class {
    
    @objc optional func shape(view: ShapeVW, DidSelect shape: UIImage)
    @objc optional func shape(view: ShapeVW, DidChange opacity: Float)
}
    
class ShapeVW: UIView {

    weak var delegate : ShapeVWDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Opacity: UIView!
    
    @IBOutlet weak var clc_Shape: UICollectionView!
    
    @IBOutlet weak var lbl_Opacity: UILabel!
    
    @IBOutlet weak var sld_Opacity: UISlider!
    
    var muary_Shape = NSMutableArray()
    
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
        
        self.contentView.backgroundColor = COLOR_GrayL240
        
        self.vw_Opacity.backgroundColor = COLOR_White
        
        self.sld_Opacity.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        self.lbl_Opacity.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Opacity.textColor = COLOR_Black
        
        
        self.muary_Shape = NSMutableArray(array: ARRAY_ShapeMenu)
        
        let nib_CellShape = UINib(nibName: "cell_c_Shape", bundle: nil)
        self.clc_Shape.register(nib_CellShape, forCellWithReuseIdentifier: "cell_c_Shape")
        
        let layout_Shape = self.clc_Shape.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Shape.itemSize = CGSize(width: 100, height: 100)
        self.clc_Shape.collectionViewLayout = layout_Shape
    }
    
    @IBAction func action_ChangeSliderValue(_ slider: UISlider) {
        
        self.delegate?.shape?(view: self, DidChange: slider.value)
    }
}

extension ShapeVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Shape.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Shape = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Shape", for: indexPath) as! cell_c_Shape
        
        cell.imgvw_Shape.image = UIImage(named: self.muary_Shape.object(at: indexPath.row) as! String)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let img_Shape = UIImage(named: self.muary_Shape.object(at: indexPath.row) as! String)
        self.delegate?.shape?(view: self, DidSelect: img_Shape!)
    }
}
