
//
//  Editor_VC.swift
//  Typorama
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GPUImage

enum ImagePickerType : Int {
    
    case Image
    case Logo
}

class Editor_VC: UIViewController {

    @IBOutlet weak var vw_Tab: UIView!
    @IBOutlet weak var vw_Editor: UIView!
    @IBOutlet weak var vw_Canvas: UIView!
    @IBOutlet weak var vw_Shapes: UIView!
    @IBOutlet weak var vw_Images: UIView!
    @IBOutlet weak var vw_Layers: UIView!
    
    @IBOutlet weak var imgvw_Canvas: UIImageView!
    @IBOutlet weak var imgvw_Main: UIImageView!
    
    @IBOutlet weak var vw_Text: TextVW!
    @IBOutlet weak var vw_Image: ImageVW!
    @IBOutlet weak var vw_WaterMark: WaterMarkVW!
    @IBOutlet weak var vw_Shape: ShapeVW!
    
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var btn_Share: UIButton!
    @IBOutlet weak var btn_Text: UIButton!
    @IBOutlet weak var btn_Image: UIButton!
    @IBOutlet weak var btn_AddLayer: UIButton!
    @IBOutlet weak var btn_WaterMark: UIButton!
    @IBOutlet weak var btn_GoPro: UIButton!
    
    @IBOutlet weak var lyl_w_Canvas: NSLayoutConstraint!
    @IBOutlet weak var lyl_h_Canvas: NSLayoutConstraint!
    @IBOutlet weak var lyl_l_SelMenu: NSLayoutConstraint!
    
    var info_Image : infoImage!
    
    var openImagePickerType : ImagePickerType = ImagePickerType.Image
    
    var sticker_Selected : ZDStickerView = ZDStickerView()
    var sticker_Logo : ZDStickerView = ZDStickerView()
    
    var isFirstLoaded : Bool = false
        
    static var instance: Editor_VC!
    class func sharedInstance() -> Editor_VC {
        
        return self.instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Editor_VC.instance = self
        
        self.view.backgroundColor = COLOR_Cream
        self.vw_Tab.backgroundColor = COLOR_GrayL240
        
        self.btn_Back.titleLabel?.font = UIFont.fontAwesome(ofSize: APPFONT_Size17, style: .solid)
        self.btn_Back.setTitle(String.fontAwesomeIcon(name: FontAwesome.longArrowAltLeft), for: .normal)
        
        self.btn_Share.titleLabel?.font = UIFont.fontAwesome(ofSize: APPFONT_Size17, style: .solid)
        self.btn_Share.setTitle(String.fontAwesomeIcon(name: .shareAlt), for: .normal)
        
        self.btn_AddLayer.titleLabel?.font = UIFont.fontAwesome(ofSize: APPFONT_Size22, style: .solid)
        self.btn_AddLayer.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        
        self.btn_Text.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        self.btn_Image.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        self.btn_WaterMark.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        self.btn_GoPro.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        
        self.action_SelectTab(self.btn_Text)
        
        self.vw_Canvas.backgroundColor = .clear
        self.vw_Canvas.clipsToBounds = true
        
        self.imgvw_Main.image = self.info_Image.getImage(size: self.vw_Editor.frame.size)
                
        self.vw_Text.delegate = self
        self.vw_Image.delegate = self
        self.vw_WaterMark.delegate = self
        self.vw_Shape.delegate = self
        
        self.imgvw_Canvas.isHidden = false
        self.lyl_w_Canvas.constant = 5
        self.lyl_h_Canvas.constant = 5
        self.vw_Text.sizeCanvas = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.view.updateConstraintsIfNeeded()
        
