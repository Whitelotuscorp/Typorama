
//
//  Editor_VC.swift
//  Typorama
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GPUImage

class Editor_VC: UIViewController {

    @IBOutlet weak var vw_Tab: UIView!
    @IBOutlet weak var vw_Editor: UIView!
    @IBOutlet weak var vw_Canvas: UIView!
    
    @IBOutlet weak var imgvw_Canvas: UIImageView!
    @IBOutlet weak var imgvw_Main: UIImageView!
    
    @IBOutlet weak var vw_Text: TextVW!
    @IBOutlet weak var vw_Image: ImageVW!
    @IBOutlet weak var vw_WaterMark: WaterMarkVW!
    @IBOutlet weak var vw_GoPro: UIView!
    
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
    
    var info_Image : infoImage = infoImage()
    
    var sticker_Selected : ZDStickerView = ZDStickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.vw_GoPro.backgroundColor = COLOR_GrayL210
        
        self.action_SelectTab(self.btn_Text)
        
        self.vw_Canvas.backgroundColor = .clear
        self.vw_Canvas.clipsToBounds = true
        
        self.imgvw_Main.image = self.info_Image.getImage(size: self.vw_Editor.frame.size)
        
        self.vw_Text.delegate = self
        
        self.updateManuallyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.updateConstraints()
        self.action_AddSticker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for vw in self.vw_Canvas.subviews {
            
            if(vw.isKind(of: ZDStickerView.self)) {
                
                (vw as! ZDStickerView).hideEditingHandles()
            }
        }
    }
    
    func updateManuallyConstraints() {
        
        let sz_Image = self.imgvw_Main.image?.size
        
        var w_Can : CGFloat = self.vw_Editor.frame.width
        var h_Can : CGFloat = self.vw_Editor.frame.height
        
        if CGFloat(sz_Image!.width) > CGFloat(sz_Image!.height) {
            
            h_Can = (w_Can * sz_Image!.height) / sz_Image!.width
        }
        else {
         
            w_Can = (h_Can * sz_Image!.width) / sz_Image!.height
        }
        
        self.lyl_w_Canvas.constant = w_Can
        self.lyl_h_Canvas.constant = h_Can
        
        self.view.updateConstraintsIfNeeded()
    }
    
    @IBAction func action_Back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Share(_ sender: UIButton) {
        
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
        self.vw_GoPro.isHidden = true
        
        if sender == self.btn_Text {
            
            self.vw_Text.isHidden = false
        }
        else if sender == self.btn_Image {
            
            self.vw_Image.isHidden = false
        }
        else if sender == self.btn_WaterMark {
            
            self.vw_WaterMark.isHidden = false
        }
        else {
            
            self.vw_GoPro.isHidden = false
        }
        
        self.lyl_l_SelMenu.constant = sender.superview!.frame.origin.x
        self.view.updateConstraintsIfNeeded()
    }
    
    @IBAction func action_AddNewSticker(_ sender: UIButton) {
        
        self.action_AddSticker()
    }
    
    func action_AddSticker() {
        
        self.sticker_Selected.hideEditingHandles()
        
        let vw_Add = UIImageView(frame: CGRect(x: 2, y: 2, width: self.vw_Editor.frame.width / 2, height: 4))
        
        let layer_Text = ZDStickerView(frame: CGRect(x: 2, y: 2, width: vw_Add.frame.width, height: vw_Add.frame.height))
        layer_Text.stickerViewDelegate = self
        layer_Text.info = infoLayer()
        layer_Text.contentView = vw_Add
        layer_Text.preventsPositionOutsideSuperview = false
        layer_Text.translucencySticker = false
        layer_Text.borderWidth = 3.0
        layer_Text.borderColor = .darkGray
        layer_Text.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        self.vw_Canvas.addSubview(layer_Text)
        layer_Text.center = CGPoint(x: self.vw_Canvas.frame.width / 2, y: self.vw_Canvas.frame.height / 2)

        layer_Text.hideEditingHandles()
        self.sticker_Selected = layer_Text;
        self.vw_Text.addNewSticker()
    }
    
    func updateLayer(layer: ZDStickerView, info: infoStyle, isAnimate: Bool = true) {
        
        layer.hideEditingHandles()
        (layer.info as! infoLayer).style = info
        
        let transform : CGAffineTransform = layer.transform
        layer.transform = CGAffineTransform.identity
        
        
        let center_Point : CGPoint = layer.center
        
        let effect =  info.effects[info.index]
        
        let wdt_Vw : CGFloat = layer.bounds.width
        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
        
        var ary_Label : [UILabel] = []
        
        let textColor : UIColor = (layer.info as! infoLayer).color
        let bgColor : UIColor = info.style == LayerStyle.SOLID ? (layer.info as! infoLayer).color : UIColor.clear
        let isClearLabel : Bool = info.style == LayerStyle.SOLID ? true : false
        let x_Gap : CGFloat = info.style == LayerStyle.SOLID ? (wdt_Vw / 30) : 0
        let h_Line : CGFloat = wdt_Vw / 30
        let w_Border : CGFloat = wdt_Vw / 20
        
        var y : CGFloat = w_Border + h_Line
        
        let lbl_Border = UILabel()
        lbl_Border.clipsToBounds = true
        lbl_Border.layer.borderColor = textColor.cgColor
        lbl_Border.layer.borderWidth = effect.isBorder == true ? w_Border : 0
        vw_Edit.addSubview(lbl_Border)
        ary_Label.append(lbl_Border)
        
        for info in effect.texts {
            
            let lbl_Edit = UILabel()
            
            var largestFontSize: CGFloat = wdt_Vw / 2
            lbl_Edit.text = info.text.uppercased()
            lbl_Edit.font = UIFont(name: "Futura-Bold", size: largestFontSize)
            lbl_Edit.numberOfLines = 1
            lbl_Edit.minimumScaleFactor = 0.01
            lbl_Edit.lineBreakMode = .byWordWrapping
            lbl_Edit.textAlignment = .center
            lbl_Edit.adjustsFontSizeToFitWidth = true
            lbl_Edit.textColor = textColor
            
            let w_Label = wdt_Vw - ((w_Border + h_Line) * 2)
            
            var sz_Add : CGSize = CGSize(width: w_Label, height: h_Line)
            if info.isLine == true {
                
                lbl_Edit.backgroundColor = textColor
                sz_Add = CGSize(width: w_Label, height: h_Line)
                
            }
            else {
                
                while(lbl_Edit.sizeThatFits(CGSize(width: w_Label, height: CGFloat.greatestFiniteMagnitude)).width > w_Label){
                    
                    largestFontSize -= 1
                    lbl_Edit.font = UIFont(name: lbl_Edit.font.fontName, size: largestFontSize)
                }
                
                lbl_Edit.backgroundColor = bgColor
                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_Label, height: CGFloat.greatestFiniteMagnitude))
                lbl_Edit.font = UIFont(name: lbl_Edit.font.fontName, size: largestFontSize-1)
            }
            
            
            lbl_Edit.frame = CGRect(x: w_Border + h_Line, y: y, width: w_Label, height: sz_Add.height)
            
            if isClearLabel == true && info.isLine != true {
                
                let objCTLbl = RSMaskedLabel(frame: lbl_Edit.frame)
                vw_Edit.addSubview(objCTLbl)
                
                objCTLbl.text = info.text.uppercased()
                objCTLbl.font = lbl_Edit.font
                objCTLbl.backgroundColor = bgColor                
                objCTLbl.numberOfLines = 1
                objCTLbl.minimumScaleFactor = 0.01
                objCTLbl.lineBreakMode = .byWordWrapping
                objCTLbl.textAlignment = .center
                objCTLbl.adjustsFontSizeToFitWidth = true
                
                ary_Label.append(objCTLbl)
            }
            else {
                
                vw_Edit.addSubview(lbl_Edit)
                
                ary_Label.append(lbl_Edit)
            }
            
            
            y = y + lbl_Edit.frame.height + x_Gap
        }        
        
        var rect = vw_Edit.frame
        rect.size.height = y + w_Border + h_Line - x_Gap
        vw_Edit.frame = rect
        lbl_Border.frame = rect
        
        let frame_Text = CGRect(x: (self.vw_Canvas.frame.width - vw_Edit.frame.width) / 2, y: (self.vw_Canvas.frame.height - vw_Edit.frame.height) / 2, width: vw_Edit.frame.width, height: vw_Edit.frame.height)
        
        let img_Content = AppSingletonObj.image(with: vw_Edit)
        
        layer.frame = frame_Text
        layer.contentView = vw_Edit
        layer.shadowView = UIView()
        layer.center = center_Point
        layer.transform = transform
        
        if isAnimate == true {
         
            for i in 0 ..< ary_Label.count {
                
                let lbl = ary_Label[i]
                lbl.alpha = 0.0
                lbl.transform = CGAffineTransform(scaleX: 3, y: 3)
                UIView.animate(withDuration: 0.23, delay: 0.1 * Double(i), options: .curveEaseOut, animations: {
                    lbl.transform = CGAffineTransform.identity
                    lbl.alpha = 1.0
                }) { finished in
                    
                    self.setLayerContent(image: img_Content!, On: layer)                    
                }
            }
        }
        else {
            
            self.setLayerContent(image: img_Content!, On: layer)
        }
    }
    
    func setLayerContent(image: UIImage, On layer: ZDStickerView) {
        
        (self.sticker_Selected.info as! infoLayer).image = image
        let imgvw_Con = UIImageView(image: image)
        layer.contentView = imgvw_Con
        let imgvw_Shadow = UIImageView(image: image)
        layer.shadowView = imgvw_Shadow
        
        self.updateShadowValueColor(layer: layer)
        self.updateShadowValue(layer: layer)
    }
    
    func updateShadowValue(layer: ZDStickerView) {
        
        var frame = layer.shadowView.frame
        frame.origin.x = 10 + (layer.info as! infoLayer).shadow.x
        frame.origin.y = 10 + (layer.info as! infoLayer).shadow.y
        layer.shadowView.frame = frame
        layer.shadowView.alpha = (layer.info as! infoLayer).shadow.opacity
    }
    
    func updateShadowValueColor(layer: ZDStickerView) {
        
        let img_Shadow =  AppSingletonObj.setImageClipMask((layer.info as! infoLayer).image, color: (layer.info as! infoLayer).shadow.color)
        
        (layer.shadowView as! UIImageView).image = img_Shadow
        
        if (layer.info as! infoLayer).shadow.blur > 0 {
            
//            (layer.shadowView as! UIImageView).image = self.gaussianBlur(image: img_Shadow!, radius: (layer.info as! infoLayer).shadow.blur*20)
//            (layer.shadowView as! UIImageView).image = img_Shadow?.blurred(radius: (layer.info as! infoLayer).shadow.blur*15)
            (layer.shadowView as! UIImageView).image = img_Shadow?.gaussBlur((layer.info as! infoLayer).shadow.blur)
        }
    }
    
    func gaussianBlur(image: UIImage, radius: CGFloat) -> UIImage {
        
//        let gaussianImage = GPUImagePicture(image: image)
        let gaussianBlur = GPUImageGaussianBlurFilter()
        gaussianBlur.blurRadiusInPixels = radius
//        gaussianImage?.addTarget(gaussianBlur)
//        gaussianBlur.useNextFrameForImageCapture()
//        gaussianImage?.processImage()
//        let gaussianOutput = gaussianBlur.imageFromCurrentFramebuffer()
        
//        return gaussianOutput!
        return gaussianBlur.image(byFilteringImage: image)
    }
}

