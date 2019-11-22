//
//  cell_c_Shape.swift
//  Typorama
//
//  Created by Apple on 31/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_Shape: UICollectionViewCell {

    @IBOutlet weak var vw_BG: UIView!
    
    @IBOutlet weak var imgvw_Shape: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vw_BG.backgroundColor = COLOR_White
        self.vw_BG.clipsToBounds = true
        self.vw_BG.layer.cornerRadius = 5
        self.vw_BG.layer.borderColor = UIColor.gray.cgColor
        self.vw_BG.layer.borderWidth = 1.0
    }
}
