//
//  infoImage.swift
//  Typorama
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class infoImage: NSObject {
    
    var original : UIImage = UIImage()
    var image : UIImage = UIImage()
    
    var color : UIColor = .clear
    
    var str_Size : String = ""
    
    init(size : String = "", color : UIColor = .clear, image : UIImage = UIImage()) {
        
        self.str_Size = size
        self.color = color
        self.original = image
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
        
        return self.createImage(color: self.color, size: sz_New)
    }
    
    func createImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return UIImage() }
        
        return UIImage.init(cgImage: cgImage)
    }
}
