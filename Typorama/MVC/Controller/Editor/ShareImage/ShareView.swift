
//
//  ShareView.swift
//  Typorama
//
//  Created by Apple on 10/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol ShareViewDelegate: class {
    
    func shareView(view: ShareView, DidSelectAt type: ShareType)
}

class ShareView: UIView {
    
    weak var delegate : ShareViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Social: UIView!
    
    @IBOutlet weak var clc_Social: UICollectionView!
    
    @IBOutlet weak var btn_Done: UIButton!
    
    @IBOutlet weak var lyl_t_Main: NSLayoutConstraint!
    @IBOutlet weak var lyl_h_Social: NSLayoutConstraint!
    
    var muary_Social = NSMutableArray()
    
    var cell_Size : CGFloat = 80
    
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
        self.contentView.backgroundColor = .clear
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.contentView)
        
        self.vw_Social.backgroundColor = COLOR_Cream
        
        let nib_CellCrop = UINib(nibName: "cell_c_Share", bundle: nil)
        self.clc_Social.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Share")
        
//        self.cell_Size = (self.frame.width - 10) / 5.0
        
        let layout_Cat = self.clc_Social.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: self.cell_Size, height: self.cell_Size)
        self.clc_Social.collectionViewLayout = layout_Cat
        
        self.btn_Done.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        
        self.muary_Social = NSMutableArray(array: ARRAY_Share)
        self.clc_Social.reloadData()
        
        let h_Top : CGFloat = (AppDelegateObj.window?.safeAreaInsets.top)!
        self.lyl_t_Main.constant = h_Top
        self.updateConstraintsIfNeeded()
        self.layoutIfNeeded()
    }
    
    @IBAction func action_Done(_ sender: UIButton) {
    
        self.hide()
    }
    
    func show() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.lyl_h_Social.constant = self.cell_Size
            self.layoutIfNeeded()
        }, completion: {(finished: Bool) -> Void in
          
        })
    }
    func hide() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.lyl_h_Social.constant = 0
            self.layoutIfNeeded()
        }, completion: {(finished: Bool) -> Void in
            
            self.removeFromSuperview()
        })
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
    
        let dict : [String:String] = self.muary_Social.object(at: indexPath.row) as! [String : String]
        self.delegate?.shareView(view: self, DidSelectAt: ShareType(rawValue: dict["name"]!)!)
        self.hide()
    }
}
