//
//  HistoryVW.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol HistoryVWDelegate: class {
    
    @objc optional func history(view: HistoryVW, didSelected style: infoStyle)
}

class HistoryVW: UIView {
    
    weak var delegate : HistoryVWDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var clc_Style: UICollectionView!
    
    var muary_History : [infoStyle] = []    
    
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
        
        let nib_Cell = UINib(nibName: "cel_c_Effect", bundle: nil)
        self.clc_Style.register(nib_Cell, forCellWithReuseIdentifier: "cel_c_Effect")
        
        let hgt_Effect : CGFloat = 100
        
        let layout = self.clc_Style.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: hgt_Effect, height: hgt_Effect)
        self.clc_Style.collectionViewLayout = layout
        
        self.clc_Style.reloadData()
    }
    
    func addToHistoty(style: infoStyle) {
        
        self.muary_History.append(infoStyle.copy(style: style))
        
        if self.muary_History.count > 15 {
            
            self.muary_History.remove(at: 0)
        }
        
        self.clc_Style.reloadData()
    }
}

extension HistoryVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_History.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cel_c_Effect", for: indexPath) as! cel_c_Effect
        
        cell.updateLayer(layer: self.muary_History[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.history?(view: self, didSelected: self.muary_History[indexPath.row])
    }
}

