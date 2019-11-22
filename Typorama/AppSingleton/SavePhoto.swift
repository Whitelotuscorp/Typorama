//
//  SavePhoto.swift
//  Typorama
//
//  Created by Apple on 09/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GPUImage

class SavePhoto: NSObject {

    static var instance: SavePhoto!
    
    class func shared() -> SavePhoto {
        
        self.instance = (self.instance ?? SavePhoto())
        return self.instance
    }
    
    func getNewLayer(layer: infoLayer, info: infoStyle, size: CGSize) -> UIImage {

        let effect =  info.effect
        
        let wdt_Vw : CGFloat = size.width
        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
        
        var ary_Label : [UILabel] = []
        
        let textColor : UIColor = layer.color
        let bgColor : UIColor = info.style == LayerStyle.SOLID ? layer.color : UIColor.clear
        let isClearLabel : Bool = info.style == LayerStyle.SOLID ? true : false
        let x_Gap : CGFloat = info.style == LayerStyle.SOLID ? (wdt_Vw / 30) : 0
        let h_Line : CGFloat = wdt_Vw / (30 * info.lineDiv)
        let w_Border : CGFloat = wdt_Vw / (20 * info.borderDiv)
        
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

        let img_New = AppSingletonObj.image(with: vw_Edit)!
        
        if img_New.size.equalTo(size) {
            
            return img_New
        }
        else {
            
            return self.resizeImage(image: img_New, targetSize: size) //img_New
        }
    }
    

    func getNewShadowLayer(layer: infoLayer, image: UIImage) -> UIImage {
        
        let img_Shadow =  AppSingletonObj.setImageClipMask(image, color: layer.shadow.color)
        
        if layer.shadow.blur > 0 {
            
            return (img_Shadow?.gaussBlur(layer.shadow.blur))!
        }
        else {
                     
            return img_Shadow!
        }
    }
    
    func gaussianBlur(image: UIImage, radius: CGFloat) -> UIImage {

        let gaussianBlur = GaussianBlur()
        gaussianBlur.blurRadiusInPixels = Float(radius)
        
        return image.filterWithOperation(gaussianBlur)
    }
    
    func mergeAllLayer(view: UIView?, With imageview: UIImageView?, completionBlock: @escaping (_ image: UIImage?) -> Void) {
        
        var img_Main = imageview?.image
        
        var muary_AllLayer: [ZDStickerView]? = []
        
        for vw in view!.subviews  {
            
            if vw.isKind(of: ZDStickerView.self) {
                
                muary_AllLayer?.append(vw as! ZDStickerView)
            }
        }
        
        if muary_AllLayer!.count > 0 {
            
            let img_BG = img_Main
            
            let size = img_BG?.size
            UIGraphicsBeginImageContext(size!)
            
            let area_BG = CGRect(x: 0, y: 0, width: size!.width, height: size!.height)
            
            img_BG?.draw(in: area_BG, blendMode: .normal, alpha: 1.0)
            
            for layer in muary_AllLayer! {
                
                let infoL = layer.info as! infoLayer
                
                let transform : CGAffineTransform = layer.transform

                let x_LY: CGFloat = (layer.frame.origin.x * size!.width) / imageview!.frame.size.width
                let y_LY: CGFloat = (layer.frame.origin.y * size!.height) / imageview!.frame.size.height
                let w_LY: CGFloat = (layer.frame.size.width * size!.width) / imageview!.frame.size.width
                let h_LY: CGFloat = (layer.frame.size.height * size!.height) / imageview!.frame.size.height
                
                let area_LY = CGRect(x: x_LY, y: y_LY, width: w_LY, height: h_LY)
                
                let img_LyMain = infoL.image //self.getNewLayer(layer: infoL, info: infoL.style, size: CGSize(width: w_LY, height: h_LY))
                
                if infoL.shadow.isShadow == true {

                    let x_SD: CGFloat = ((layer.frame.origin.x + infoL.shadow.x) * size!.width) / imageview!.frame.size.width
                    let y_SD: CGFloat = ((layer.frame.origin.y + infoL.shadow.y) * size!.height) / imageview!.frame.size.height

                    let area_SD = CGRect(x: x_SD, y: y_SD, width: w_LY, height: h_LY)
                    let img_SDMain = (layer.shadowView as! UIImageView).image //self.getNewShadowLayer(layer: infoL, image: img_LyMain)
                    
                    let img_SD = self.rotateImage(img_SDMain, withTransform: transform)!
                    img_SD.draw(in: area_SD, blendMode: .normal, alpha: infoL.shadow.opacity)
                }
                
                
                let img_LY = self.rotateImage(img_LyMain, withTransform: transform)!
                img_LY.draw(in: area_LY, blendMode: .normal, alpha: 1.0)
                
                img_Main = UIGraphicsGetImageFromCurrentImageContext()
            }
            
            UIGraphicsEndImageContext()
            completionBlock(img_Main)
        }
    }
    
    func radians(_ degrees: Double) -> Double {
        
        return degrees * .pi / 180
    }
    
    func rotateImage(_ image: UIImage?, withTransform transform: CGAffineTransform) -> UIImage? {
        
        var sizeRect = CGRect()
        sizeRect.size = image!.size
        let destRect = sizeRect.applying(transform)
        let destinationSize = destRect.size
        
        let radians = atan2f(Float(transform.b), Float(transform.a))
//        CGFloat degrees = radians * (180 / M_PI);
        
        // Draw image
        UIGraphicsBeginImageContext(destinationSize)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: destinationSize.width / 2.0, y: destinationSize.height / 2.0)
        context?.rotate(by: CGFloat(radians))
        image?.draw(in: CGRect(x: -(image?.size.width ?? 0.0) / 2.0, y: -(image?.size.height ?? 0.0) / 2.0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0))
        
        // Save image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}