        self.perform(#selector(self.action_AddLogo), with: nil, afterDelay: 0.9)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateManuallyConstraints(size: AppSingletonObj.getCommonCanvasSize())
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.updateConstraints()
        self.updateManuallyConstraints()
        self.imgvw_Canvas.isHidden = false
        if self.isFirstLoaded == false {
            
            self.isFirstLoaded = true
            self.perform(#selector(self.action_AddSticker), with: nil, afterDelay: 0.25)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.hideLayerAllHander()
    }
    
    func hideLayerAllHander() {
        
        for vw in self.vw_Canvas.subviews {
            
            if(vw.isKind(of: ZDStickerView.self)) {
                
                (vw as! ZDStickerView).hideEditingHandles()
            }
        }
    }
    
    func updateUserInteractionEnabled(type: LayerType) {
        
        for vw in self.vw_Canvas.subviews {
            
            if(vw.isKind(of: ZDStickerView.self)) {
                
                (vw as! ZDStickerView).isUserInteractionEnabled = false
                let layerInfo = (vw as! ZDStickerView).info as! infoLayer
                
                if layerInfo.type == type {
                    
                    (vw as! ZDStickerView).isUserInteractionEnabled = true
                }
                else  {
                    
                    (vw as! ZDStickerView).isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func updateManuallyConstraints(size: CGSize = CGSize.zero) {
        
        let sz_Image = self.imgvw_Main.image?.size
        
        var w_Can : CGFloat = self.vw_Editor.frame.width
        var h_Can : CGFloat = self.vw_Editor.frame.height
        
        if !size.equalTo(CGSize.zero) {
            
            w_Can = size.width
            h_Can = size.height
        }
        
        if CGFloat(sz_Image!.width) > CGFloat(sz_Image!.height) {
            
            h_Can = (w_Can * sz_Image!.height) / sz_Image!.width
        }
        else {
         
            w_Can = (h_Can * sz_Image!.width) / sz_Image!.height
        }
        
        self.lyl_w_Canvas.constant = w_Can
        self.lyl_h_Canvas.constant = h_Can
        
        self.vw_Text.sizeCanvas = CGSize(width: w_Can, height: h_Can)
        
        self.view.updateConstraintsIfNeeded()
    }
    
    @IBAction func action_Back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Share(_ sender: UIButton) {
//
//        let share = ShareView(frame: self.view.frame)
//        self.view.addSubview(share)
        self.hideLayerAllHander()
        let img_Content = AppSingletonObj.image(with: self.vw_Canvas)
        
        AppSingletonObj.manageMBProgress(isShow: true)
        self.hideLayerAllHander()
//        SavePhoto.shared().mergeAllLayer(view: self.vw_Canvas, With: self.imgvw_Main) { (image) in

            PhotosAlbum.shared().savePhoto(image: img_Content!, InAlbum: AppName, completionBlock: { (success) in
                
                AppSingletonObj.manageMBProgress(isShow: false)
            })
//        }
    }
    
    @IBAction func action_SelectTab(_ sender: UIButton) {
    
        let ary_Button = [self.btn_Text, self.btn_Image, self.btn_WaterMark, self.btn_GoPro]
        
        for btn in ary_Button {
            
            btn!.setTitleColor(COLOR_Black, for: .normal)
            btn!.backgroundColor = .clear
            btn!.titleLabel?.font = UIFont(name: APPFONT_Regular, size: APPFONT_Size12)
        }
        
        sender.setTitleColor(COLOR_Black, for: .normal)
        sender.backgroundColor = COLOR_White
        sender.titleLabel?.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        
        self.vw_Text.isHidden = true
        self.vw_Image.isHidden = true
        self.vw_WaterMark.isHidden = true
        self.vw_Shape.isHidden = true
        
        if sender == self.btn_Text {
            
            self.updateUserInteractionEnabled(type: LayerType.TEXT)
            self.vw_Text.isHidden = false
        }
        else if sender == self.btn_Image {
            
            self.updateUserInteractionEnabled(type: LayerType.PHOTO)
            self.vw_Image.isHidden = false
        }
        else if sender == self.btn_WaterMark {
            
            self.updateUserInteractionEnabled(type: LayerType.LOGO)
            self.vw_WaterMark.isHidden = false
        }
        else {
            
            self.updateUserInteractionEnabled(type: LayerType.SHAPE)
            self.vw_Shape.isHidden = false
        }
        
        self.lyl_l_SelMenu.constant = sender.superview!.frame.origin.x
        self.view.updateConstraintsIfNeeded()
    }
    
    @IBAction func action_AddNewSticker(_ sender: UIButton) {
        
        self.action_AddSticker()
    }
    
    
    @objc func action_AddLogo() {
            
        self.sticker_Selected.hideEditingHandles()
            
        let textColor = self.info_Image.color.isEqual(UIColor.black) ? UIColor.white : UIColor.black
        let infoL = infoLayer(color: textColor, text: "")
        infoL.type = LayerType.LOGO
        let frame_Text = CGRect(x: 0, y: 0, width: 100, height: 100)
        let imgvw_Logo = UIImageView()
        
        self.sticker_Logo = ZDStickerView(frame: frame_Text)
        self.sticker_Logo.stickerViewDelegate = self
        self.sticker_Logo.info = infoL
        self.sticker_Logo.contentView = imgvw_Logo
        self.sticker_Logo.preventsPositionOutsideSuperview = false
        self.sticker_Logo.translucencySticker = false
        self.sticker_Logo.allowPinchToZoom = true
        self.sticker_Logo.allowRotationGesture = true
        self.sticker_Logo.borderWidth = 3.0
        self.sticker_Logo.borderColor = .darkGray
        self.sticker_Logo.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        self.vw_Canvas.addSubview(self.sticker_Logo)
        self.sticker_Logo.hideEditingHandles()
        self.sticker_Logo.hideDelHandle()
        self.sticker_Logo.isHidden = true
        
        let info_LogoPrev = DataManager.initDB().RETRIEVE_Logo(query: "Select * from tbl_Logo")
        if info_LogoPrev.l_id != "" {
         
            let query_RetrieveLogo = String(format: "Select * from tbl_LogoList Where l_id = '%@'", info_LogoPrev.l_id)
            let muary_Logo = DataManager.initDB().RETRIEVE_LogoList(query: query_RetrieveLogo)
            if muary_Logo.count > 0 {
                
                let info_Logo = muary_Logo.object(at: 0) as! infoLogoList
                let str_FilePath = AppSingletonObj.getPath(filename: info_Logo.l_image, With: AppFolder_Logo)
                let img_Logo = UIImage(contentsOfFile: str_FilePath)
                self.logo(view: self.vw_WaterMark, Change: img_Logo!, With: info_Logo.l_id)
                self.logo(view: self.vw_WaterMark, DidChange: info_Logo.l_opacity)
            }
        }
    }
    
    func action_UpdateLogo(image: UIImage) {
       
        (self.sticker_Logo.info as! infoLayer).main = image
        (self.sticker_Logo.info as! infoLayer).image = image
        
        let sz_Image = image.size
        
        if sz_Image.width > 0 && sz_Image.height > 0 {
            
            self.sticker_Logo.isHidden = false
        }
        else {
            
            self.sticker_Logo.isHidden = true
        }
        
        let imgvw_Logo = UIImageView(image: image)
        imgvw_Logo.contentMode = .scaleAspectFit
        self.sticker_Logo.contentView = imgvw_Logo
    }
           
    func action_UpdateLogoFrame(image: UIImage) {
        
        let query_RetrieveLogo = String(format: "Select * from tbl_LogoList Where l_id = '%@'", self.sticker_Logo.logoID)
        let muary_Logo = DataManager.initDB().RETRIEVE_LogoList(query: query_RetrieveLogo)
        if muary_Logo.count > 0 {
         
            self.sticker_Logo.transform = CGAffineTransform.identity
            let info_Logo = muary_Logo.object(at: 0) as! infoLogoList
            
            if info_Logo.l_size != "" && info_Logo.l_origin != "" && info_Logo.l_super_size != "" {
                                
                let ary_LogoSize = info_Logo.l_size.components(separatedBy: "#")
                let ary_LogoOrigin = info_Logo.l_origin.components(separatedBy: "#")
//                let ary_LogoTrans = info_Logo.l_super_size.components(separatedBy: "#")
                
                let x_Logo = CGFloat(Float(ary_LogoOrigin[0])!) * self.sticker_Logo.superview!.frame.width
                let y_Logo = CGFloat(Float(ary_LogoOrigin[1])!) * self.sticker_Logo.superview!.frame.height

                var frame_Logo = self.sticker_Logo.frame
                frame_Logo.size = CGSize(width: CGFloat(Float(ary_LogoSize[0])!), height: CGFloat(Float(ary_LogoSize[1])!))
                self.sticker_Logo.frame = frame_Logo
                self.sticker_Logo.center = CGPoint(x: x_Logo, y: y_Logo)
                self.sticker_Logo.updateDelta()
                
                let transform = CGAffineTransform(rotationAngle: CGFloat(Float(info_Logo.l_super_size)!))
                self.sticker_Logo.transform = transform
            }
            else if image.size.width > 0 && image.size.height > 0 {
                
                let sz_Image = image.size
                
                var w_Can : CGFloat = 150
                var h_Can : CGFloat = 150
                
                if CGFloat(sz_Image.width) > CGFloat(sz_Image.height) {
                    
                    h_Can = (w_Can * sz_Image.height) / sz_Image.width
                }
                else {
                 
                    w_Can = (h_Can * sz_Image.width) / sz_Image.height
                }
                
                let frame_Logo = CGRect(x: ((self.sticker_Logo.superview?.frame.width)! - w_Can) / 2, y: (self.sticker_Logo.superview?.frame.height)! - h_Can - 20, width: w_Can + 30, height: h_Can + 30)
                self.sticker_Logo.frame = frame_Logo
                self.sticker_Logo.updateDelta()
            }
        }
    }
    
    @objc func action_AddImage(image: UIImage, type: LayerType) {
        
        self.sticker_Selected.hideEditingHandles()
        
        let textColor = self.info_Image.color.isEqual(UIColor.black) ? UIColor.white : UIColor.black
        let infoL = infoLayer(color: textColor, text: "")
        infoL.type = type
        infoL.main = image
        infoL.image = image
        
        let imgvw_Con = UIImageView(image: image)
        imgvw_Con.contentMode = .scaleAspectFit
        var w_Layer : CGFloat = self.vw_Canvas.frame.width / 2
        var h_Layer : CGFloat = self.vw_Canvas.frame.height / 2
        
        let sz_Image = image.size
        
        if CGFloat(sz_Image.width) > CGFloat(sz_Image.height) {
            
            h_Layer = (w_Layer * sz_Image.height) / sz_Image.width
        }
        else {
         
            w_Layer = (h_Layer * sz_Image.width) / sz_Image.height
        }
        
        let frame_Text = CGRect(x: 0, y: 0, width: w_Layer + 30, height: h_Layer + 30)
        
        let layer_Image = ZDStickerView(frame: frame_Text)
        layer_Image.stickerViewDelegate = self
        layer_Image.info = infoL
        layer_Image.contentView = imgvw_Con
        layer_Image.preventsPositionOutsideSuperview = true
        layer_Image.translucencySticker = false
        layer_Image.allowPinchToZoom = true
        layer_Image.allowRotationGesture = true
        layer_Image.borderWidth = 3.0
        layer_Image.borderColor = .darkGray
        layer_Image.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        self.vw_Canvas.addSubview(layer_Image)
        layer_Image.center = CGPoint(x: self.vw_Canvas.frame.width / 2, y: self.vw_Canvas.frame.height / 2)
        self.stickerViewDidBeginEditing(layer_Image)
        layer_Image.hideEditingHandles()
        
        var isTrue : Bool = true
        
        while isTrue == true {
            
            let layerPossession : Int = (layer_Image.superview?.subviews.firstIndex(of: layer_Image))!
            layer_Image.superview?.exchangeSubview(at: layerPossession - 1, withSubviewAt: layerPossession)
            let vw_Aftr = type == LayerType.PHOTO ? self.vw_Layers : self.vw_Shapes
            let layertype : Int = (vw_Aftr?.superview?.subviews.firstIndex(of: vw_Aftr!))!
            
            if layertype >= layerPossession {
                
                isTrue = false
            }
        }
    }
    
    @objc func action_AddSticker() {
        
        self.sticker_Selected.hideEditingHandles()
        
        let textColor = self.info_Image.color.isEqual(UIColor.black) ? UIColor.white : UIColor.black
        let infoL = infoLayer(color: textColor, text: "")
        infoL.gradient.colors = [textColor, textColor.inverseColor()]
//        infoL.fontFamily = ARRAY_Font[AppSingletonObj.randomNumber(min: 0, max: ARRAY_Font.count - 1)]
        
        let vw_Add = UIImageView(frame: CGRect(x: 2, y: 2, width: self.vw_Editor.frame.width / 2, height: 4))
        
        let layer_Text = ZDStickerView(frame: CGRect(x: 2, y: 2, width: vw_Add.frame.width, height: vw_Add.frame.height))
        layer_Text.stickerViewDelegate = self
        layer_Text.info = infoL
        layer_Text.contentView = vw_Add
        layer_Text.preventsPositionOutsideSuperview = false
        layer_Text.translucencySticker = false
        layer_Text.allowPinchToZoom = true
        layer_Text.allowRotationGesture = true
        layer_Text.borderWidth = 3.0
        layer_Text.borderColor = .darkGray
        layer_Text.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        self.vw_Canvas.addSubview(layer_Text)
        layer_Text.center = CGPoint(x: self.vw_Canvas.frame.width / 2, y: self.vw_Canvas.frame.height / 2)
        self.stickerViewDidBeginEditing(layer_Text)
        layer_Text.hideEditingHandles()
        self.sticker_Selected = layer_Text;
        self.vw_Text.addNewSticker()
        
        self.vw_Canvas.bringSubviewToFront(self.sticker_Logo)
    }
    func updateLayer(layer: ZDStickerView, infoS: infoStyle, isAnimate: Bool = true, width: CGFloat = 0) {
        
        self.view.isUserInteractionEnabled = false
        layer.hideEditingHandles()
        (layer.info as! infoLayer).style = infoS
        let transform : CGAffineTransform = layer.transform
        layer.transform = CGAffineTransform.identity
        
        let center_Point : CGPoint = layer.center
        
        let effect =  infoS.effect
        let wdt_Vw : CGFloat = width == 0 ? (self.vw_Editor.frame.width / 2) + 20 : width
        
        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
        
        var ary_Label : [UILabel] = []
        
        let textColor : UIColor = (layer.info as! infoLayer).color
        let fontFamily = infoS.fontFamily
        let bgColor : UIColor = infoS.style == LayerStyle.SOLID ? (layer.info as! infoLayer).color : UIColor.clear
        let isClearLabel : Bool = infoS.style == LayerStyle.SOLID ? true : false
        let x_Gap : CGFloat = infoS.style == LayerStyle.SOLID ? (wdt_Vw / 30) : 0
//        let y_Gap : CGFloat = 0
        let y_Gap : CGFloat = infoS.lineSpacing
        let w_Border : CGFloat = wdt_Vw / (20 * infoS.borderDiv)
        var h_Line : CGFloat = wdt_Vw / (30 * infoS.lineDiv)
        h_Line = h_Line > 5 ? 5 : h_Line
        
        let lbl_Border = UILabel()
        lbl_Border.clipsToBounds = true
        lbl_Border.layer.borderColor = infoS.style == LayerStyle.LEFT ? UIColor.clear.cgColor : textColor.cgColor
        lbl_Border.layer.borderWidth = effect.isBorder == true ? w_Border : 0
        vw_Edit.addSubview(lbl_Border)
        ary_Label.append(lbl_Border)
        
        if effect.isBorder == true && infoS.style == LayerStyle.ONELASTSMILE {
            
            var white : CGFloat = 0
            textColor.getWhite(&white, alpha: nil)

            lbl_Border.backgroundColor = white >= 0.5 ? .black : .white
            lbl_Border.layer.borderWidth = 0.0
        }
        else {
            
            lbl_Border.backgroundColor = .clear
        }
        
        var fl_pd : CGFloat = 0
        var isPrevLine : Bool = false
        var maxStrFont : Int = 20
        let padding : CGFloat = 10
        var y : CGFloat = w_Border + h_Line + padding
        let x : CGFloat = w_Border + h_Line + padding
        
        if infoS.isJustifiedText == false {
            
            let max = effect.texts.max(by: {$1.text.count > $0.text.count})
            let w_Label = wdt_Vw - ((w_Border + h_Line + padding) * 2)
            var sz_Add : CGSize = CGSize(width: w_Label, height: h_Line)
            
            maxStrFont = Int(2.1 * wdt_Vw / CGFloat(max!.text.count))            
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = infoS.textAlignment
                        
            var attrs = [NSAttributedString.Key.font: UIFont(name: fontFamily, size: CGFloat(maxStrFont)) as Any,
                         NSAttributedString.Key.foregroundColor : textColor,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.kern : NSNumber(value: Float(infoS.charcterSpacing))]
            
            let string = (infoS.preText + max!.text + infoS.postText).uppercased()
                        
            var isIncFont : Bool = true
            while(isIncFont == true){
                
                maxStrFont -= 1
                
                attrs[NSAttributedString.Key.font] = UIFont(name: fontFamily, size: CGFloat(maxStrFont)) as Any
                sz_Add = (string as NSString).size(withAttributes: attrs)
                
                if maxStrFont < 3 || sz_Add.width < w_Label {
                    
                    isIncFont = false
                }
            }
        }
        
        for info in effect.texts {
            
            let w_Label = wdt_Vw - ((w_Border + h_Line + padding) * 2)
            var sz_Add : CGSize = CGSize(width: w_Label, height: h_Line)
            
            let lbl_Edit = PaddingLabel(frame: CGRect(x: x, y: y, width: w_Label, height: CGFloat.greatestFiniteMagnitude))
            vw_Edit.addSubview(lbl_Edit)
                        
            let divFont : CGFloat = isClearLabel == true ? 2.0 : 2.1
            
            var largestFontSize: CGFloat = 20
            if infoS.isJustifiedText == false {
                
                largestFontSize = CGFloat(maxStrFont)
            }
            else if (info.isLine == false || info.text.count > 0) {
                
                largestFontSize = divFont * wdt_Vw / CGFloat(info.text.count)
            }
            
            lbl_Edit.text = (infoS.preText + info.text + infoS.postText).uppercased()
            lbl_Edit.font = UIFont(name: fontFamily, size: largestFontSize)
            lbl_Edit.numberOfLines = 1
            lbl_Edit.minimumScaleFactor = 0.01
            lbl_Edit.lineBreakMode = .byWordWrapping
            lbl_Edit.textAlignment = infoS.textAlignment //== LayerStyle.LEFT ? .left : .center

            lbl_Edit.adjustsFontSizeToFitWidth = true
            lbl_Edit.textColor = textColor
            
            let attributedString = NSMutableAttributedString(attributedString: lbl_Edit.attributedText!)
            //
            //            let style = NSMutableParagraphStyle()
            //            style.lineHeightMultiple = infoS.lineSpacing
            //            style.alignment = lbl_Edit.textAlignment
            //            style.lineBreakMode = .byWordWrapping
            //            //NSAttributedString.Key.paragraphStyle : style,
            //
            attributedString.addAttributes([NSAttributedString.Key.kern : NSNumber(value: Float(infoS.charcterSpacing))],
                                           range: NSRange(location: 0, length: lbl_Edit.text!.count))
            
            lbl_Edit.attributedText = attributedString
            var h_LabelU : CGFloat = 0
            var pd : CGFloat = 0
            var charcterSpacing = infoS.charcterSpacing
            
            if info.isLine == true {
                
                h_LabelU = 0
                lbl_Edit.backgroundColor = textColor
                sz_Add = CGSize(width: w_Label, height: h_Line)
            }
            else if infoS.isJustifiedText == true {
                
                var w_LabelU = w_Label
                
                if isClearLabel == true {
                    
                    h_LabelU = 6
                    w_LabelU = w_Label - 50
                }
                print("bf font ---> \(largestFontSize)")
                while(lbl_Edit.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width > w_LabelU){
                    
                    sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_LabelU, height: CGFloat.greatestFiniteMagnitude))
                    
                    if sz_Add.width < w_LabelU {
                        
                        largestFontSize += 0.30
                    }
                    else if sz_Add.width > w_LabelU {
                        
                        largestFontSize -= 0.30
                    }
                    
                    
                    if largestFontSize < 3 {
                        
                        largestFontSize = 2.5
                        break
                    }
                    lbl_Edit.font = UIFont(name: lbl_Edit.font.fontName, size: largestFontSize)
                }
                print("af font ---> \(largestFontSize)")
                //                print("dt space ---> \(w_LabelU)")
                
                lbl_Edit.backgroundColor = bgColor
                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_LabelU, height: CGFloat.greatestFiniteMagnitude))
                //                print("bf space ---> \(sz_Add)")
                if sz_Add.width != w_LabelU {
                    
                    while(lbl_Edit.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width < w_LabelU){
                        
                        if sz_Add.width < w_LabelU {
                            
                            charcterSpacing += 0.05
                        }
                        else if sz_Add.width > w_LabelU {
                            
                            charcterSpacing -= 0.05
                        }
                        
                        let attributedString = NSMutableAttributedString(attributedString: lbl_Edit.attributedText!)
                        
                        attributedString.addAttributes([NSAttributedString.Key.kern : NSNumber(value: Float(charcterSpacing))],
                                                       range: NSRange(location: 0, length: lbl_Edit.text!.count))
                        
                        lbl_Edit.attributedText = attributedString
                        sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_LabelU, height: CGFloat.greatestFiniteMagnitude))
                        
                        //                        print("spc space ---> \(charcterSpacing)---> \(sz_Add)")
                        if (lbl_Edit.frame.width > w_LabelU || charcterSpacing > largestFontSize || charcterSpacing < -10) {
                            
                            break
                        }
                    }
                }
                
                pd = -largestFontSize / 10
                
                lbl_Edit.topInset = pd * (-1)
                lbl_Edit.bottomInset = pd
                
                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_LabelU, height: CGFloat.greatestFiniteMagnitude))
                //                print("af space ---> \(sz_Add)")
            }
            else {
                
                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_Label, height: CGFloat.greatestFiniteMagnitude))
            }
            
            if fl_pd == 0 && isClearLabel == false {
                
                fl_pd = pd
            }
            
            let ln_PrevLine : CGFloat = isPrevLine == true ? 2 : 0
            
            if info.isLine == true || isClearLabel == true {
                
                pd = 0
                let ln_pd : CGFloat = info.isLine == true ? 2 : 0
                lbl_Edit.frame = CGRect(x: x, y: y + ln_pd, width: w_Label, height: sz_Add.height + h_LabelU)
            }
            else {
                
                lbl_Edit.frame = CGRect(x: x, y: y + pd + ln_PrevLine, width: w_Label, height: sz_Add.height + h_LabelU + (pd * 2))
            }
            
            var yClearLabel : CGFloat = 0
            if isClearLabel == true && info.isLine != true {
                
                yClearLabel = lbl_Edit.frame.height / 10;
                
                let objCTLbl = RSMaskedLabel(frame: lbl_Edit.frame)
                vw_Edit.addSubview(objCTLbl)
                lbl_Edit.removeFromSuperview()
                objCTLbl.text = info.text.uppercased()
                objCTLbl.font = lbl_Edit.font
                objCTLbl.backgroundColor = bgColor
                objCTLbl.numberOfLines = 1
                objCTLbl.minimumScaleFactor = 0.01
                objCTLbl.lineBreakMode = .byWordWrapping
                objCTLbl.textAlignment = .center
                objCTLbl.adjustsFontSizeToFitWidth = true
                
                let attributedString = NSMutableAttributedString(attributedString: objCTLbl.attributedText!)
                attributedString.addAttributes([NSAttributedString.Key.kern : NSNumber(value: Float(charcterSpacing))],
                                               range: NSRange(location: 0, length: objCTLbl.text!.count))
                objCTLbl.attributedText = attributedString
                
                ary_Label.append(objCTLbl)
            }
            else {
                
                yClearLabel = -3
                ary_Label.append(lbl_Edit)
            }
            
            isPrevLine = info.isLine
            
            y = y + lbl_Edit.frame.height + x_Gap + y_Gap + pd - yClearLabel
        }
        
        var rect = vw_Edit.frame
        rect.size.height = y + w_Border + h_Line + padding - y_Gap - x_Gap //- fl_pd
        vw_Edit.frame = rect
        lbl_Border.frame = CGRect(x: padding, y: padding, width: rect.width - padding * 2, height: rect.height - padding * 2)
        
        let frame_Text = CGRect(x: (self.vw_Canvas.frame.width - vw_Edit.frame.width) / 2, y: (self.vw_Canvas.frame.height - vw_Edit.frame.height) / 2, width: vw_Edit.frame.width + 20, height: vw_Edit.frame.height + 20)
        
        layer.frame = frame_Text
        layer.updateDelta()
        layer.contentView = vw_Edit
        layer.shadowView = UIView()
        layer.center = center_Point
        layer.transform = transform
        
        if self.vw_Canvas.frame.height + 20 < frame_Text.height && width == 0 {
            
            let wdt_Reduce = (self.vw_Canvas.frame.height * (frame_Text.width - 30)) / frame_Text.height
            self.updateLayer(layer: layer, infoS: infoS, isAnimate: isAnimate, width: wdt_Reduce - 20)
            return
        }
        
        let img_Content = AppSingletonObj.image(with: vw_Edit)
        
        //        let img_Gradient = AppSingletonObj.setImageClipMask(img_Content, color: UIColor(patternImage: AppSingletonObj.imageWithGradient(img: img_Content)))
        
        
        
        if isAnimate == true {
            
            for i in 0 ..< ary_Label.count {
                
                let lbl = ary_Label[i]
                lbl.alpha = 0.0
                lbl.transform = CGAffineTransform(scaleX: 2, y: 2)
                //                UIView.animate(withDuration: 0.23, delay: 0.23 * Double(i), options: .curveEaseOut, animations: {
                //                    lbl.transform = CGAffineTransform.identity
                //                    lbl.alpha = 1.0
                //                }) { finished in
                //
                //                    self.setLayerContent(image: img_Content!, On: layer)
                //                }
            }
            
            self.recursiveAnimation(ary_Label: ary_Label, index: 0) { (index) in

                self.setLayerContent(image: img_Content!, On: layer)
                self.view.isUserInteractionEnabled = true
            }
        }
        else {
            
            self.setLayerContent(image: img_Content!, On: layer)
            self.view.isUserInteractionEnabled = true
        }
    }
    func updateLayer1(layer: ZDStickerView, infoS: infoStyle, isAnimate: Bool = true, width: CGFloat = 0) {
        
        self.view.isUserInteractionEnabled = false
        layer.hideEditingHandles()
        (layer.info as! infoLayer).style = infoS
        let transform : CGAffineTransform = layer.transform
        layer.transform = CGAffineTransform.identity
        
        let center_Point : CGPoint = layer.center
        
        let effect =  infoS.effect
        
//        let wdt_Vw : CGFloat = layer.bounds.width
        let wdt_Vw : CGFloat = width == 0 ? (self.vw_Editor.frame.width / 2) + 20 : width
        
        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
        
        var ary_Label : [UIImageView] = []
        
        let textColor : UIColor = (layer.info as! infoLayer).color
        let fontFamily = infoS.fontFamily
        let bgColor : UIColor = infoS.style == LayerStyle.SOLID ? (layer.info as! infoLayer).color : UIColor.clear
        let isClearLabel : Bool = infoS.style == LayerStyle.SOLID ? true : false
        let x_Gap : CGFloat = infoS.style == LayerStyle.SOLID ? (wdt_Vw / 30) : 0
        let y_Gap : CGFloat = 0
//        let y_Gap : CGFloat = infoS.style == LayerStyle.SOLID ? 0 : infoS.lineSpacing
        let w_Border : CGFloat = wdt_Vw / (20 * infoS.borderDiv)
        var h_Line : CGFloat = wdt_Vw / (30 * infoS.lineDiv)
        h_Line = h_Line > 5 ? 5 : 5//h_Line
        
        var y : CGFloat = w_Border + h_Line
        
        let lbl_Border = UILabel()
        lbl_Border.clipsToBounds = true
        lbl_Border.layer.borderColor = textColor.cgColor
        lbl_Border.layer.borderWidth = effect.isBorder == true ? w_Border : 0
        vw_Edit.addSubview(lbl_Border)
//        ary_Label.append(lbl_Border)
        
        var fl_pd : CGFloat = 0
        var isPrevLine : Bool = false
        
        for info in effect.texts {
            
            let w_Label = wdt_Vw - ((w_Border + h_Line) * 2)
            var sz_Add : CGSize = CGSize(width: w_Label, height: h_Line)
            
            let divFont : CGFloat = isClearLabel == true ? 2.0 : 2.1
            
            var largestFontSize: Int = 20
            if info.isLine == false || info.text.count > 0 {
                
                largestFontSize = Int(divFont * wdt_Vw / CGFloat(info.text.count))
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            var attrs = [NSAttributedString.Key.font: UIFont(name: fontFamily, size: CGFloat(largestFontSize)) as Any,
                         NSAttributedString.Key.foregroundColor : textColor,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.kern : NSNumber(value: Float(infoS.charcterSpacing))]
            
            let string = info.text
            
            var h_LabelU : CGFloat = 0
            var pd : CGFloat = 0
            var charcterSpacing = infoS.charcterSpacing
            
            if info.isLine == true {
                
                h_LabelU = 0
                sz_Add = CGSize(width: w_Label, height: h_Line)
            }
            else {
                
                var w_LabelU = w_Label
                
                if isClearLabel == true {
                    
                    h_LabelU = 6
                    w_LabelU = w_Label - 50
                }
                
                sz_Add = (string as NSString).size(withAttributes: attrs)
                
                var isIncFont : Bool = true
                while(isIncFont == true){
                    
                    largestFontSize += 1
                    
                    attrs[NSAttributedString.Key.font] = UIFont(name: fontFamily, size: CGFloat(largestFontSize)) as Any
                    sz_Add = (string as NSString).size(withAttributes: attrs)
                    
                    if largestFontSize < 3 || sz_Add.width >= w_LabelU {
                        
                        attrs[NSAttributedString.Key.font] = UIFont(name: fontFamily, size: CGFloat(largestFontSize - 1)) as Any
                        isIncFont = false
                    }
                }
                
                sz_Add = (string as NSString).size(withAttributes: attrs)
                print("af font ---> \(largestFontSize)")
        
                var isIncSpace : Bool = true
                while(isIncSpace == true){
                    
                    charcterSpacing += 0.05
                    
                    attrs[NSAttributedString.Key.kern] = NSNumber(value: Float(charcterSpacing))
                    sz_Add = (string as NSString).size(withAttributes: attrs)
                    
                    if sz_Add.width >= w_LabelU {
                        
                        isIncSpace = false
                    }
                }

                sz_Add = (string as NSString).size(withAttributes: attrs)
                pd = CGFloat(-largestFontSize / 15)
            }
            
            if fl_pd == 0 && isClearLabel == false {
               
                fl_pd = pd
            }
     
            let ln_PrevLine : CGFloat = isPrevLine == true ? 2 : 0
            var newRect = CGRect.zero
            
            if info.isLine == true || isClearLabel == true {
             
                pd = 0
                let ln_pd : CGFloat = info.isLine == true ? 2 : 0
                newRect = CGRect(x: w_Border + h_Line, y: y + ln_pd, width: w_Label, height: sz_Add.height + h_LabelU)
            }
            else {
            
                newRect = CGRect(x: w_Border + h_Line, y: y + pd + ln_PrevLine, width: w_Label, height: sz_Add.height + h_LabelU + (pd * 2))
            }
      
            
            
            var yClearLabel : CGFloat = 0
            if isClearLabel == true && info.isLine != true {
                
                yClearLabel = newRect.height / 10;
                
                let objCTLbl = RSMaskedLabel(frame: newRect)
                vw_Edit.addSubview(objCTLbl)
                
                objCTLbl.text = info.text.uppercased()
                objCTLbl.font = (attrs[NSAttributedString.Key.font] as! UIFont)
                objCTLbl.backgroundColor = bgColor                
                objCTLbl.numberOfLines = 1
                objCTLbl.minimumScaleFactor = 0.01
                objCTLbl.lineBreakMode = .byWordWrapping
                objCTLbl.textAlignment = .center
                objCTLbl.adjustsFontSizeToFitWidth = true
                
                let attributedString = NSMutableAttributedString(attributedString: objCTLbl.attributedText!)
                attributedString.addAttributes(attrs, range: NSRange(location: 0, length: objCTLbl.text!.count))
                objCTLbl.attributedText = attributedString
                
//                ary_Label.append(objCTLbl)
            }
            else {
            
                var img : UIImage = UIImage()
                if info.isLine == true {
                    
                    img = AppSingletonObj.createImage(color: textColor, size: sz_Add)
                }
                else {
                    
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: sz_Add.width, height: sz_Add.height + pd * 2))
                    img = renderer.image { ctx in
                        
                        string.draw(with: CGRect(x: 0, y: pd, width: sz_Add.width, height: sz_Add.height + pd * 2), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                    }
                }
                
//                 let imgMask = self.maskImage(rect: CGRect(x: 0, y: 0, width: sz_Add.width, height: sz_Add.height), color: textColor, maskImage: img)
//                let imgMask = self.maskImage(image: AppSingletonObj.createImage(color: textColor, size: sz_Add), withMask: img)
                
                let imgvw_Con = UIImageView(image: img)
                imgvw_Con.frame = newRect
                imgvw_Con.contentMode = .redraw
                vw_Edit.addSubview(imgvw_Con)
                
                yClearLabel = -3
                ary_Label.append(imgvw_Con)
            }
            
            isPrevLine = info.isLine
            
            y = y + newRect.height + x_Gap + y_Gap + pd - yClearLabel
        }        
        
        var rect = vw_Edit.frame
        rect.size.height = y + w_Border + h_Line - y_Gap - x_Gap //- fl_pd
        vw_Edit.frame = rect
        lbl_Border.frame = rect
        
        let frame_Text = CGRect(x: (self.vw_Canvas.frame.width - vw_Edit.frame.width) / 2, y: (self.vw_Canvas.frame.height - vw_Edit.frame.height) / 2, width: vw_Edit.frame.width + 30, height: vw_Edit.frame.height + 30)
        
        layer.frame = frame_Text
        layer.contentView = vw_Edit
        layer.shadowView = UIView()
        layer.center = center_Point
        layer.transform = transform
        
        if self.vw_Canvas.frame.height + 20 < frame_Text.height && width == 0 {
            
            let wdt_Reduce = (self.vw_Canvas.frame.height * (frame_Text.width - 30)) / frame_Text.height
            self.updateLayer(layer: layer, infoS: infoS, isAnimate: isAnimate, width: wdt_Reduce - 20)
            return
        }
        
        let img_Content = AppSingletonObj.image(with: vw_Edit)
        
//        let img_Gradient = AppSingletonObj.setImageClipMask(img_Content, color: UIColor(patternImage: AppSingletonObj.imageWithGradient(img: img_Content)))
        
        
        
        if isAnimate == true {
         
            for i in 0 ..< ary_Label.count {
                
                let lbl = ary_Label[i]
                lbl.alpha = 0.0
                lbl.transform = CGAffineTransform(scaleX: 2, y: 2)
//                UIView.animate(withDuration: 0.23, delay: 0.23 * Double(i), options: .curveEaseOut, animations: {
//                    lbl.transform = CGAffineTransform.identity
//                    lbl.alpha = 1.0
//                }) { finished in
//
//                    self.setLayerContent(image: img_Content!, On: layer)
//                }
            }
            
            self.recursiveAnimation(ary_ImgVw: ary_Label, index: 0) { (index) in
                
                self.setLayerContent(image: img_Content!, On: layer)
                self.view.isUserInteractionEnabled = true
            }
        }
        else {
            
            self.setLayerContent(image: img_Content!, On: layer)
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func maskImage(rect: CGRect, color: UIColor, maskImage: UIImage) -> UIImage {
        
//        let maskRef = maskImage.cgImage
//
//        let mask = CGImage(
//            maskWidth: maskRef!.width,
//            height: maskRef!.height,
//            bitsPerComponent: maskRef!.bitsPerComponent,
//            bitsPerPixel: maskRef!.bitsPerPixel,
//            bytesPerRow: maskRef!.bytesPerRow,
//            provider: maskRef!.dataProvider!,
//            decode: nil,
//            shouldInterpolate: false)
//
//        let masked = image.cgImage!.masking(mask!)
//        let maskedImage = UIImage(cgImage: masked!)
//
//        return maskedImage

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        var context = UIGraphicsGetCurrentContext()
        var image = maskImage.cgImage
        UIGraphicsEndImageContext()
        
        // Revert to normal graphics context for the rest of the rendering
        context = UIGraphicsGetCurrentContext()
        
        context?.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: rect.height))
        
        // create a mask from the normally rendered text
        var mask = CGImage.init(maskWidth: image!.width, height: image!.height, bitsPerComponent: image!.bitsPerComponent, bitsPerPixel: image!.bitsPerPixel, bytesPerRow: image!.bytesPerRow, provider: image!.dataProvider!, decode: image!.decode, shouldInterpolate: image!.shouldInterpolate)
        image = nil
        
        // wipe the slate clean
        context?.clear(rect)
        
        context?.saveGState()
        context?.clip(to: rect, mask: mask!)
        
        mask = nil
        
        color.set()
        context?.fill(rect)
        
        context?.restoreGState()
        
        let img_Main = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img_Main!
    }
    func recursiveAnimation(ary_ImgVw: [UIImageView], index: Int, Handler:@escaping (_ index: Int) -> Void){
        
        if ary_ImgVw.count > index {
            
            let lbl = ary_ImgVw[index]
            UIView.animate(withDuration: 0.105, delay:0.0, options: .curveEaseOut, animations: {
                lbl.transform = CGAffineTransform.identity
                lbl.alpha = 1.0
            }) { finished in
                
                self.recursiveAnimation(ary_ImgVw: ary_ImgVw, index: index + 1, Handler: Handler)
            }
        }
        else {
            
            Handler(index)
        }
    }
    func recursiveAnimation(ary_Label: [UILabel], index: Int, Handler:@escaping (_ index: Int) -> Void){
        
        if ary_Label.count > index {
            
            let lbl = ary_Label[index]
            UIView.animate(withDuration: 0.105, delay:0.0, options: .curveEaseOut, animations: {
                lbl.transform = CGAffineTransform.identity
                lbl.alpha = 1.0
            }) { finished in
                
                self.recursiveAnimation(ary_Label: ary_Label, index: index + 1, Handler: Handler)
            }
        }
        else {
            
            Handler(index)
        }
    }
    func setLayerContent(image: UIImage, On layer: ZDStickerView) {
        
        (self.sticker_Selected.info as! infoLayer).main = image
        (self.sticker_Selected.info as! infoLayer).image = image
        let imgvw_Con = UIImageView(image: image)        
        imgvw_Con.contentMode = .scaleAspectFit
        layer.contentView = imgvw_Con
        let imgvw_Shadow = UIImageView(image: image)
        layer.shadowView = imgvw_Shadow
        
        layer.shadowView.isHidden = !(self.sticker_Selected.info as! infoLayer).shadow.isShadow
        
        if (self.sticker_Selected.info as! infoLayer).shadow.isShadow == true {
         
            self.updateShadowValueColor(layer: layer)
            self.updateShadowValue(layer: layer)
        }
        
        self.updateBorder(layer: layer)
        self.updateGradientValue(layer: layer)
    }
    
    func updateBorder(layer: ZDStickerView) {
        
//        (layer.contentView as! UIImageView).layer.masksToBounds = false
//        (layer.contentView as! UIImageView).layer.borderWidth = (layer.info as! infoLayer).style.effect.isBorder == true ? 3.0 : 0.0
//        (layer.contentView as! UIImageView).layer.borderColor = (layer.info as! infoLayer).color.cgColor
//
//        (layer.shadowView as! UIImageView).layer.masksToBounds = false
//        (layer.shadowView as! UIImageView).layer.borderWidth = (layer.info as! infoLayer).style.effect.isBorder == true ? 3.0 : 0.0
//        (layer.shadowView as! UIImageView).layer.borderColor = (layer.info as! infoLayer).shadow.color.cgColor
    }
    func updateLayerColor(layer: ZDStickerView) {
        
        let img_Main =  AppSingletonObj.setImageClipMask((layer.info as! infoLayer).main, color: (layer.info as! infoLayer).color)
        
        (self.sticker_Selected.info as! infoLayer).image = img_Main!
        let imgvw_Con = UIImageView(image: img_Main)
        layer.contentView = imgvw_Con
        
        if (self.sticker_Selected.info as! infoLayer).shadow.isShadow == true {
            
            self.updateShadowValueColor(layer: layer)
            self.updateShadowValue(layer: layer)
        }
    }
    
    func updateShadowValue(layer: ZDStickerView) {
        
        layer.shadowView.isHidden = !(self.sticker_Selected.info as! infoLayer).shadow.isShadow
        
        let frame_Con = layer.contentView.frame
        
        var frame = layer.shadowView.frame
        frame.origin.x = frame_Con.origin.x + (layer.info as! infoLayer).shadow.x
        frame.origin.y = frame_Con.origin.y + (layer.info as! infoLayer).shadow.y
        layer.shadowView.frame = frame
        layer.shadowView.alpha = (layer.info as! infoLayer).shadow.opacity
        self.updateBorder(layer: layer)
    }
    
    func updateShadowValueColor(layer: ZDStickerView) {
        
        self.updateBorder(layer: layer)
        let img_Shadow =  AppSingletonObj.setImageClipMask((layer.info as! infoLayer).image, color: (layer.info as! infoLayer).shadow.color)
        
        (layer.shadowView as! UIImageView).image = img_Shadow
        
        if (layer.info as! infoLayer).shadow.blur > 0 {
            
//            (layer.shadowView as! UIImageView).image = self.gaussianBlur(image: img_Shadow!, radius: (layer.info as! infoLayer).shadow.blur*20)
//            (layer.shadowView as! UIImageView).image = img_Shadow?.blurred(radius: (layer.info as! infoLayer).shadow.blur*15)
            (layer.shadowView as! UIImageView).image = img_Shadow?.gaussBlur((layer.info as! infoLayer).shadow.blur)
        }
    }
    
    func updateGradientValue(layer: ZDStickerView) {
        
        let infoLL = self.sticker_Selected.info as! infoLayer
        
        if infoLL.gradient.isGradient == true {
         
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: infoLL.main.size)
            let img_Gradient =  GradientLayer.shared().gradientImageWithBounds(bounds: rect, colors: infoLL.gradient.colors, angleº: infoLL.gradient.direction, location: infoLL.gradient.ratio)
            
            let img_Main = AppSingletonObj.setImageClipMask(infoLL.main, color: UIColor.init(patternImage: img_Gradient))
            (layer.contentView as! UIImageView).image = img_Main
        }
        else {
            
            (layer.contentView as! UIImageView).image = infoLL.image
        }
    }
    
    func gaussianBlur(image: UIImage, radius: CGFloat) -> UIImage {
        
//        let gaussianImage = GPUImagePicture(image: image)
        let gaussianBlur = GaussianBlur()
        gaussianBlur.blurRadiusInPixels = Float(radius)
        
//        gaussianImage?.addTarget(gaussianBlur)
//        gaussianBlur.useNextFrameForImageCapture()
//        gaussianImage?.processImage()
//        let gaussianOutput = gaussianBlur.imageFromCurrentFramebuffer()
        
//        return gaussianOutput!
        return image.filterWithOperation(gaussianBlur)
    }
}

