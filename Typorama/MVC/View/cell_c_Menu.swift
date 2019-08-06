//
//  cell_c_Menu.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_Menu: UICollectionViewCell {

    @IBOutlet weak var imgvw_Icon: UIImageView!
    
    @IBOutlet weak var lbl_Menu: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lbl_Menu.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size13)
        self.lbl_Menu.textColor = COLOR_Black
    }
}
