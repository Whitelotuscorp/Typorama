//
//  infoLogo.swift
//  Typorama
//
//  Created by Apple on 16/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class infoLogo: NSObject {
    
    var lp_id : String = ""
    var l_id : String = ""
}

class infoLogoList: NSObject {
    
    var l_id : String = ""
    var l_type : LogoType = LogoType.Text
    var l_image : String = ""
    var l_text : String = ""
    var l_font : String = ""
    var l_shadow : Float = 0.0
    var l_color : String = ""
    var l_opacity : Float = 1.0
    var l_size : String = ""
    var l_origin : String = ""
    var l_super_size : String = ""
    
    init(text: String = "") {
        
        self.l_text = text
    }
}