extension Editor_VC: ZDStickerViewDelegate {
    
    func stickerViewDidBeginEditing(_ sticker: ZDStickerView!) {
        
        self.sticker_Selected.hideEditingHandles()
        self.sticker_Selected = sticker;
        self.sticker_Selected.showEditingHandles()
        
        if (self.sticker_Selected.info as! infoLayer).type == LayerType.LOGO {
            
            sticker.hideDelHandle()
        }
        else if (self.sticker_Selected.info as! infoLayer).type == LayerType.SHAPE {
            
            self.vw_Shape.sld_Opacity.value = Float(self.sticker_Selected.contentView.alpha)
        }
        else {
            
            self.vw_Text.layerDidBeginEditing(sticker: self.sticker_Selected)
        }
    }
    
    func stickerViewDidEndEditing(_ sticker: ZDStickerView!) {
             
        if (self.sticker_Selected.info as! infoLayer).type == LayerType.TEXT {
            
            self.updateShadowValue(layer: sticker)
        }
        else if (self.sticker_Selected.info as! infoLayer).type == LayerType.LOGO {
            
            let transform : CGAffineTransform = sticker.transform
            sticker.transform = CGAffineTransform.identity
            
            let str_Size = String(format: "%f#%f", sticker.frame.width, sticker.frame.height)
            let str_Origin = String(format: "%f#%f", sticker.center.x / sticker.superview!.frame.width, sticker.center.y / sticker.superview!.frame.height)
            
            let radians = atan2(transform.b, transform.a)
            let str_SuperSize = String(format: "%f", radians)
            
            let query_UpdateLogo = String(format: "Update tbl_LogoList set l_size = '%@', l_origin = '%@', l_super_size = '%@' Where l_id = '%@'", str_Size, str_Origin, str_SuperSize, sticker.logoID)
            DataManager.initDB().EXECUTE_Query(query: query_UpdateLogo)
            
            sticker.transform = transform
        }
    }
    
