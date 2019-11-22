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


class StyleList: NSObject {

    class func getStyleList() -> [infoStyle] {
        
        return [StyleList.setLayerInfoNone(),
                StyleList.setLayerInfoSolid(),
                StyleList.setLayerInfoLeft(),
                StyleList.setLayerInfoONELASTSMILE(),
                StyleList.setLayerInfoLETTERGAME(),
                StyleList.setLayerInfoFASTRUNNER(),
                StyleList.setLayerInfoPHOTOGRAPH(),
                StyleList.setLayerInfoSKYSCRAPPERTHIN(),
                StyleList.setLayerInfoSKYSCRAPPERBOLD(),
                StyleList.setLayerInfoLOKICOLA()]
    }
    
    class func setLayerInfoNone() -> infoStyle {
                
        let info = infoStyle()
        info.style = LayerStyle.NONE
        info.textAlignment = .center
        info.isJustifiedText = true
        
        let effect = infoEffect()
        effect.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        effect.line = 3
        info.effect = effect
        
        return info
    }
    
    class func setLayerInfoSolid() -> infoStyle {
        
        let info = infoStyle()
        info.style = LayerStyle.SOLID
        info.textAlignment = .center
        info.isJustifiedText = true
        
        let effectB = infoEffect()
        effectB.isBorder = true
        effectB.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoLeft() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "ee nobblee"
        info.style = LayerStyle.LEFT
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = true
        effectB.texts = [infoText(text: "WE EASILY"), infoText(text: "CAN"), infoText(text: "DO THIS")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoONELASTSMILE() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "Bebas Neue"
        info.style = LayerStyle.ONELASTSMILE
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = true
        effectB.texts = [infoText(text: "ONE"), infoText(text: "LAST"), infoText(text: "SMILE")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoLETTERGAME() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "BudmoJiggler-Regular"
        info.listFontFamily = ["BudmoJiggler-Regular", "BudmoJigglish-Regular"]
        info.style = LayerStyle.LETTERGAME
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = false
        effectB.texts = [infoText(text: "LETTER"), infoText(text: "GAME")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoFASTRUNNER() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "SteelfishRg-Italic"
        info.listFontFamily = ["SteelfishRg-Italic", "SteelfishRg-BoldItalic"]
        info.style = LayerStyle.FASTRUNNER
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = false
        effectB.texts = [infoText(text: "FAST"), infoText(text: "RUNNER")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoSKYSCRAPPERTHIN() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "Roboto-Thin"
        info.listFontFamily = []
        info.style = LayerStyle.SKYSCRAPPERTHIN
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = false
        effectB.texts = [infoText(text: "SKY"), infoText(text: "SCRAPPER"), infoText(text: "THIN")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoSKYSCRAPPERBOLD() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "Roboto-Bold"
        info.listFontFamily = []
        info.style = LayerStyle.SKYSCRAPPERBOLD
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = false
        effectB.texts = [infoText(text: "SKY"), infoText(text: "SCRAPPER"), infoText(text: "BOLD")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoPHOTOGRAPH() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "PhotographSignature"
        info.listFontFamily = []
        info.style = LayerStyle.PHOTOGRAPH
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = false
        effectB.texts = [infoText(text: "PHOTOGRAPH"), infoText(text: "SIGNATURE")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
    
    class func setLayerInfoLOKICOLA() -> infoStyle {
        
        let info = infoStyle()
        info.fontFamily = "LokiCola"
        info.listFontFamily = []
        info.style = LayerStyle.LOKICOLA
        info.textAlignment = .left
        
        let effectB = infoEffect()
        effectB.isBorder = false
        effectB.texts = [infoText(text: "232"), infoText(text: "LOKI COLA"), infoText(text: "323")]
        effectB.line = 3
        info.effect = effectB
        
        return info
    }
}


enum LayerStyle : Int {
    
    case NONE
    case SOLID
    case FONT
    case LEFT
    case ONELASTSMILE
    case LETTERGAME
    case FASTRUNNER
    case SKYSCRAPPERTHIN
    case SKYSCRAPPERBOLD
    case PHOTOGRAPH
    case LOKICOLA
}

class infoStyle: NSObject {

    var text : String = ""
    var preText : String = ""
    var postText : String = ""
    var fontFamily : String = "Bebas"
    var listFontFamily : [String] = []
    
    var style = LayerStyle(rawValue: 0)
    var textAlignment : NSTextAlignment = .center
    var isJustifiedText : Bool = false
    
    var effect = infoEffect()
    
    var lineDiv : CGFloat = 1
    var borderDiv : CGFloat = 1
    var charcterSpacing : CGFloat = 0.0
    var lineSpacing : CGFloat = 0.0
    
//    var ary_String : [String] = ["White Lotus Pvt", "Lotus Corporation", "Corporation Company", "Company White"]
    
    class func copy(style: infoStyle) -> infoStyle {

        let info = infoStyle()
        info.text = style.text
        info.preText = style.preText
        info.postText = style.postText
        info.fontFamily = style.fontFamily
        info.listFontFamily = style.listFontFamily
        info.style = style.style
        info.textAlignment = style.textAlignment
        info.isJustifiedText = style.isJustifiedText
        info.effect = infoEffect.copy(effect: style.effect)
        info.lineDiv = style.lineDiv
        info.borderDiv = style.borderDiv
        info.charcterSpacing = style.charcterSpacing
        info.lineSpacing = style.lineSpacing
        
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
