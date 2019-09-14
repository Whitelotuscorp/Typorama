//
//  infoImage.swift
//  Typorama
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum ImageType : Int {
    
    case COLOR
    case IMAGE
    case NONE
}

class infoImage: NSObject {
    
    var original : UIImage = UIImage()
    var image : UIImage = UIImage()
    
    var type = ImageType(rawValue: 0)
    
    var color : UIColor = .clear
    
    var str_Size : String = ""
    
    init(size : String, color : UIColor, image : UIImage, type : ImageType) {
        
        self.str_Size = size
        self.color = color
        self.original = image
        self.type = type
    }
    
    func getImage(size: CGSize) -> UIImage {
        
        let ary_Size = self.str_Size.components(separatedBy: "x")
        var sz_New : CGSize = CGSize.zero
        
        if self.str_Size != "" && ary_Size.count > 1 {
            
            let w_Can : CGFloat = CGFloat(Float(ary_Size[0])!)
            let h_Can : CGFloat = CGFloat(Float(ary_Size[1])!)
            
            sz_New = CGSize(width: w_Can, height: h_Can)
        }
        else {
            
            sz_New = size
        }
        
        if self.type == ImageType.IMAGE {
         
            return self.original
        }
        else {
            
            return AppSingletonObj.createImage(color: self.color, size: sz_New)
        }
    }
}