    func stickerViewDidCancelEditing(_ sticker: ZDStickerView!) {
        
//        print("stickerViewDidCancelEditing")
    }
    
    func stickerViewDidClose(_ sticker: ZDStickerView!) {
        
//        print("stickerViewDidClose")
    }
    func stickerViewDidDoubleTap(on sticker: ZDStickerView!) {
     
        if (self.sticker_Selected.info as! infoLayer).type == LayerType.TEXT {
            
            let obj_TextEditor_VC = self.storyboard?.instantiateViewController(withIdentifier: "TextEditor_VC") as! TextEditor_VC
            obj_TextEditor_VC.delegate = self
            obj_TextEditor_VC.img_BG = AppSingletonObj.takeScreenShotMethod(view: self.view)
            obj_TextEditor_VC.str_Text = (sticker.info as! infoLayer).text
            obj_TextEditor_VC.isLine = (sticker.info as! infoLayer).isLine
            obj_TextEditor_VC.modalPresentationStyle = .fullScreen
            self.present(obj_TextEditor_VC, animated: true) {
                
            }
        }
    }
    func stickerViewDidCustomButtonTap(_ sticker: ZDStickerView!) {
        
    }
}
extension Editor_VC: TextEditorDelegate {
    
    func textEditorDidFinishEdit(text: String, With isLine: Bool) {
        
        if text.condenseWhitespace().count > 0 {
            
            (self.sticker_Selected.info as! infoLayer).isLine = isLine
            (self.sticker_Selected.info as! infoLayer).text = text
            let info_Style = (self.sticker_Selected.info as! infoLayer).style            
            self.vw_Text.whenEditText(style: info_Style)
        }
    }
}
extension Editor_VC: TextVWDelegate {
    