extension Editor_VC: ZDStickerViewDelegate {
    
    func stickerViewDidBeginEditing(_ sticker: ZDStickerView!) {
        
        self.sticker_Selected.hideEditingHandles()
        self.sticker_Selected = sticker;
        self.sticker_Selected.showEditingHandles()
        
        self.vw_Text.layerDidBeginEditing(sticker: self.sticker_Selected)
    }
    
    func stickerViewDidEndEditing(_ sticker: ZDStickerView!) {
        
    }
    
    func stickerViewDidCancelEditing(_ sticker: ZDStickerView!) {
        
    }
    
    func stickerViewDidClose(_ sticker: ZDStickerView!) {
        
    }
    
    func stickerViewDidCustomButtonTap(_ sticker: ZDStickerView!) {
        
    }
}

extension Editor_VC: TextVWDelegate {
    
    func text(view: TextVW, changeStyle style: infoStyle) {
     
        self.updateLayer(layer: self.sticker_Selected, info: style)
    }
    
    func text(view: TextVW, changeColor color: UIColor) {
        
        (self.sticker_Selected.info as! infoLayer).color = color
        self.updateLayer(layer: self.sticker_Selected, info: (self.sticker_Selected.info as! infoLayer).style, isAnimate: false)
    }
    
    func text(view: TextVW, ChangeShadow value: Any, With type: ShadowValue) {
        
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
