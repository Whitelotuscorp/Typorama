//
//  infoStyle.swift
//  Canvas
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

//WE EASILY
//CAN
//DO THIS

enum LayerStyle : Int {
    
    case NONE
    case SOLID
    case TRANSFORM
    case FONT
}

class infoStyle: NSObject {

    var text : String = ""
    
    var style = LayerStyle(rawValue: 0)
    var effect = infoEffect()
    
    var lineDiv : CGFloat = 1
    var borderDiv : CGFloat = 1
    var charcterSpacing : CGFloat = 0.0
    var lineSpacing : CGFloat = 1.0
    
//    var ary_String : [String] = ["White Lotus Pvt", "Lotus Corporation", "Corporation Company", "Company White"]
    
    class func copy(style: infoStyle) -> infoStyle {

        let info = infoStyle()
        info.text = style.text
        info.style = style.style
        info.effect = infoEffect.copy(effect: style.effect)
        info.lineDiv = style.lineDiv
        info.borderDiv = style.borderDiv
        info.charcterSpacing = style.charcterSpacing
        info.lineSpacing = style.lineSpacing
        
        return info
    }
    
    class func setLayerInfoNone(text: [String]) -> infoStyle {
                
        let info = infoStyle()
        info.style = LayerStyle.NONE
        
        let effect = infoEffect()
        effect.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        effect.line = 3
        info.effect = effect
        
        return info
    }
    
    class func setLayerInfoSolid(text: [String]) -> infoStyle {
        
        let info = infoStyle()
        info.style = LayerStyle.SOLID
        
        let effectB = infoEffect()
        effectB.isBorder = true
        effectB.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
}

class infoEffect: NSObject {
    
    var isBorder : Bool = false
    var isLine : Bool = false
    var line : Int = 1
    var texts : [infoText] = []
    
    class func copy(effect: infoEffect) -> infoEffect {
        
        let info = infoEffect()
        info.isBorder = effect.isBorder
        info.isLine = effect.isLine
        info.line = effect.line
        info.texts = effect.texts
        return info
    }
}

class infoText: NSObject {
    
    var isLine : Bool = false
    var text : String = ""
    
    init(text: String, line: Bool = false) {
        
        self.text = text
        self.isLine = line
    }
}
