//
//  cell_c_Crop.swift
//  Typorama
//
//  Created by Apple on 13/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_Crop: UICollectionViewCell {

    @IBOutlet weak var vw_BG: UIView!
    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Size: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vw_BG.clipsToBounds = true
        self.vw_BG.layer.cornerRadius = 5.0
        self.vw_BG.layer.borderColor = COLOR_White.cgColor
        self.vw_BG.layer.borderWidth = 1.0
        
        self.lbl_Name.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size12)
        self.lbl_Name.textColor = COLOR_White
        
        self.lbl_Size.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size20)
        self.lbl_Size.textColor = COLOR_White
    }
}