    func text(view: TextVW, changeStyle style: infoStyle) {
     
        if (self.sticker_Selected.info as! infoLayer).type == LayerType.TEXT {
            
            self.updateLayer(layer: self.sticker_Selected, infoS: style)
        }
    }
    
    func text(view: TextVW, changeColor color: UIColor) {
        
        if (self.sticker_Selected.info as! infoLayer).type == LayerType.TEXT {
            
            (self.sticker_Selected.info as! infoLayer).color = color
            (self.sticker_Selected.info as! infoLayer).gradient.colors = [color, color.inverseColor()]
            (self.sticker_Selected.info as! infoLayer).gradient.isGradient = false
            
            self.updateLayerColor(layer: self.sticker_Selected)
                    
//            self.updateLayer(layer: self.sticker_Selected, infoS: (self.sticker_Selected.info as! infoLayer).style, isAnimate: false)
        }
    }
    
    func text(view: TextVW, ChangeShadow value: Any, With type: ShadowValue) {
        
        if (self.sticker_Selected.info as! infoLayer).type == LayerType.TEXT {
            
            (self.sticker_Selected.info as! infoLayer).shadow.isShadow = true
            
            if type == .color || type == .blur{
                
                if type == .color {
                    
                    (self.sticker_Selected.info as! infoLayer).shadow.color = value as! UIColor
                }
                else if type == .blur {
                    
                    (self.sticker_Selected.info as! infoLayer).shadow.blur = value as! CGFloat
                }
                
                self.updateShadowValueColor(layer: self.sticker_Selected)
            }
            else {
                
                if type == .opacity {
                    
                    (self.sticker_Selected.info as! infoLayer).shadow.opacity = value as! CGFloat
                }
                else if type == .x {
                    
                    (self.sticker_Selected.info as! infoLayer).shadow.x = value as! CGFloat
                }
                else if type == .y {
                    
                    (self.sticker_Selected.info as! infoLayer).shadow.y = value as! CGFloat
                }
                
                self.updateShadowValue(layer: self.sticker_Selected)
            }
        }
    }
    
