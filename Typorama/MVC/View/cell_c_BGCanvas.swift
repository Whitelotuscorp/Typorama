//
//  cell_c_BGCanvas.swift
//  Typorama
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_BGCanvas: UICollectionViewCell {

    @IBOutlet weak var vw_BG: UIView!
    
    @IBOutlet weak var imgvw_Trans: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgvw_Trans.isHidden = true
    }

}
