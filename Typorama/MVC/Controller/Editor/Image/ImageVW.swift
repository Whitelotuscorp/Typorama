//
//  Image_VW.swift
//  Typorama
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ImageVW: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Menu: UIView!
    
    @IBOutlet weak var clc_Menu: UICollectionView!
    @IBOutlet weak var clc_Content: UICollectionView!
    
    @IBOutlet weak var lbl_Intensity: UILabel!
    
    @IBOutlet weak var sld_Value: UISlider!
    
    @IBOutlet weak var lyl_h_Slider: NSLayoutConstraint!
    
    var muary_Menu = NSMutableArray()
    var muary_Content = NSMutableArray()
    
    var index_Selected : Int = 0
    
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
        
        self.vw_Menu.backgroundColor = COLOR_White
        
        self.sld_Value.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        let nib_CellCrop = UINib(nibName: "cell_c_Menu", bundle: nil)
        self.clc_Menu.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Menu")
        
        let nib_CellView = UINib(nibName: "cell_c_View", bundle: nil)
        let nib_CellImg = UINib(nibName: "cell_c_Image", bundle: nil)
        self.clc_Content.register(nib_CellView, forCellWithReuseIdentifier: "cell_c_View")
        self.clc_Content.register(nib_CellImg, forCellWithReuseIdentifier: "cell_c_Image")
        
        let layout_Cat = self.clc_Menu.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: 90, height: 60)
        self.clc_Menu.collectionViewLayout = layout_Cat
        
        self.muary_Menu = NSMutableArray(array: ARRAY_ImageMenu)
        self.clc_Menu.reloadData()
        
        self.perform(#selector(self.loadDelayUI), with: nil, afterDelay: 0.3)
    }
    
    @objc func loadDelayUI() {
        
        self.action_SelectOption(index: 0)
    }
    
    @objc func action_SelectOption(index: Int) {
        
        let layout_Cat = self.clc_Content.collectionViewLayout as! UICollectionViewFlowLayout
        
        if index == 0 {
            
            self.muary_Content = NSMutableArray(array: ARRAY_ImageMenu1)
            self.lyl_h_Slider.constant = 0
            layout_Cat.itemSize = CGSize(width: (self.clc_Content.frame.width - 5) / 3, height: 100)
        }
        else if index == 3 {
            
            self.muary_Content = NSMutableArray(array: ARRAY_ImageMenu4)
            self.lyl_h_Slider.constant = 60
            layout_Cat.itemSize = CGSize(width: 115, height: 45)
        }
        else {
            
            self.muary_Content = NSMutableArray(array: ARRAY_ImageMenu2)
            self.muary_Content.addObjects(from: ARRAY_ImageMenu2)
            self.muary_Content.addObjects(from: ARRAY_ImageMenu2)
            self.muary_Content.addObjects(from: ARRAY_ImageMenu2)
            self.muary_Content.addObjects(from: ARRAY_ImageMenu2)
            
            layout_Cat.itemSize = CGSize(width: 60, height: 60)
            self.lyl_h_Slider.constant = 50
        }
                
        self.clc_Content.collectionViewLayout = layout_Cat
        self.clc_Content.reloadData()
        
        self.updateConstraintsIfNeeded()
    }
}

extension ImageVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.clc_Menu {
            
            return self.muary_Menu.count
        }
        else {
            
            return self.muary_Content.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.clc_Menu {
         
            let cell : cell_c_Menu = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Menu", for: indexPath) as! cell_c_Menu
            
            let dict : [String:String] = self.muary_Menu.object(at: indexPath.row) as! [String : String]
            cell.lbl_Menu.text = dict["name"]
            cell.imgvw_Icon.image = UIImage(named: dict["icon"]!)
            
            return cell
        }
        else {
            
            if self.index_Selected == 0 || self.index_Selected == 3 {
                
                let cell : cell_c_View = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_View", for: indexPath) as! cell_c_View
                
                cell.lbl_Name.text = self.muary_Content.object(at: indexPath.row) as! String
                
                return cell
            }
            else {
                
                let cell : cell_c_Image = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Image", for: indexPath) as! cell_c_Image
                
                cell.imgvw_Pic.image = UIImage(named: self.muary_Content.object(at: indexPath.row) as! String)
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.clc_Menu {
            
            self.index_Selected = indexPath.row
            self.action_SelectOption(index: self.index_Selected)
        }
        else {
            
        }
    }
}
