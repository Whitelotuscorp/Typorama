//
//  infoStyle.swift
//  Canvas
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc
enum LayerType : Int {
    
    case TEXT
    case PHOTO
    case LOGO
    case SHAPE
}

class infoLayer: NSObject {

    var type = LayerType(rawValue: 0)
    
    var style : infoStyle = infoStyle()
    
    var text : String = ""
    
    var main : UIImage = UIImage()
    var image : UIImage = UIImage()
    
    var color : UIColor = .black
    
    var isLine : Bool = false
    
    var shadow : infoLayerShadow = infoLayerShadow(shadow: false)
    var gradient : infoLayerGradient = infoLayerGradient(gradient: false)

    init(color : UIColor = .black, text : String = "") {
        
        self.color = color
        self.text = text
    }
}

class infoLayerShadow: NSObject {
    
    var isShadow : Bool = false
    var color : UIColor = .black
    var x : CGFloat = 0
    var y : CGFloat = 0
    var opacity : CGFloat = 1
    var blur : CGFloat = 0
    
    init(shadow: Bool = false) {
        
        self.isShadow = shadow
    }
}

class infoLayerGradient: NSObject {
    
    var isGradient : Bool = false
    var colors : [UIColor] = []
    var ratio : Float = 0.5
    var direction : Float = 45.0
    
    init(gradient: Bool = false) {
        
        self.isGradient = gradient
    }
}
