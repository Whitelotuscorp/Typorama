//
//  Image_VW.swift
//  Typorama
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GPUImage

@objc
enum ImageAdjustment : Int {
    
    case brightness
    case exposure
    case contrast
    case vibrancy
    case saturation
    case vignette
    case blur
}

@objc protocol ImageVWDelegate: class {
    
    @objc optional func image(view: ImageVW, changeImage type: String)
    @objc optional func image(view: ImageVW, changeColor color: UIColor)
    
    @objc optional func image(view: ImageVW, DidChange image: UIImage)
    @objc optional func image(view: ImageVW, DidChange value: Any, With adjust: ImageAdjustment)
}
    
class ImageVW: UIView {
    
    weak var delegate : ImageVWDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Menu: UIView!
    @IBOutlet var vw_Content: UIView!
    @IBOutlet var vw_Slider: UIView!
    
    @IBOutlet weak var clc_Menu: UICollectionView!
    @IBOutlet weak var clc_Content: UICollectionView!
    
    @IBOutlet weak var lbl_Intensity: UILabel!
    
    @IBOutlet weak var sld_Value: UISlider!
    
    @IBOutlet weak var lyl_h_Slider: NSLayoutConstraint!
    
    var muary_Menu = NSMutableArray()
    var muary_Content = NSMutableArray()
    
    var menu_Selected : String = ""
    
    var adjustType : ImageAdjustment = ImageAdjustment.brightness
    
    var context = CIContext()
    
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
        
        self.context = SingletonCIContext.context()
        
