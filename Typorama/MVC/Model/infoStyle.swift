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

    var style = LayerStyle(rawValue: 0)
    
    var effects : [infoEffect] = []
    var index : Int = 0
    
//    var ary_String : [String] = ["White Lotus Pvt", "Lotus Corporation", "Corporation Company", "Company White"]
    
    class func copyOne(effect: infoEffect, With style: infoStyle) -> infoStyle {
        
        let info = infoStyle()
        
        info.style = style.style
        info.effects = [effect]
        
        return info
    }
    
    class func setLayerInfoNone(text: [String]) -> infoStyle {
        
        let info = infoStyle()
        info.style = LayerStyle.NONE
        
        let effect = infoEffect()
        effect.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        info.effects.append(effect)
        
        let effectB = infoEffect()
        effectB.isBorder = true
        effectB.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        info.effects.append(effectB)
        
        let effect1 = infoEffect()
        effect1.texts = [infoText(text: "WE"), infoText(text: "EASILY"), infoText(text: "CAN DO THIS")]
        info.effects.append(effect1)
        
        let effect1B = infoEffect()
        effect1B.isBorder = true
        effect1B.texts = [infoText(text: "WE"), infoText(text: "EASILY"), infoText(text: "CAN DO THIS")]
        info.effects.append(effect1B)
        
        let effect2 = infoEffect()
        effect2.texts = [infoText(text: "WE EASILY CAN DO"), infoText(text: "THIS")]
        info.effects.append(effect2)
        
        let effect2B = infoEffect()
        effect2B.isBorder = true
        effect2B.texts = [infoText(text: "WE EASILY CAN DO"), infoText(text: "THIS")]
        info.effects.append(effect2B)
        
        let effect3 = infoEffect()
        effect3.texts = [infoText(text: "WE"), infoText(text: "", line: true), infoText(text: "EASILY CAN DO THIS")]
        info.effects.append(effect3)
        
        let effect3B = infoEffect()
        effect3B.isBorder = true
        effect3B.texts = [infoText(text: "WE"), infoText(text: "", line: true), infoText(text: "EASILY CAN DO THIS")]
        info.effects.append(effect3B)
        
        let effect4 = infoEffect()
        effect4.texts = [infoText(text: "WE EASILY CAN DO THIS")]
        info.effects.append(effect4)
        
        let effect4B = infoEffect()
        effect4B.isBorder = true
        effect4B.texts = [infoText(text: "WE EASILY CAN DO THIS")]
        info.effects.append(effect4B)
        
        return info
    }
    
    class func setLayerInfoSolid(text: [String]) -> infoStyle {
        
        let info = infoStyle()
        info.style = LayerStyle.SOLID
        
        let effectB = infoEffect()
        effectB.isBorder = true
        effectB.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        info.effects.append(effectB)
        
        let effect = infoEffect()
        effect.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        info.effects.append(effect)
        
        let effect1 = infoEffect()
        effect1.texts = [infoText(text: "WE"), infoText(text: "EASILY"), infoText(text: "CAN DO THIS")]
        info.effects.append(effect1)
        
        let effect1B = infoEffect()
        effect1B.isBorder = true
        effect1B.texts = [infoText(text: "WE"), infoText(text: "EASILY"), infoText(text: "CAN DO THIS")]
        info.effects.append(effect1B)
        
        let effect2 = infoEffect()
        effect2.texts = [infoText(text: "WE EASILY CAN DO"), infoText(text: "THIS")]
        info.effects.append(effect2)
        
        let effect2B = infoEffect()
        effect2B.isBorder = true
        effect2B.texts = [infoText(text: "WE EASILY CAN DO"), infoText(text: "THIS")]
        info.effects.append(effect2B)
        
        let effect3 = infoEffect()
        effect3.texts = [infoText(text: "WE"), infoText(text: "EASILY CAN DO THIS")]
        info.effects.append(effect3)
        
        let effect3B = infoEffect()
        effect3B.isBorder = true
        effect3B.texts = [infoText(text: "WE"), infoText(text: "EASILY CAN DO THIS")]
        info.effects.append(effect3B)
        
        let effect4 = infoEffect()
        effect4.texts = [infoText(text: "WE EASILY CAN DO THIS")]
        info.effects.append(effect4)
        
        let effect4B = infoEffect()
        effect4B.isBorder = true
        effect4B.texts = [infoText(text: "WE EASILY CAN DO THIS")]
        info.effects.append(effect4B)
        
        return info
    }
}

class infoEffect: NSObject {
    
    var isBorder : Bool = false
    var texts : [infoText] = []
}

class infoText: NSObject {
    
    var isLine : Bool = false
    var text : String = ""
    
    init(text: String, line: Bool = false) {
        
        self.text = text
        self.isLine = line
    }
}
