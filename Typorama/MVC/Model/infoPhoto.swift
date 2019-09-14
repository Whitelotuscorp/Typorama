//
//  infoPhoto.swift
//  Typorama
//
//  Created by Apple on 09/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Photos

class infoPhoto: NSObject {
    
    var asset: PHAsset?
    var image : UIImage = UIImage()
    
    init(asset : PHAsset) {
        
        self.asset = asset
    }
}
