//
//  WaterMark_VW.swift
//  Typorama
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol WaterMarkVWDelegate: class {
    
    @objc optional func addNewLogo(view: WaterMarkVW)
    @objc optional func removeLogo(view: WaterMarkVW)
    @objc optional func logo(view: WaterMarkVW, Change logo: UIImage, With id: String)
    @objc optional func logo(view: WaterMarkVW, DidChange opacity: Float)
}
    
class WaterMarkVW: UIView {
    
    weak var delegate : WaterMarkVWDelegate?
    
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
    var direction : CGFloat = 1
    
    var deleteBtnFlag : Bool = false
    var vibrateAniFlag : Bool = false
    
    var info_SL = infoLogoList()
    
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
        
        self.lbl_Intensity.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Intensity.textColor = COLOR_Black
        
        let nib_CellCrop = UINib(nibName: "cell_c_Menu", bundle: nil)
        self.clc_Menu.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Menu")
        
        let nib_CellView = UINib(nibName: "cell_c_View", bundle: nil)
        let nib_CellImg = UINib(nibName: "cell_c_Color", bundle: nil)
        let nib_CellLogo = UINib(nibName: "cell_c_Logo", bundle: nil)
        self.clc_Content.register(nib_CellView, forCellWithReuseIdentifier: "cell_c_View")
        self.clc_Content.register(nib_CellImg, forCellWithReuseIdentifier: "cell_c_Color")
        self.clc_Content.register(nib_CellLogo, forCellWithReuseIdentifier: "cell_c_Logo")
        
        let layout_Cat = self.clc_Menu.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: 90, height: 60)
        self.clc_Menu.collectionViewLayout = layout_Cat
        
        let ARRAY_LogoMenu     = [["name":"My Logo", "icon":"icon_history"],
        ["name":"Opacity", "icon":"icon_gradient"]]
//        ["name":"Color", "icon":"icon_color"],
//        ["name":"Font", "icon":"icon_style"]]
        self.setFlagAndGsr()
        self.muary_Menu = NSMutableArray(array: ARRAY_LogoMenu)
        self.clc_Menu.reloadData()
        
        self.perform(#selector(self.loadDelayUI), with: nil, afterDelay: 0.3)
    }
    
    @objc func loadDelayUI() {
        
        self.action_SelectOption(index: 0)
    }
    
    @objc func loadLogoList() {
        
        self.muary_Content = NSMutableArray()
        self.clc_Content.reloadData()
        self.muary_Content = NSMutableArray(array: [infoLogoList(text: "ADD\nNEW LOGO"), infoLogoList(text: "NO\nLOGO")])
        self.muary_Content.addObjects(from: DataManager.initDB().RETRIEVE_LogoList(query: "Select * from tbl_LogoList") as! [Any])
        self.clc_Content.reloadData()
    }
    
    func addNewLogo(image: UIImage) {
        
        let query_InsertLogo = String(format: "Insert into tbl_LogoList (l_type, l_text, l_image) values ('1', '', '')")
        DataManager.initDB().EXECUTE_Query(query: query_InsertLogo)
        
        let str_Logdid = DataManager.initDB().RETRIEVE_LastId(query: "Select Max(l_id) as id from tbl_LogoList")
        let fileName = String(format: "Logo_%@.png", str_Logdid)
        let filePath = AppSingletonObj.getPath(filename: fileName, With: AppFolder_Logo)
        
        let data = image.pngData()
        AppSingletonObj.writeFile(filePath: filePath, data: data as NSData?)
        
        let query_UpdateLogo = String(format: "Update tbl_LogoList set l_image = '%@' Where l_id = '%@'", fileName, str_Logdid)
        DataManager.initDB().EXECUTE_Query(query: query_UpdateLogo)
        
        self.loadLogoList()
    }
    
    func checkLogoSelection(info: infoLogoList) {
                
        self.info_SL = info
        self.sld_Value.value = info.l_opacity
        
        let isExit = DataManager.initDB().CHECKDATA_ExistOrNot(query: "Select * from tbl_Logo")
        if isExit == false && info.l_type == LogoType.Photo {
            
            let query_InsertLogo = String(format: "Insert into tbl_Logo (l_id) values ('%@')", info.l_id)
            DataManager.initDB().EXECUTE_Query(query: query_InsertLogo)
        }
        else  {
            
            let query_UpdateLogo = String(format: "Update tbl_Logo set l_id = '%@'", info.l_id)
            DataManager.initDB().EXECUTE_Query(query: query_UpdateLogo)
        }
        
        self.callDelegateMethod()
        self.clc_Content.reloadData()
    }
    
    func callDelegateMethod() {
        
        let str_FilePath = AppSingletonObj.getPath(filename: self.info_SL.l_image, With: AppFolder_Logo)
        let img_Logo = UIImage(contentsOfFile: str_FilePath)
        self.delegate?.logo?(view: self, Change: img_Logo!, With: self.info_SL.l_id)
        self.delegate?.logo?(view: self, DidChange: self.info_SL.l_opacity)
    }
    
    @objc func deleteLogo(indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Delete!", message: "Are you sure want to delete this logo?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            self.hideAllDeleteBtn()
            let info_Logo = self.muary_Content.object(at: indexPath.row) as! infoLogoList
            let query_DeleteLogo = String (format: "Delete from tbl_LogoList Where l_id = '%@'", info_Logo.l_id)
            DataManager.initDB().EXECUTE_Query(query: query_DeleteLogo)
            self.loadLogoList()
        }))
            
        AppSingletonObj.getVisibleVC().present(alert, animated: true, completion: nil)
    }
    
    @objc func action_SelectOption(index: Int) {
        
        let layout_Cat = self.clc_Content.collectionViewLayout as! UICollectionViewFlowLayout
        
        if index == 0 {
            
            self.loadLogoList()
            self.lyl_h_Slider.constant = 0
            layout_Cat.itemSize = CGSize(width: 100, height: 100)
        }
        else if index == 1 {
            
            self.lbl_Intensity.text = "OPACITY"
            self.muary_Content = NSMutableArray(array: ARRAY_Color)
            self.lyl_h_Slider.constant = 115
            layout_Cat.itemSize = CGSize(width: 45, height: 45)
        }
        else {
            
            self.lbl_Intensity.text = "SHADOW"
            self.muary_Content = NSMutableArray(array: ARRAY_Font)
            layout_Cat.itemSize = CGSize(width: 115, height: 45)
            self.lyl_h_Slider.constant = 60
        }
                
        self.clc_Content.collectionViewLayout = layout_Cat
        self.clc_Content.reloadData()
        
        self.updateConstraintsIfNeeded()
    }
    
    @IBAction func action_ChangeSliderValie(slider: UISlider) {
        
        self.info_SL.l_opacity = slider.value
        let query_UpdateLogo = String(format: "Update tbl_LogoList set l_opacity = '%f' Where l_id = '%@'", slider.value, self.info_SL.l_id)
        DataManager.initDB().EXECUTE_Query(query: query_UpdateLogo)
        self.delegate?.logo?(view: self, DidChange: slider.value)
    }
}

