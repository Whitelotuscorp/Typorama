
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

        let share = ShareView()
        share.delegate = self
        share.show()
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
            AppSingletonObj.setViewAnimation(view: self.vw_Text, hidden: false)
        }
        else if sender == self.btn_Image {
            
            self.updateUserInteractionEnabled(type: LayerType.PHOTO)
            AppSingletonObj.setViewAnimation(view: self.vw_Image, hidden: false)
        }
        else if sender == self.btn_WaterMark {
            
            self.updateUserInteractionEnabled(type: LayerType.LOGO)
            AppSingletonObj.setViewAnimation(view: self.vw_WaterMark, hidden: false)
        }
        else {
            
            self.updateUserInteractionEnabled(type: LayerType.SHAPE)
            AppSingletonObj.setViewAnimation(view: self.vw_Shape, hidden: false)
        }
        
        self.lyl_l_SelMenu.constant = sender.superview!.frame.origin.x
        self.view.updateConstraintsIfNeeded()
    }
    
    @IBAction func action_AddNewSticker(_ sender: UIButton) {
        
        self.action_SelectTab(self.btn_Text)
        self.vw_Text.action_SelectMenu(menu: TextMenu.Styles)
        self.action_AddSticker()
    }
    
    @objc func action_AddLogo() {
            
        self.sticker_Selected.hideEditingHandles()
            
        let textColor = self.info_Image.color.isEqual(UIColor.black) ? UIColor.white : UIColor.black
        let infoL = infoLayer(color: textColor, text: "")
        infoL.type = LayerType.LOGO
        infoL.main = UIImage()
        infoL.image = UIImage()
        
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
        layer.contentView.backgroundColor = .clear
        
        let center_Point : CGPoint = layer.center
        
        let effect =  infoS.effect
        let wdt_Vw : CGFloat = width == 0 ? (self.vw_Editor.frame.width / 2) + 20 : width
        
        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
        
        var ary_Label : [UIView] = []
        
        let fontFamily = infoS.fontFamily
        
        let textColor : UIColor = (layer.info as! infoLayer).color
                
        var maxStrCount : Int = 20
        
        let multiplier      : CGFloat = 5.0
        var firstline_peding: CGFloat = 0
        let padding         : CGFloat = 15
        
        let x_Gap : CGFloat = infoS.style == LayerStyle.SOLID ? (wdt_Vw / 30) : 0
        let y_Gap : CGFloat = infoS.lineSpacing
        
        let w_Border : CGFloat = wdt_Vw / (20 * infoS.borderDiv)
        var h_Line   : CGFloat = wdt_Vw / (30 * infoS.lineDiv)
        h_Line = h_Line > 5 ? 5 : h_Line
                
        var y : CGFloat = w_Border + h_Line + padding
        let x : CGFloat = w_Border + h_Line + padding
        
        let isClearLabel : Bool = infoS.style == LayerStyle.SOLID ? true : false
        var isPrevLine : Bool = false
        
        let imgvw_Border = UIImageView()
        imgvw_Border.contentMode = .scaleAspectFit
        vw_Edit.addSubview(imgvw_Border)
        ary_Label.append(imgvw_Border)
        
        if infoS.isJustifiedText == false {
            
            let max = effect.texts.max(by: {$1.text.count > $0.text.count})
            maxStrCount = (infoS.preText + max!.text + infoS.postText).count
        }
        
        for info in effect.texts {
            
            let str_Text = (infoS.preText + info.text + infoS.postText).uppercased()
            
            let w_Label = wdt_Vw - ((w_Border + h_Line + padding) * 2)
            var sz_Add : CGSize = CGSize(width: w_Label, height: h_Line)
                
            let divFont     : CGFloat = isClearLabel == true ? 2.0 : 2.1
            var h_LabelU    : CGFloat = 0
            var font_pedding: CGFloat = 0
            
            var largestFontSize: CGFloat = 20
            
            if infoS.isJustifiedText == false {
                
                largestFontSize = divFont * wdt_Vw / CGFloat(maxStrCount)
            }
            else if (info.isLine == false || info.text.count > 0) {
                
                largestFontSize = divFont * wdt_Vw / CGFloat(str_Text.count)
            }
                        
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.alignment = infoS.textAlignment
            
            var dict_Attributes = [NSAttributedString.Key.font : UIFont(name: fontFamily, size: largestFontSize * multiplier) as Any,
                         NSAttributedString.Key.foregroundColor : textColor,
//                         NSAttributedString.Key.paragraphStyle : paragraphStyle,
                         NSAttributedString.Key.kern : NSNumber(value: Float(infoS.charcterSpacing))]
                        
            if info.isLine == true {
                
                h_LabelU = 0
                sz_Add = CGSize(width: w_Label * multiplier, height: h_Line * multiplier)
            }
            else {
         
                sz_Add = (str_Text as NSString).size(withAttributes: dict_Attributes)
                font_pedding = CGFloat(-(largestFontSize / 10))
            }
            
            if firstline_peding == 0 && isClearLabel == false {
                
                firstline_peding = font_pedding
            }
            
            var yClearLabel : CGFloat = 0
            var img : UIImage = UIImage()
            
            if isClearLabel == true && info.isLine != true {
                
                dict_Attributes[.font] = UIFont(name: fontFamily, size: largestFontSize * multiplier / 1.6)
                img = AppSingletonObj.textMaskedImage(size: sz_Add, text: str_Text, attributes: dict_Attributes)!
                yClearLabel = 0;
            }
            else {                
                
                if info.isLine == true {
                    
                    img = AppSingletonObj.createImage(color: textColor, size: sz_Add)
                }
                else {
                    
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: sz_Add.width + infoS.rightInset, height: sz_Add.height + (font_pedding * 2)))
                    img = renderer.image { ctx in
                        
                        str_Text.draw(with: CGRect(x: 0, y: font_pedding, width: sz_Add.width + infoS.rightInset, height: sz_Add.height), options: .usesLineFragmentOrigin, attributes: dict_Attributes, context: nil)
                    }
                }
                
                yClearLabel = -3
            }
            
            sz_Add = img.size
            
            let ln_PrevLine : CGFloat = isPrevLine == true ? 2 : 0
            var newRect = CGRect.zero
            if info.isLine == true || isClearLabel == true {
                
                font_pedding = 0
                let ln_pd : CGFloat = info.isLine == true ? 2 : 0
                newRect = CGRect(x: x, y: y + ln_pd, width: w_Label, height: (sz_Add.height / multiplier) + h_LabelU)
            }
            else if infoS.isJustifiedText == true {
                
                newRect = CGRect(x: x, y: y + font_pedding + ln_PrevLine, width: w_Label, height: (sz_Add.height / multiplier) + h_LabelU + (font_pedding * 2))
            }
            else {
                
                var newX : CGFloat = x
                var newW = (sz_Add.width / multiplier)
                var newH = (sz_Add.height / multiplier)
                
                if w_Label < newW {
                    
                    newW = w_Label
                    newH = (w_Label * newH) / newW
                }
                
                if infoS.textAlignment == .center {
                    
                    newX = x + (w_Label - newW) / 2
                }
                else if infoS.textAlignment == .right {
                    
                    newX = x + (w_Label - newW)
                }
                
                newRect = CGRect(x: newX, y: y + font_pedding + ln_PrevLine, width: newW, height: newH + h_LabelU + (font_pedding * 2))
            }
            
            
            let imgvw_Con = UIImageView(image: img)
            imgvw_Con.frame = newRect
            imgvw_Con.contentMode = .redraw
            vw_Edit.addSubview(imgvw_Con)
            ary_Label.append(imgvw_Con)
            
            isPrevLine = info.isLine
            
            y = y + newRect.height + x_Gap + y_Gap + font_pedding - yClearLabel
        }
        
        var rect = vw_Edit.frame
        rect.size.height = y + w_Border + h_Line + padding - y_Gap - x_Gap //- fl_pd
        vw_Edit.frame = rect
        imgvw_Border.frame = CGRect(x: padding, y: padding, width: rect.width - padding * 2, height: rect.height - padding * 2)
        
        let frame_Text = CGRect(x: (self.vw_Canvas.frame.width - vw_Edit.frame.width) / 2, y: (self.vw_Canvas.frame.height - vw_Edit.frame.height) / 2, width: vw_Edit.frame.width, height: vw_Edit.frame.height)
        
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
        
        if effect.isBorder == true && infoS.style == LayerStyle.ONELASTSMILE {
         
            var white : CGFloat = 0
            textColor.getWhite(&white, alpha: nil)
            imgvw_Border.backgroundColor = white >= 0.5 ? .black : .white
        }
        else if effect.isBorder == true {
         
            imgvw_Border.image = AppSingletonObj.drawRectangle(size: CGSize(width: imgvw_Border.frame.width * multiplier, height: imgvw_Border.frame.height * multiplier), WithLine: w_Border * multiplier, color: textColor)
        }
        
        var img_Content = AppSingletonObj.image(with: vw_Edit)
        SavePhoto.shared().mergeViewLayer(view: vw_Edit, With: multiplier) { (image) in
            
            img_Content = image
        }
        
        
        if isAnimate == true {
            
            for i in 0 ..< ary_Label.count {
                
                let lbl = ary_Label[i]
                lbl.alpha = 0.0
                lbl.transform = CGAffineTransform(scaleX: 2, y: 2)
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
    func recursiveAnimation(ary_Label: [UIView], index: Int, Handler:@escaping (_ index: Int) -> Void){
        
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
        self.updateContentBackGround(layer: layer)
        
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
            (layer.info as! infoLayer).image = img_Main!
            (layer.contentView as! UIImageView).image = img_Main
        }
        else {
            
            (layer.contentView as! UIImageView).image = infoLL.main
            (layer.info as! infoLayer).image = infoLL.main
        }
        
        self.updateContentBackGround(layer: layer)
    }
    
    func updateContentBackGround(layer: ZDStickerView) {
        
        let infoS =  (layer.info as! infoLayer).style
        let effect =  infoS.effect
        
        if effect.isBorder == true && infoS.style == LayerStyle.ONELASTSMILE {
            
            let textColor : UIColor = (layer.info as! infoLayer).color
            var white : CGFloat = 0
            textColor.getWhite(&white, alpha: nil)
            
            let imageBg = AppSingletonObj.setBackGroundColor((layer.info as! infoLayer).image, color: white >= 0.5 ? .black : .white)
            (layer.info as! infoLayer).image = imageBg!
            (layer.contentView as! UIImageView).image = imageBg
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
        
        self.vw_Text.action_SelectMenu(menu: TextMenu.Styles)
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
    
    func stickerView(_ sticker: ZDStickerView!, eraseImage image: UIImage!) {
        
        (sticker.info as! infoLayer).image = image
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
    
    func text(view: TextVW, shouldEraser isEnable: Bool) {
        
        for vw in self.vw_Canvas.subviews {
            
            if(vw.isKind(of: ZDStickerView.self)) {
                                
                (vw as! ZDStickerView).allowDragging = !isEnable
            }
        }
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
                    
                    self.vw_WaterMark.addNewLogo(image: AppSingletonObj.setPaddingImage(image, padding: 20)!)
                }
                else {
                    
                    self.action_AddImage(image: AppSingletonObj.setPaddingImage(image, padding: 20)!, type: LayerType.PHOTO)
                }
            }
        }
    }
}

extension Editor_VC: ShareViewDelegate {
    
    func shareView(view: ShareView, DidSelectAt type: ShareType) {
        
//        let img_Content = AppSingletonObj.image(with: self.vw_Canvas)
        AppSingletonObj.manageMBProgress(isShow: true)
        self.hideLayerAllHander()
        SavePhoto.shared().mergeAllLayer(view: self.vw_Canvas, With: self.imgvw_Main) { (image) in
            
            AppSingletonObj.manageMBProgress(isShow: false)
            SocialSharing.shared().shareImage(image: image!, With: type, delegate: self)
        }
    }
}

extension Editor_VC: SocialSharingDelegate {
    
    func socialShare(type: ShareType, success: Bool, error: Error?) {
        
        
    }
}
