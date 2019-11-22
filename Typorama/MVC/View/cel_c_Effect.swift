//
//  cel_c_Effect.swift
//  Canvas
//
//  Created by Apple on 05/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cel_c_Effect: UICollectionViewCell {
    
    @IBOutlet weak var style: UIView!
    
    var isUpdate : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateLayer(layer: infoStyle, width: CGFloat = 0) {
        
        self.style.subviews.map({ $0.removeFromSuperview() })
        
        let effect =  layer.effect
        
        let wdt_Vw : CGFloat = width == 0 ? self.frame.width - 10 : width
        
        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
        
        var ary_Label : [UILabel] = []
        
        let textColor : UIColor = layer.style == LayerStyle.SOLID ? UIColor.white : UIColor.black
        let fontFamily = layer.fontFamily
        let bgColor : UIColor = layer.style == LayerStyle.SOLID ? UIColor.black : UIColor.clear
        let isClearLabel : Bool = layer.style == LayerStyle.SOLID ? true : false
        let x_Gap : CGFloat = layer.style == LayerStyle.SOLID ? (wdt_Vw / 30) : 0
        let y_Gap : CGFloat = 0
        var h_Line : CGFloat = wdt_Vw / (30 * layer.lineDiv)
        let w_Border : CGFloat = wdt_Vw / (20 * layer.borderDiv)

        h_Line = h_Line > 3 ? 3 : h_Line
        
        var y : CGFloat = w_Border + h_Line
        
        let lbl_Border = UILabel()
        lbl_Border.clipsToBounds = true
        lbl_Border.layer.borderColor = layer.style == LayerStyle.LEFT ? UIColor.clear.cgColor : UIColor.black.cgColor
        lbl_Border.layer.borderWidth = effect.isBorder == true ? w_Border : 0
        vw_Edit.addSubview(lbl_Border)
        ary_Label.append(lbl_Border)
        
        var fl_pd : CGFloat = 0
        var maxStrFont : Int = 10
        
        if layer.style == LayerStyle.LEFT {
            
            let max = effect.texts.max(by: {$1.text.count > $0.text.count})
            let w_Label = wdt_Vw - ((w_Border + h_Line) * 2)
            var sz_Add : CGSize = CGSize(width: w_Label, height: h_Line)
            
            maxStrFont = Int(1.9 * wdt_Vw / CGFloat(max!.text.count))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            var attrs = [NSAttributedString.Key.font: UIFont(name: fontFamily, size: CGFloat(maxStrFont)) as Any,
                         NSAttributedString.Key.foregroundColor : textColor,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.kern : NSNumber(value: Float(layer.charcterSpacing))]
            
            let string = max!.text
                        
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
            
            let w_Label = wdt_Vw - ((w_Border + h_Line) * 2)
            var sz_Add : CGSize = CGSize(width: w_Label, height: h_Line)
            
            let lbl_Edit = PaddingLabel(frame: CGRect(x: w_Border + h_Line, y: y, width: w_Label, height: CGFloat.greatestFiniteMagnitude))
            vw_Edit.addSubview(lbl_Edit)
            
            let divFont : CGFloat = info.text.count > 3 ? 2 : CGFloat(Double(info.text.count) * Double(0.5))
            var largestFontSize: CGFloat = wdt_Vw / CGFloat(divFont)
            
            if layer.style == LayerStyle.LEFT {
                
                largestFontSize = CGFloat(maxStrFont)
            }
            
            lbl_Edit.text = info.text
            lbl_Edit.font = UIFont(name: fontFamily, size: largestFontSize)
            lbl_Edit.numberOfLines = 1
            lbl_Edit.minimumScaleFactor = 0.01
            lbl_Edit.lineBreakMode = .byWordWrapping
            lbl_Edit.textAlignment = layer.textAlignment // == LayerStyle.LEFT ? .left : .center
            lbl_Edit.adjustsFontSizeToFitWidth = true
            lbl_Edit.textColor = textColor
            
            let attributedString = NSMutableAttributedString(attributedString: lbl_Edit.attributedText!)

            attributedString.addAttributes([NSAttributedString.Key.kern : NSNumber(value: Float(layer.charcterSpacing))],
                                           range: NSRange(location: 0, length: lbl_Edit.text!.count))
            
            lbl_Edit.attributedText = attributedString
            var h_LabelU : CGFloat = 0
            var pd : CGFloat = 0
            
            if info.isLine == true {
                
                h_LabelU = 0
                lbl_Edit.backgroundColor = textColor
                sz_Add = CGSize(width: w_Label, height: h_Line)
            }
            else if layer.style != LayerStyle.LEFT {
                
                var w_LabelU = w_Label
                
                if isClearLabel == true {
                    
                    h_LabelU = 3
                    w_LabelU = w_Label - 10
                }
                
                while(lbl_Edit.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width > w_LabelU){
                    
                    largestFontSize -= 0.50
                    if largestFontSize < 3 {
                        
                        largestFontSize = 2.5
                        break
                    }
                    lbl_Edit.font = UIFont(name: lbl_Edit.font.fontName, size: largestFontSize)
                }
                
                lbl_Edit.backgroundColor = bgColor
                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_LabelU, height: CGFloat.greatestFiniteMagnitude))

                if sz_Add.width != w_LabelU {
                    
                    var charcterSpacing = layer.charcterSpacing
                    while(lbl_Edit.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width < w_LabelU){
                        
                        if sz_Add.width < w_LabelU {
                            
                            charcterSpacing += 0.05
                        }

                        
                        let attributedString = NSMutableAttributedString(attributedString: lbl_Edit.attributedText!)
                        
                        attributedString.addAttributes([NSAttributedString.Key.kern : NSNumber(value: Float(charcterSpacing))],
                                                       range: NSRange(location: 0, length: lbl_Edit.text!.count))
                        
                        lbl_Edit.attributedText = attributedString
                        sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_LabelU, height: CGFloat.greatestFiniteMagnitude))

                        if lbl_Edit.frame.width > w_LabelU {
                            
                            break
                        }
                    }
                }
                
                pd = -largestFontSize / 8
                
                lbl_Edit.topInset = pd
                lbl_Edit.bottomInset = pd
                
                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_LabelU, height: CGFloat.greatestFiniteMagnitude))
            }
            else {
                
                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: w_Label, height: CGFloat.greatestFiniteMagnitude))
            }
            
            if fl_pd == 0 && isClearLabel == false {
                
                fl_pd = pd
            }
            
            if info.isLine == true || isClearLabel == true {
                
                pd = 0
                let ln_pd : CGFloat = info.isLine == true ? 1 : 0
                lbl_Edit.frame = CGRect(x: w_Border + h_Line, y: y + ln_pd, width: w_Label, height: sz_Add.height + h_LabelU)
            }
            else {
                
                lbl_Edit.frame = CGRect(x: w_Border + h_Line, y: y + pd, width: w_Label, height: sz_Add.height + h_LabelU)
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
                
                ary_Label.append(objCTLbl)
            }
            else {
                
                yClearLabel = 0
                ary_Label.append(lbl_Edit)
            }
            
            y = y + lbl_Edit.frame.height + x_Gap + y_Gap + pd - yClearLabel
        }
        
        var rect = vw_Edit.frame
        rect.size.height = y + w_Border + h_Line - x_Gap
        vw_Edit.frame = rect
        lbl_Border.frame = rect
        
        let frame_Text = CGRect(x: 0, y: 0, width: vw_Edit.frame.width, height: vw_Edit.frame.height)
        
        self.style.frame = frame_Text
        self.style.addSubview(vw_Edit)
        self.style.center = self.contentView.center
        
        if self.frame.height < frame_Text.height && width == 0 {
            
            let wdt_Reduce = (self.frame.height * frame_Text.width) / frame_Text.height
            self.updateLayer(layer: layer, width: wdt_Reduce - 10)
        }
    }
