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
    
    @IBOutlet weak var lbl_Text: UILabel!
    
    @IBOutlet weak var lyl_x_Text: NSLayoutConstraint!
    @IBOutlet weak var lyl_y_Text: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgvw_Trans.isHidden = true
        
        self.lbl_Text.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
    }
}
