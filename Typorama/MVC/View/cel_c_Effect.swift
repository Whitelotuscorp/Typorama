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

    func updateLayer(layer: infoStyle) {
        
        self.style.subviews.map({ $0.removeFromSuperview() })
        
        let effect =  layer.effect
        
        let wdt_Vw : CGFloat = self.style.frame.width
        let vw_Edit = UIView(frame: CGRect(x: 0, y: 0, width: wdt_Vw, height: CGFloat.greatestFiniteMagnitude))
        
        var ary_Label : [UILabel] = []
        
        let textColor : UIColor = layer.style == LayerStyle.SOLID ? UIColor.white : UIColor.black
        let bgColor : UIColor = layer.style == LayerStyle.SOLID ? UIColor.black : UIColor.clear
        let isClearLabel : Bool = layer.style == LayerStyle.SOLID ? true : false
        let x_Gap : CGFloat = layer.style == LayerStyle.SOLID ? (wdt_Vw / 30) : 0
        let h_Line : CGFloat = wdt_Vw / (30 * layer.lineDiv)
        let w_Border : CGFloat = wdt_Vw / (20 * layer.borderDiv)
        
        var y : CGFloat = w_Border + h_Line
        
        let lbl_Border = UILabel()
        lbl_Border.clipsToBounds = true
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
            }
            
            
            lbl_Edit.frame = CGRect(x: w_Border + h_Line, y: y, width: w_Label, height: sz_Add.height)
            
            var yClearLabel : CGFloat = 0
            if isClearLabel == true && info.isLine != true {
                
                yClearLabel = lbl_Edit.frame.height / 10;
                
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
                
                yClearLabel = 0
                vw_Edit.addSubview(lbl_Edit)
                ary_Label.append(lbl_Edit)
            }            
            
            y = y + lbl_Edit.frame.height + x_Gap - yClearLabel
        }
        
        var rect = vw_Edit.frame
        rect.size.height = y + w_Border + h_Line - x_Gap
        vw_Edit.frame = rect
        lbl_Border.frame = rect
        
        let frame_Text = CGRect(x: 0, y: 0, width: vw_Edit.frame.width, height: vw_Edit.frame.height)
        
        self.style.frame = frame_Text
        self.style.addSubview(vw_Edit)
        self.style.center = self.contentView.center
        
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
