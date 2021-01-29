//
//  BackGround_VC.swift
//  Typorama
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Photos
import IGRPhotoTweaks

@objc protocol BackGroundVCDelegate: class {
    
    @objc optional func backGround(vc: BackGround_VC, ChangeColor color: UIColor)
}
 
class BackGround_VC: UIViewController {

    weak var delegate : BackGroundVCDelegate?
    
    @IBOutlet weak var vw_Nav: UIView!
    
    @IBOutlet weak var clc_Canvas: UICollectionView!
    @IBOutlet weak var clc_Category: UICollectionView!
    
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var btn_Close: UIButton!
    
    var muary_Cat = NSMutableArray()
    var muary_Canvas = NSMutableArray()
    
    var allPhotos : [infoPhoto] = []
    
    var selected_Cat : String = ""
    
    let w_CellCat : CGFloat = 120
    
    var color_Selected : UIColor = UIColor.clear
    
    var isAutoScroll : Bool = false
    var isFromEditor : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = COLOR_Cream
        
        self.btn_Close.titleLabel?.font = UIFont.fontAwesome(ofSize: APPFONT_Size17, style: .solid)
        self.btn_Close.setTitle(String.fontAwesomeIcon(name: FontAwesome.longArrowAltLeft), for: .normal)
        
        let nib_CellCat = UINib(nibName: "cell_c_BGCat", bundle: nil)
        self.clc_Category.register(nib_CellCat, forCellWithReuseIdentifier: "cell_c_BGCat")
        
        let nib_CellCan = UINib(nibName: "cell_c_BGCanvas", bundle: nil)
        self.clc_Canvas.register(nib_CellCan, forCellWithReuseIdentifier: "cell_c_BGCanvas")
        
        
        let leftInset = (self.view.frame.width - w_CellCat) / 2
        let rightInset = leftInset
        
        let layout_Cat = self.clc_Category.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: w_CellCat, height: 40.0)
        layout_Cat.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        self.clc_Category.collectionViewLayout = layout_Cat
        
        self.updateLayoutCategory()
        var w_Canvas = self.view.frame.width / 3.0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            w_Canvas = (self.view.frame.width - 5) / 5.0
        }
        
        let layout_Canvas = self.clc_Canvas.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Canvas.itemSize = CGSize(width: w_Canvas, height: w_Canvas)
        self.clc_Canvas.collectionViewLayout = layout_Canvas
                        
        
        if self.isFromEditor == true {
            
            self.muary_Cat = NSMutableArray(array: [kBGIMAGE_COLORS])
            self.vw_Nav.isHidden = false
        }
        else {
            
            self.muary_Cat = NSMutableArray(array: ARRAY_Category)
            self.vw_Nav.isHidden = true
        }
        
        self.loadCatWiseData(indexPath: IndexPath(row: 0, section: 0))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clc_Category.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.clc_Category.reloadData()
        
        print(lbl.font.familyName)
        print(lbl.font.fontName)
    }
    
    func updateLayoutCategory(isInset: Bool = false) {
        
        let leftInset = isInset == true ? 0 : (self.view.frame.width - w_CellCat) / 2
        let rightInset = leftInset
        
        let layout_Cat = self.clc_Category.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: w_CellCat, height: 40.0)
        layout_Cat.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        self.clc_Category.collectionViewLayout = layout_Cat
    }
    
    @IBAction func action_Close(_ sender: UIButton) {
     
        self.dismiss(animated: true, completion: nil)
    }
}

extension BackGround_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.clc_Category {
            
