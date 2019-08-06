//
//  BackGround_VC.swift
//  Typorama
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BackGround_VC: UIViewController {

    @IBOutlet weak var clc_Canvas: UICollectionView!
    
    @IBOutlet weak var clc_Category: UICollectionView!
    
    @IBOutlet weak var vw_Crop: CropView!
    
    var muary_Cat = NSMutableArray()
    var muary_Canvas = NSMutableArray()
    
    var selected_IndexPathCat : IndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.muary_Cat = NSMutableArray(array: ARRAY_Category)
        self.muary_Canvas = NSMutableArray(array: ARRAY_Color)
        self.muary_Canvas.insert(UIColor.clear, at: 0)
        
        let nib_CellCat = UINib(nibName: "cell_c_BGCat", bundle: nil)
        self.clc_Category.register(nib_CellCat, forCellWithReuseIdentifier: "cell_c_BGCat")
        
        let nib_CellCan = UINib(nibName: "cell_c_BGCanvas", bundle: nil)
        self.clc_Canvas.register(nib_CellCan, forCellWithReuseIdentifier: "cell_c_BGCanvas")
        
        let w_CellCat : CGFloat = 120
        let leftInset = (self.view.frame.width - w_CellCat) / 2
        let rightInset = leftInset
        
        let layout_Cat = self.clc_Category.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: w_CellCat, height: 40.0)
        layout_Cat.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        self.clc_Category.collectionViewLayout = layout_Cat
        
        let w_Canvas = self.view.frame.width / 3.0
        let layout_Canvas = self.clc_Canvas.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Canvas.itemSize = CGSize(width: w_Canvas, height: w_Canvas)
        self.clc_Canvas.collectionViewLayout = layout_Canvas
        
        self.vw_Crop.isHidden = true
        self.vw_Crop.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clc_Category.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.clc_Category.reloadData()
    }
}

extension BackGround_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.clc_Category {
            
            return self.muary_Cat.count
        }
        else {
            
            return self.muary_Canvas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.clc_Category {
            
            let cell : cell_c_BGCat = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_BGCat", for: indexPath) as! cell_c_BGCat
            cell.lbl_Name.text = (self.muary_Cat.object(at: indexPath.row) as! String)
            
            cell.lbl_Line.isHidden = true
            if selected_IndexPathCat == indexPath {
                
                cell.lbl_Line.isHidden = false
            }
            
            return cell
        }
        else {
            
            let cell : cell_c_BGCanvas = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_BGCanvas", for: indexPath) as! cell_c_BGCanvas
            
            cell.vw_BG.backgroundColor = (self.muary_Canvas.object(at: indexPath.row) as! UIColor)
            cell.imgvw_Trans.isHidden = indexPath.row == 0 ? false : true
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if collectionView == self.clc_Category {
            
            self.selected_IndexPathCat = indexPath
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        else {
            
            self.vw_Crop.showCropView(image: UIImage(), With: self.muary_Canvas.object(at: indexPath.row) as! UIColor)
        }
    }
}

extension BackGround_VC: CropViewDelegate {
    
    func crop(view: CropView, didCrop size: String) {
     
        let obj_Editor_VC = self.storyboard?.instantiateViewController(withIdentifier: "Editor_VC") as! Editor_VC
        obj_Editor_VC.info_Image = infoImage(size: size, color: view.vw_Canvas.backgroundColor!, image: UIImage())
        self.navigationController?.pushViewController(obj_Editor_VC, animated: true)
    }
    
    func crop(view: CropView, didCancel size: String) {
        
    }
}
