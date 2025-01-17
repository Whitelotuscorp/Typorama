//
//  cell_c_Share.swift
//  Typorama
//
//  Created by Apple on 10/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_Share: UICollectionViewCell {

    @IBOutlet weak var vw_BG: UIView!
    
    @IBOutlet weak var imgvw_Icon: UIImageView!
    
    @IBOutlet weak var lbl_Name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lbl_Name.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size10)
        self.lbl_Name.textColor = COLOR_Black
        
        self.vw_BG.clipsToBounds = true
        self.vw_BG.layer.cornerRadius = 5
        self.vw_BG.backgroundColor = COLOR_GrayL240
    }
}