            return self.muary_Cat.count
        }
        else if self.selected_Cat == kBGIMAGE_PHOTOS {
            
            return self.allPhotos.count
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
            if selected_Cat == cell.lbl_Name.text {
                
                cell.lbl_Line.isHidden = false
            }
            
            return cell
        }
        else {
            
            let cell : cell_c_BGCanvas = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_BGCanvas", for: indexPath) as! cell_c_BGCanvas
            
            cell.lbl_Text.isHidden = indexPath.row == 0 ? false : true
            
            if self.selected_Cat == kBGIMAGE_PHOTOS {
                
                cell.imgvw_Trans.isHidden = false
                cell.imgvw_Trans.contentMode = .scaleAspectFill
                cell.vw_BG.backgroundColor = .white
                
                if cell.lbl_Text.isHidden == false {
                    
                    cell.lyl_x_Text.constant = 0
                    cell.lyl_y_Text.constant = 25
                    
                    cell.lbl_Text.textColor = .lightText
                    cell.lbl_Text.text = "BROWSE\nALBUMS"
                }
                
                let info_Pic = self.allPhotos[indexPath.row]
                
                if info_Pic.image.size.width > 0 && info_Pic.image.size.height > 0  {
                    
                    cell.imgvw_Trans.image = info_Pic.image
                }
                else {
                
                    let managerCell = PHCachingImageManager()
                    managerCell.requestImage(for: info_Pic.asset!, targetSize: CGSize(width: cell.imgvw_Trans.frame.width * 3, height: cell.imgvw_Trans.frame.height * 3), contentMode: .default, options: PhotosAlbum.shared().requestOptions, resultHandler: { image, info in
                        
                        cell.imgvw_Trans.image = image
                        info_Pic.image = image!
                    })
                }
            }
            else {
                
                cell.vw_BG.backgroundColor = (self.muary_Canvas.object(at: indexPath.row) as! UIColor)
                cell.imgvw_Trans.isHidden = indexPath.row == 0 ? false : true
                cell.imgvw_Trans.image = UIImage.init(named: "canvas_s")
//                cell.imgvw_Trans.contentMode = .center
                
                if cell.lbl_Text.isHidden == false {
                    
                    cell.lyl_x_Text.constant = 0
                    cell.lyl_y_Text.constant = 0
                    
                    cell.lbl_Text.textColor = .red
                    cell.lbl_Text.text = "TRANSPARENT"
                }
            }
            
            cell.updateConstraintsIfNeeded()
            cell.contentView.updateConstraintsIfNeeded()
            
            return cell
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if self.isAutoScroll == false && (scrollView as? UICollectionView) == self.clc_Category {
            
            self.updateLayoutCategory(isInset: true)
        }
        self.isAutoScroll = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if self.isAutoScroll == false && (scrollView as? UICollectionView) == self.clc_Category {
            
            self.updateLayoutCategory(isInset: true)
        }
        self.isAutoScroll = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        self.color_Selected = .clear
        if collectionView == self.clc_Category {
            
            self.updateLayoutCategory()
            self.isAutoScroll = true
            self.loadCatWiseData(indexPath: indexPath)
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        else {
            
            let obj_Crop_VC = self.storyboard?.instantiateViewController(withIdentifier: "Crop_VC") as! Crop_VC
            obj_Crop_VC.imageBG = AppSingletonObj.takeScreenShotMethod(view: self.view)
            obj_Crop_VC.delegate = self
            obj_Crop_VC.modalPresentationStyle = .fullScreen
            
            if self.selected_Cat == kBGIMAGE_PHOTOS && indexPath.row == 0 {
                
                AppSingletonObj.action_ChoosePhoto(type: .photoLibrary, With: self)
            }
            else if self.selected_Cat == kBGIMAGE_PHOTOS {
                
                AppSingletonObj.manageMBProgress(isShow: true)
                let info_Pic = self.allPhotos[indexPath.row]
                
                PhotosAlbum.shared().fetchImage(asset: info_Pic.asset!, targetSize: PHImageManagerMaximumSize) { (image) in
                 
                    if image != nil {
                        
                        obj_Crop_VC.image = image
                        self.present(obj_Crop_VC, animated: false, completion: nil)
                    }
                    
                    AppSingletonObj.manageMBProgress(isShow: false)
                }
            }
            else {
                
                self.color_Selected = self.muary_Canvas.object(at: indexPath.row) as! UIColor
                
                if self.isFromEditor == true {
                    
                    self.dismiss(animated: true) {
                        
                        self.delegate?.backGround?(vc: self, ChangeColor: self.color_Selected)
                    }
                }
                else {
                 
                    let w_Screen = UIScreen.main.bounds.width
                    let h_Screen = UIScreen.main.bounds.height
                    let h_Bottom : CGFloat = (AppDelegateObj.window?.safeAreaInsets.bottom)!
                    let h_StatusBar = UIApplication.shared.statusBarFrame.height + 35 + 162 + 40 + h_Bottom
                    let multy : CGFloat = 8
                    
                    obj_Crop_VC.image = AppSingletonObj.createImage(color: self.color_Selected, size: CGSize(width: w_Screen * multy, height: (h_Screen - h_StatusBar) * multy))
                    self.present(obj_Crop_VC, animated: false, completion: nil)
                }
            }
        }
    }
    
    func loadCatWiseData(indexPath: IndexPath) {
        
        self.selected_Cat = (self.muary_Cat.object(at: indexPath.row) as! String)
        
        if self.selected_Cat == kBGIMAGE_PHOTOS {
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                AppSingletonObj.manageMBProgress(isShow: true)
            })
            
            self.getMyPhoto()
        }
        else {
            
            self.muary_Canvas = NSMutableArray(array: ARRAY_Color)
            self.muary_Canvas.insert(UIColor.clear, at: 0)
        }
        
        self.clc_Canvas.reloadData()
    }
    
    func getMyPhoto() {
        
        var isFirst : Bool = true
        if self.allPhotos.count > 0 {
            
            isFirst = false
            DispatchQueue.main.async(execute: { () -> Void in
                
                AppSingletonObj.manageMBProgress(isShow: false)
                self.clc_Canvas.reloadData()
            })
        }
                
        let ary_Photoset = self.allPhotos.map { $0.asset?.localIdentifier}
        PhotosAlbum.shared().getAllImagesFromPhotos { (success, results) in
            
            if (results != nil) {
                
                if isFirst == true {
                    
                    let infoP = infoPhoto(asset: PHAsset())
                    infoP.image = UIImage(named: "album")!
                    self.allPhotos.append(infoP)
                }
                
                for i in 0 ..< results!.count {
                    
                    let asset : PHAsset = (results?.object(at: i))!
                    
                    if isFirst == true {
                        
                        self.allPhotos.append(infoPhoto(asset: asset))
                    }
                    else if !ary_Photoset.contains(asset.localIdentifier) {
                    
                        self.allPhotos.insert(infoPhoto(asset: asset), at: 1)
                    }
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    AppSingletonObj.manageMBProgress(isShow: false)
                    self.clc_Canvas.reloadData()
                })
            }
        }
    }
}