    func textDidChangeGradient(view: TextVW) {
        
        self.updateGradientValue(layer: self.sticker_Selected)
    }
}

extension Editor_VC: ImageVWDelegate {
 
    func image(view: ImageVW, changeImage type: String) {
                
        if kImageMenu1_Photo == type {

            self.openImagePickerType = ImagePickerType.Image
            AppSingletonObj.openCamera(from: self)
        }
        else if kImageMenu1_Color == type {

            let obj_BackGround_VC = self.storyboard?.instantiateViewController(withIdentifier: "BackGround_VC") as! BackGround_VC
            obj_BackGround_VC.delegate = self
            obj_BackGround_VC.isFromEditor = true
            obj_BackGround_VC.modalPresentationStyle = .fullScreen
            self.present(obj_BackGround_VC, animated: true) {
            }
        }
    }
    
    func image(view: ImageVW, DidChange image: UIImage) {
        
        self.imgvw_Main.image = image
    }
}

extension Editor_VC: BackGroundVCDelegate {
        
    func backGround(vc: BackGround_VC, ChangeColor color: UIColor) {
        
        let str_Size : String = self.info_Image.str_Size
        let size_Img : CGSize = self.info_Image.original.size
        let img_Main = AppSingletonObj.createImage(color: color, size: size_Img)
        self.info_Image = infoImage(size: str_Size, color: color, image: img_Main, type: ImageType.IMAGE)
        self.imgvw_Main.image = img_Main
    }
}
    
