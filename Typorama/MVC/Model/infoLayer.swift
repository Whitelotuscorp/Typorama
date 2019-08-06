//
//  infoStyle.swift
//  Canvas
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit



class infoLayer: NSObject {

    var style : infoStyle = infoStyle()
    
    var image : UIImage = UIImage()
    
    var color : UIColor = .black
    
    var shadow : infoLayerShadow = infoLayerShadow(shadow: false)

    init(color : UIColor = .black, style : infoStyle = infoStyle()) {
        
        self.color = color
        self.style = style
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