//    {
//
//        self.style.subviews.map({ $0.removeFromSuperview() })
//
//        let effect =  layer.effects[0]
//
//        let wdt_Gap : CGFloat = 9
//        let wdt_Vw : CGFloat = self.style.frame.width - wdt_Gap * 2
//        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw + wdt_Gap * 2, height: CGFloat.greatestFiniteMagnitude))
//
//        var y : CGFloat = wdt_Gap
//        var ary_Label : [UILabel] = []
//
//        let lbl_Border = UILabel()
//        lbl_Border.clipsToBounds = true
//        lbl_Border.layer.borderWidth = effect.isBorder == true ? 3 : 0
//        vw_Edit.addSubview(lbl_Border)
//        ary_Label.append(lbl_Border)
//
//        let textColor : UIColor = layer.style == LayerStyle.SOLID ? UIColor.white : UIColor.black
//        let bgColor : UIColor = layer.style == LayerStyle.SOLID ? UIColor.black : UIColor.clear
//        let x_Gap : CGFloat = layer.style == LayerStyle.SOLID ? 3 : 0
//
//        for info in effect.texts {
//
//            let lbl_Edit = UILabel()
//
//            var largestFontSize: CGFloat = 30
//            lbl_Edit.text = info.text.uppercased()
//            lbl_Edit.font = UIFont(name: "Futura-Bold", size: largestFontSize)
//            lbl_Edit.numberOfLines = 1
//            lbl_Edit.minimumScaleFactor = 0.01
//            lbl_Edit.lineBreakMode = .byWordWrapping
//            lbl_Edit.textAlignment = .center
//            lbl_Edit.adjustsFontSizeToFitWidth = true
//            lbl_Edit.textColor = textColor
//
//            var sz_Add : CGSize = CGSize(width: wdt_Vw, height: 3)
//            if info.isLine == true {
//
//                lbl_Edit.backgroundColor = textColor
//                sz_Add = CGSize(width: wdt_Vw, height: 3)
//
//            }
//            else {
//
//                while(lbl_Edit.sizeThatFits(CGSize(width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude)).width > wdt_Vw){
//
//                    largestFontSize -= 1
//                    lbl_Edit.font = UIFont(name: lbl_Edit.font.fontName, size: largestFontSize)
//                }
//
//                lbl_Edit.backgroundColor = bgColor
//                sz_Add = lbl_Edit.sizeThatFits(CGSize(width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
//            }
//
//
//            lbl_Edit.frame = CGRect(x: wdt_Gap - x_Gap, y: y - x_Gap, width: wdt_Vw + x_Gap * 2, height: sz_Add.height)
//            vw_Edit.addSubview(lbl_Edit)
//
//            ary_Label.append(lbl_Edit)
//
//            y = y + lbl_Edit.frame.height + x_Gap
//        }
//
//
//        var rect = vw_Edit.frame
//        rect.size.height = y + wdt_Gap - x_Gap * 3
//        vw_Edit.frame = rect
//        lbl_Border.frame = rect
//
//        let frame_Text = CGRect(x: 0, y: 0, width: vw_Edit.frame.width, height: vw_Edit.frame.height)
//
//        self.style.frame = frame_Text
//        self.style.addSubview(vw_Edit)
//        self.style.center = self.contentView.center
//    }
}
