//
//  ExampleCropViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/7/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import IGRPhotoTweaks

import UIKit

class Crop_VC: IGRPhotoTweakViewController {
    
    @IBOutlet weak var vw_Status: UIView!
    @IBOutlet weak var vw_Top: UIView!
    @IBOutlet weak var vw_Bottom: UIView!
    
    @IBOutlet weak var clc_Size: UICollectionView!
    
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Next: UIButton!
    
    @IBOutlet weak var lbl_Creation: UILabel!
    
    // MARK: - Life Cicle
//    var img_BG: UIImage!
    
    var index_Selected : IndexPath = IndexPath(item: 0, section: 0)
    
    var muary_Size = NSMutableArray()
    
    var str_CustomSize : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vw_Status.backgroundColor = COLOR_Cream
        
        let nib_CellCrop = UINib(nibName: "cell_c_Crop", bundle: nil)
        self.clc_Size.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Crop")
        
        let layout_Cat = self.clc_Size.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: self.clc_Size.frame.height - 60, height: self.clc_Size.frame.height)
        self.clc_Size.collectionViewLayout = layout_Cat
        
        self.muary_Size = NSMutableArray(array: ARRAY_CanvasSize)
        self.clc_Size.reloadData()
        
        self.btn_Next.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.btn_Next.setTitleColor(COLOR_White, for: .normal)
        
        self.btn_Cancel.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.btn_Cancel.setTitleColor(COLOR_White, for: .normal)
        
        self.lbl_Creation.text = "How do you want to use your creation?"
        self.lbl_Creation.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Creation.textColor = COLOR_White
        
        //FIXME: Zoom setup
        //self.photoView.minimumZoomScale = 1.0;
        //self.photoView.maximumZoomScale = 10.0;
        
        
        IGRCropMaskView.appearance().backgroundColor = UIColor.clear
        IGRPhotoTweakView.appearance().backgroundColor = UIColor.clear
        IGRCropCornerLine.appearance().backgroundColor = UIColor.black
        
        self.view.bringSubviewToFront(self.vw_Top)
        self.view.bringSubviewToFront(self.vw_Bottom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.photoView.cropView.isResizeDisable = true
        self.photoView.cropView.cornerView(isHide: true)
    }
    //FIXME: Themes Preview
//    override open func setupThemes() {
//
//        IGRCropLine.appearance().backgroundColor = UIColor.green
//        IGRCropGridLine.appearance().backgroundColor = UIColor.yellow
//        IGRCropCornerView.appearance().backgroundColor = UIColor.purple
//        IGRCropCornerLine.appearance().backgroundColor = UIColor.orange
//        IGRCropMaskView.appearance().backgroundColor = UIColor.blue
//        IGRPhotoContentView.appearance().backgroundColor = UIColor.gray
//        IGRPhotoTweakView.appearance().backgroundColor = UIColor.brown
//    }
    
    
    // MARK: - Rotation
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.view.layoutIfNeeded()
        }) { (context) in
            //
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onTouchCancelButton(_ sender: UIButton) {
        self.dismissAction()
    }
    
    @IBAction func onTouchCropButton(_ sender: UIButton) {
        
        let dict : [String:String] = self.muary_Size.object(at: self.index_Selected.row) as! [String : String]
        self.sizeFrame = dict["size"]!
        cropAction()
    }
    
    override open func customHighlightMaskAlphaValue() -> CGFloat {
        return 0.3
    }
    
    override open func customCanvasInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0,
                            left: 0.0,
                            bottom: 0,
                            right: 0.0)
    }

    override open func customCropTweakViewDidMove(_ cropView: IGRCropView) {
        
        self.str_CustomSize = String(format: "%d\nx\n%d", Int(cropView.frame.width), Int(cropView.frame.height))
        self.clc_Size.reloadData()
    }
}

extension Crop_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Size.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Crop = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Crop", for: indexPath) as! cell_c_Crop
        
        let dict : [String:String] = self.muary_Size.object(at: indexPath.row) as! [String : String]
        let size_S = dict["size"]
        
        cell.lbl_Name.text = dict["name"]
        
        if size_S == CUSTOME_Size && self.sizeFrame == CUSTOME_Size {
            
            cell.lbl_Size.text = self.str_CustomSize
        }
        else {
            
            cell.lbl_Size.text = dict["scale"]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.index_Selected = indexPath
        self.clc_Size.reloadData()
        self.setCropFrame(indexPath: indexPath)
    }
    
    @objc func setCropFrame(indexPath: IndexPath) {
        
        let dict : [String:String] = self.muary_Size.object(at: indexPath.row) as! [String : String]
        let size_S = dict["size"]
        let ary_Size = dict["size"]?.components(separatedBy: "x")
        self.sizeFrame = dict["size"]!
        
        self.photoView.cropView.isResizeDisable = true
        self.photoView.cropView.cornerView(isHide: true)
    
        if size_S == CUSTOME_Size {
            
            self.customCropTweakViewDidMove(self.photoView.cropView)
            self.photoView.cropView.isResizeDisable = false
            self.photoView.cropView.cornerView(isHide: false)
        }
        else if size_S != "" && ary_Size!.count > 1 {
            
            self.str_CustomSize = ""
            let str_Ratio = ary_Size?.joined(separator: ":")
            self.setCropAspectRect(aspect: str_Ratio!)
        }
        else {
            
            self.str_CustomSize = ""
            self.resetAspectRect()
        }
    }
}