extension BackGround_VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        
        picker.dismiss(animated: true) {
         
            let obj_Crop_VC = self.storyboard?.instantiateViewController(withIdentifier: "Crop_VC") as! Crop_VC
            obj_Crop_VC.imageBG = AppSingletonObj.takeScreenShotMethod(view: self.view)
            obj_Crop_VC.delegate = self
            obj_Crop_VC.image = (image as! UIImage)
            obj_Crop_VC.modalPresentationStyle = .fullScreen
            self.present(obj_Crop_VC, animated: false, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension BackGround_VC: CropViewDelegate {
    
    func crop(view: CropView, didCrop size: String, With image: UIImage, type: ImageType) {
        
        let obj_Editor_VC = self.storyboard?.instantiateViewController(withIdentifier: "Editor_VC") as! Editor_VC
        obj_Editor_VC.info_Image = infoImage(size: size, color: view.color, image: image, type: type)
        self.navigationController?.pushViewController(obj_Editor_VC, animated: true)
    }
    
    func crop(view: CropView, didCancel size: String) {
        
    }
}

extension BackGround_VC: IGRPhotoTweakViewControllerDelegate {
    
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {

        let obj_Editor_VC = self.storyboard?.instantiateViewController(withIdentifier: "Editor_VC") as! Editor_VC
        obj_Editor_VC.info_Image = infoImage(size: controller.sizeFrame, color: self.color_Selected, image: croppedImage, type: ImageType.IMAGE)

        controller.dismiss(animated: true) {
         
            self.navigationController?.pushViewController(obj_Editor_VC, animated: true)
        }
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
