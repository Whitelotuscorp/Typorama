//
//  cell_c_View.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_View: UICollectionViewCell {

    @IBOutlet weak var vw_BG: UIView!
    
    @IBOutlet weak var lbl_Name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vw_BG.backgroundColor = COLOR_White
        self.vw_BG.clipsToBounds = true
        self.vw_BG.layer.cornerRadius = 5
        
        self.lbl_Name.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size13)
        self.lbl_Name.textColor = COLOR_Black
    }
}