extension WaterMarkVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            
            if self.index_Selected == 0 {
                
                let cell : cell_c_Logo = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Logo", for: indexPath) as! cell_c_Logo
                
                let info_Logo = self.muary_Content.object(at: indexPath.row) as! infoLogoList
                
                cell.lbl_Logo.text = info_Logo.l_text
                
                if info_Logo.l_type == LogoType.Photo {
                    
                    let str_FilePath = AppSingletonObj.getPath(filename: info_Logo.l_image, With: AppFolder_Logo)
                    cell.imgvw_Logo.image = UIImage(contentsOfFile: str_FilePath)
                }
                else {
                    
                    cell.imgvw_Logo.image = nil
                }
                
                self.setCellVibrate(cell, indexPath: indexPath)
                
                if self.info_SL.l_id != "" && self.info_SL.l_id == info_Logo.l_id {
                    
                    cell.vw_BG.layer.borderColor = UIColor.black.cgColor
                }
                else {
                    
                    cell.vw_BG.layer.borderColor = UIColor.gray.cgColor
                }
                
                cell.lbl_Delete.isHidden = cell.btn_Delete.isHidden
                return cell
            }
            else if self.index_Selected == 1 {
                
                let cell : cell_c_Color = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Color", for: indexPath) as! cell_c_Color
                
                cell.vw_Color.backgroundColor = (self.muary_Content[indexPath.row] as! UIColor)
                
                return cell
            }
            else {
                
                let cell : cell_c_View = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_View", for: indexPath) as! cell_c_View
                
                cell.lbl_Name.text = (self.muary_Content.object(at: indexPath.row) as! String)
                
                cell.lbl_Name.numberOfLines = 1
                cell.lbl_Name.font = UIFont(name: (self.muary_Content.object(at: indexPath.row) as! String), size: APPFONT_Size15)
                
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.clc_Menu {
            
            self.index_Selected = indexPath.row
            self.action_SelectOption(index: self.index_Selected)
        }
        else if indexPath.row == 0 && self.index_Selected == 0 {
            
            self.hideAllDeleteBtn()
            self.delegate?.addNewLogo?(view: self)
        }
        else if indexPath.row == 1 && self.index_Selected == 0  {
            
            self.hideAllDeleteBtn()
            self.info_SL = infoLogoList()
            self.delegate?.removeLogo?(view: self)
        }
        else if self.index_Selected == 0 {
            
            self.hideAllDeleteBtn()
            self.loadLogoList()
            let info_Logo = self.muary_Content.object(at: indexPath.row) as! infoLogoList
            
            if self.info_SL.l_id == "" || self.info_SL.l_id != info_Logo.l_id {
                
                self.checkLogoSelection(info: info_Logo)
            }
        }
    }
}

extension WaterMarkVW: CellLogDelegate {

    func delete(cell: cell_c_Logo, AtIndexpath indexPath: IndexPath) {
        
        self.clc_Content.performBatchUpdates({
            
            self.deleteLogo(indexPath: indexPath)
        }) { finished in
            self.clc_Content.reloadData()
        }
    }

    //the following methods you just need copy ~ paste
    func setFlagAndGsr() {
        
        deleteBtnFlag = true
        vibrateAniFlag = true
    }

    func setCellVibrate(_ cell: cell_c_Logo?, indexPath: IndexPath?) {
        
        cell?.indexPath = indexPath
        cell?.btn_Delete.isHidden = deleteBtnFlag ? true : false

        if indexPath!.row < 2 {

            cell?.btn_Delete.isHidden = true
        }
        else {
            
            if !vibrateAniFlag {
                YTAnimation.vibrateAnimation(cell)
            } else {
                cell?.layer.removeAnimation(forKey: "shake")
            }
            cell?.delegate = self
        }
    }
    
    func hideAllDeleteBtn() {
        
        if !deleteBtnFlag {
            deleteBtnFlag = true
            vibrateAniFlag = true
            self.clc_Content.reloadData()
        }
    }

    func showAllDeleteBtn() {
        
        deleteBtnFlag = false
        vibrateAniFlag = false
        self.clc_Content.reloadData()
    }
}

