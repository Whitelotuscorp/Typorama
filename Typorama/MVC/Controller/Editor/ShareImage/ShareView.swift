
//
//  ShareView.swift
//  Typorama
//
//  Created by Apple on 10/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ShareView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Social: UIView!
    
    @IBOutlet weak var clc_Social: UICollectionView!
    
    @IBOutlet weak var btn_Close: UIButton!
    
    var muary_Social = NSMutableArray()
    
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
        
        let nib_CellCrop = UINib(nibName: "cell_c_Share", bundle: nil)
        self.clc_Social.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Share")
        
        let layout_Cat = self.clc_Social.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: 70, height: 70)
        self.clc_Social.collectionViewLayout = layout_Cat
        
        self.muary_Social = NSMutableArray(array: ARRAY_Share)
        self.clc_Social.reloadData()
    }
    
    func show() {
        
    }
    func hide() {
        
    }
}

extension ShareView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Social.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Share = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Share", for: indexPath) as! cell_c_Share
        
        let dict : [String:String] = self.muary_Social.object(at: indexPath.row) as! [String : String]
        cell.lbl_Name.text = dict["name"]
        cell.imgvw_Icon.image = UIImage(named: dict["icon"]!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}
