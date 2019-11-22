//
//  TextProperty.swift
//  Typorama
//
//  Created by Apple on 08/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TextProperty: NSObject {
    
    class func preText(style: LayerStyle) -> String {
        
        let ary_Style : [LayerStyle] = []
        if ary_Style.contains(style) {
            
            return ""
        }
        return ""
    }
    
    class func postText(style: LayerStyle) -> String {
        
        let ary_Style : [LayerStyle] = [.FASTRUNNER]
        if ary_Style.contains(style) {
            
            return " \u{200c}"
        }
        return ""
    }
    
    class func widthDiv(style: LayerStyle) -> CGFloat {
        
        let ary_Style : [LayerStyle] = [.SKYSCRAPPERTHIN]
        if ary_Style.contains(style) {
            
            return CGFloat(AppSingletonObj.randomNumber(min: 5, max: 10))
        }
        else {
            
            return CGFloat(AppSingletonObj.randomNumber(min: 1, max: 5))
        }
    }
    
    class func isBorder(style: LayerStyle) -> Bool {
        
        let ary_Style : [LayerStyle] = [.SOLID, .NONE, .ONELASTSMILE]
        if ary_Style.contains(style) {
            
            return Bool.random()
        }
        
        return false
    }
    
    class func isLine(style: LayerStyle) -> Bool {
        
        let ary_Style : [LayerStyle] = [.NONE, .SKYSCRAPPERTHIN, .SKYSCRAPPERBOLD, .PHOTOGRAPH]
        if ary_Style.contains(style) {
            
            return Bool.random()
        }
        
        return false
    }
    
    class func textAlignment(style: LayerStyle, align: NSTextAlignment) -> NSTextAlignment {
        
        let ary_Style : [LayerStyle] = [.ONELASTSMILE, .LETTERGAME, .FASTRUNNER, .SKYSCRAPPERTHIN, .SKYSCRAPPERBOLD, .PHOTOGRAPH, .LOKICOLA]
        if ary_Style.contains(style) {
            
            let ary_Alignment : [NSTextAlignment] = [.left, .right, .center]
            return ary_Alignment[AppSingletonObj.randomNumber(min: 0, max: ary_Alignment.count)]
        }
        
        return align
    }
    
    class func isJustifiedText(style: LayerStyle) -> Bool {
    
        let ary_Style : [LayerStyle] = [.NONE, .SOLID]
        let ary_Random : [LayerStyle] = [.SKYSCRAPPERTHIN, .SKYSCRAPPERBOLD]
        
        if ary_Style.contains(style) {
            
            return true
        }
        else if ary_Random.contains(style) {
            
            return Bool.random()
        }
        else {
         
            return false
        }
    }
    
    class func charcterSpacing(style: LayerStyle) -> CGFloat {
        
        let ary_Style : [LayerStyle] = [.SOLID, .NONE, .ONELASTSMILE]
        if ary_Style.contains(style) {
            
            return CGFloat(AppSingletonObj.randomDecimal(min: -2.0, max: 5.5))
        }
        
        return 1.0
    }
    
    class func lineSpacing(style: LayerStyle) -> CGFloat {
        
        let ary_Style : [LayerStyle] = [.LEFT]
        if ary_Style.contains(style) {
            
            return -5.0
        }
        
        return 0.0
    }
    
    class func fontFamily(list: [String], font: String) -> String {
        
        if list.count == 2 {
            
            let indexFont = list[0] == font ? 1 : 0
            return list[indexFont]
        }
        else if list.count > 2 {
            
            return list[AppSingletonObj.randomNumber(min: 0, max: list.count)]
        }
        else {
            
            return font
        }
    }
}