extension Editor_VC: WaterMarkVWDelegate {

    func addNewLogo(view: WaterMarkVW) {
        
        self.openImagePickerType = ImagePickerType.Logo
        AppSingletonObj.openCamera(from: self)
//        let alert = AddLogo()
//        alert.delegate = self
//        alert.show()
    }
    
    func removeLogo(view: WaterMarkVW) {
        
        self.sticker_Logo.logoID = ""
        self.action_UpdateLogo(image: UIImage())
        DataManager.initDB().EXECUTE_Query(query: "Delete From tbl_Logo")
    }
    
    func logo(view: WaterMarkVW, Change logo: UIImage, With id: String) {
     
        self.sticker_Logo.logoID = id
        self.action_UpdateLogo(image: logo)
        self.action_UpdateLogoFrame(image: logo)
    }
    
    func logo(view: WaterMarkVW, DidChange opacity: Float) {
        
        self.sticker_Logo.contentView.alpha = CGFloat(opacity)
    }
}
extension Editor_VC: AddLogoDelegate {
 
    func addLogo(view: AddLogo, Logo type: LogoType) {
        
        if type == LogoType.Photo {
            
            AppSingletonObj.openCamera(from: self)
        }
        else {
            
        }
    }
}

extension Editor_VC: ShapeVWDelegate {
    
    func shape(view: ShapeVW, DidSelect shape: UIImage) {
        
        self.action_AddImage(image: shape, type: LayerType.SHAPE)
    }
    
    func shape(view: ShapeVW, DidChange opacity: Float) {
        
        if (self.sticker_Selected.info as! infoLayer).type == LayerType.SHAPE {
            
            self.sticker_Selected.contentView.alpha = CGFloat(opacity)
        }
    }
}
extension Editor_VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        
        let tocCrop_VC = TOCropViewController(image: image as! UIImage)
        tocCrop_VC.delegate = self
        picker.present(tocCrop_VC, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
extension Editor_VC: TOCropViewControllerDelegate {
 
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
     
        cropViewController.dismiss(animated: false) {
                     
            self.dismiss(animated: true) {
                
                if self.openImagePickerType == ImagePickerType.Logo {
                    
                    self.vw_WaterMark.addNewLogo(image: image)
                }
                else {
                    
                    self.action_AddImage(image: image, type: LayerType.PHOTO)
                }
            }
        }
    }
}