        self.contentView = configureNib()
        self.contentView.frame = bounds
        self.contentView.backgroundColor = .clear
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.contentView)
        
        self.contentView.backgroundColor = COLOR_GrayL240
        
        self.vw_Menu.backgroundColor = COLOR_White
        
        self.sld_Value.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        self.lbl_Intensity.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        
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
        
        let dict : [String:String] = self.muary_Menu.object(at: index) as! [String : String]
        self.menu_Selected = dict["name"]!
        
        let layout_Cat = self.clc_Content.collectionViewLayout as! UICollectionViewFlowLayout
        
        self.lbl_Intensity.text = "INTENSITY"
        
        if index == 0 {
            
            self.muary_Content = NSMutableArray(array: ARRAY_ImageMenu1)
            self.lyl_h_Slider.constant = 0
            layout_Cat.itemSize = CGSize(width: (self.clc_Content.frame.width - 5) / 3, height: 100)
        }
        else if index == 1 {
            
            self.lbl_Intensity.text = ""
            
            self.muary_Content = NSMutableArray(array: ARRAY_ImageMenu4)
            self.lyl_h_Slider.constant = 60
            layout_Cat.itemSize = CGSize(width: 115, height: 45)
            
            self.adjustType = ImageAdjustment(rawValue: 0)!
            self.action_SelectAdjustmentOption()
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
        
        AppSingletonObj.setViewAnimation(view: self.vw_Slider, hidden: false)
        AppSingletonObj.setViewAnimation(view: self.vw_Content, hidden: false)
    }
    
    @objc func action_SelectAdjustmentOption() {
        
        self.clc_Content.reloadData()
        
        if self.adjustType == ImageAdjustment.brightness {
            
            self.sld_Value.minimumValue = -0.5
            self.sld_Value.maximumValue = 0.5
            self.sld_Value.value = Float(Editor_VC.sharedInstance().info_Image.brightness)
        }
        else if self.adjustType == ImageAdjustment.exposure {
            
            self.sld_Value.minimumValue = -1.0
            self.sld_Value.maximumValue = 1.0
            self.sld_Value.value = Float(Editor_VC.sharedInstance().info_Image.exposure)
        }
        else if self.adjustType == ImageAdjustment.contrast {
            
            self.sld_Value.minimumValue = 0.0
            self.sld_Value.maximumValue = 2.0
            self.sld_Value.value = Float(Editor_VC.sharedInstance().info_Image.contrast)
        }
        else if self.adjustType == ImageAdjustment.vibrancy {
                        
            self.sld_Value.minimumValue = -0.3
            self.sld_Value.maximumValue = 0.3
            self.sld_Value.value = Float(Editor_VC.sharedInstance().info_Image.vibrancy)
        }
        else if self.adjustType == ImageAdjustment.saturation {
            
            self.sld_Value.minimumValue = 0.5
            self.sld_Value.maximumValue = 1.5
            self.sld_Value.value = Float(Editor_VC.sharedInstance().info_Image.saturation)
        }
        else if self.adjustType == ImageAdjustment.vignette {
            
            self.sld_Value.minimumValue = -2.2
            self.sld_Value.maximumValue = 0.2
            self.sld_Value.value = Float(Editor_VC.sharedInstance().info_Image.vignette)
        }
        else if self.adjustType == ImageAdjustment.blur {
            
            self.sld_Value.minimumValue = -5.0
            self.sld_Value.maximumValue = 5.0
            self.sld_Value.value = Float(Editor_VC.sharedInstance().info_Image.blur)
        }
    }
    @IBAction func action_ChangeAdjustmentValue(_ sender: UISlider) {
        
        if self.adjustType == ImageAdjustment.brightness {
            
            Editor_VC.sharedInstance().info_Image.brightness = CGFloat(sender.value)
        }
        else if self.adjustType == ImageAdjustment.exposure {
            
            Editor_VC.sharedInstance().info_Image.exposure = CGFloat(sender.value)
        }
        else if self.adjustType == ImageAdjustment.contrast {
            
            Editor_VC.sharedInstance().info_Image.contrast = CGFloat(sender.value)
        }
        else if self.adjustType == ImageAdjustment.vibrancy {
            
            Editor_VC.sharedInstance().info_Image.vibrancy = CGFloat(sender.value)
        }
        else if self.adjustType == ImageAdjustment.saturation {
            
            Editor_VC.sharedInstance().info_Image.saturation = CGFloat(sender.value)
        }
        else if self.adjustType == ImageAdjustment.vignette {
            
            Editor_VC.sharedInstance().info_Image.vignette = CGFloat(sender.value)
        }
        else if self.adjustType == ImageAdjustment.blur {
            
            var value = sender.value
            
            if sender.value < 0.0 {
                
                value = sender.value * -1.0
            }
            
            Editor_VC.sharedInstance().info_Image.blur = CGFloat(value)
        }
        
        self.changeImageAdjustValue()
    }
    
    func changeImageAdjustValue() {
        
        let mainImage = Editor_VC.sharedInstance().info_Image.original
        
        let brightness = BrightnessAdjustment()
        brightness.brightness = Float(Editor_VC.sharedInstance().info_Image.brightness)
        
        let exposure = ExposureAdjustment()
        exposure.exposure = Float(Editor_VC.sharedInstance().info_Image.exposure)
        
        let contrast = ContrastAdjustment()
        contrast.contrast = Float(Editor_VC.sharedInstance().info_Image.contrast)
        
        let vibrance = Vibrance()
        vibrance.vibrance = Float(Editor_VC.sharedInstance().info_Image.vibrancy)
        
        let saturation = SaturationAdjustment()
        saturation.saturation = Float(Editor_VC.sharedInstance().info_Image.saturation)
        
        let vignette = Vignette()
        vignette.end = Float((Editor_VC.sharedInstance().info_Image.vignette * -1) + 1.0)
        
        let editedImage = mainImage.filterWithPipeline { (input, output) in

            input --> brightness --> exposure --> contrast --> vibrance --> saturation --> vignette --> output
        }
        
        let imgLast = self.blur(image: editedImage, With: Float(Editor_VC.sharedInstance().info_Image!.blur))
        self.delegate?.image?(view: self, DidChange: imgLast)
    }
    
    func blur(image: UIImage, With scale: Float) -> UIImage {
        
        if scale <= 0.0 {
        
            return image
        }
        
        let inputImage = CIImage(image: image)
        let filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputImage" : inputImage as Any,
                                                                   "inputRadius" : NSNumber(value: scale)])
        let result = filter?.outputImage
        let cgImage = self.context.createCGImage(result!, from: result!.extent)
        let outputImage = UIImage(cgImage: cgImage!)
              
        return outputImage
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
            
            if self.menu_Selected == kMENUIMAGE_Image || self.menu_Selected == kMENUIMAGE_Adjustments {
                
                let cell : cell_c_View = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_View", for: indexPath) as! cell_c_View
                
                cell.lbl_Name.text = (self.muary_Content.object(at: indexPath.row) as! String)
                
                if self.menu_Selected == kMENUIMAGE_Adjustments && indexPath.row == self.adjustType.rawValue {
                    
                    cell.vw_BG.backgroundColor = COLOR_GrayD060
                    cell.lbl_Name.textColor = COLOR_White
                }
                else {
                    
                    cell.vw_BG.backgroundColor = COLOR_White
                    cell.lbl_Name.textColor = COLOR_Black
                }
                
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
                        
            self.action_SelectOption(index: indexPath.row)
        }
        else {
            
            if self.menu_Selected == kMENUIMAGE_Image {
                
                self.delegate?.image?(view: self, changeImage: (self.muary_Content.object(at: indexPath.row) as! String))
            }
            else {
                
                self.adjustType = ImageAdjustment(rawValue: indexPath.row)!
                self.action_SelectAdjustmentOption()
            }
        }
    }
}
