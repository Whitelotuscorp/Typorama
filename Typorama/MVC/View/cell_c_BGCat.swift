//
//  cell_c_BGCat.swift
//  Typorama
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_BGCat: UICollectionViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Line: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        
        self.lbl_Name.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Name.textColor = COLOR_White
    }

}
