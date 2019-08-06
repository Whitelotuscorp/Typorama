//
//  cell_c_Image.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class cell_c_Image: UICollectionViewCell {

    @IBOutlet weak var imgvw_Pic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgvw_Pic.contentMode = .scaleAspectFill
    }

}
