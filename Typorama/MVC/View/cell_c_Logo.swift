//
//  cell_c_Logo.swift
//  Typorama
//
//  Created by Apple on 16/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol CellLogDelegate: class {
    
    @objc optional func showAllDeleteBtn()
    @objc optional func hideAllDeleteBtn()
    @objc optional func delete(cell: cell_c_Logo, AtIndexpath indexPath: IndexPath)
}

class cell_c_Logo: UICollectionViewCell {

    weak var delegate : CellLogDelegate?
    
    @IBOutlet weak var vw_BG: UIView!
    @IBOutlet weak var vw_Delete: UIView!
        
    @IBOutlet weak var btn_Delete: UIButton!
    
    @IBOutlet weak var imgvw_Logo: UIImageView!
    
    @IBOutlet weak var lbl_Logo: UILabel!
    @IBOutlet weak var lbl_Delete: UILabel!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vw_BG.backgroundColor = COLOR_White
        self.vw_BG.clipsToBounds = true
        self.vw_BG.layer.cornerRadius = 5
        self.vw_BG.layer.borderColor = UIColor.gray.cgColor
        self.vw_BG.layer.borderWidth = 1.0
        
        self.lbl_Delete.clipsToBounds = true
        self.lbl_Delete.layer.cornerRadius = self.lbl_Delete.frame.width / 2
        self.lbl_Delete.backgroundColor = COLOR_White
        self.lbl_Delete.layer.borderColor = UIColor.gray.cgColor
        self.lbl_Delete.layer.borderWidth = 0.5
        self.lbl_Delete.textColor = COLOR_Black
        self.lbl_Delete?.font = UIFont.fontAwesome(ofSize: APPFONT_Size12, style: .solid)
        self.lbl_Delete.text = String.fontAwesomeIcon(name: FontAwesome.times)
        
        self.lbl_Logo.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Logo.textColor = COLOR_Black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setCell()
    }

    // MARK: - setAnimationType
//    func setAnimationType() {
//
//        YTAnimation.toMiniAnimation(self)
//    }

    //the following methods ,you just need copy ~ paste
    func setCell() {
        
        addLongPressGesture()
    }

    func addLongPressGesture() {
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longClick(_:)))
        addGestureRecognizer(lpgr)
    }

    @objc func longClick(_ lpgr: UILongPressGestureRecognizer?) {

        self.delegate?.showAllDeleteBtn?()
    }

    @IBAction func action_Delete(_ sender: UIButton) {
        
        self.delegate?.delete?(cell: self, AtIndexpath: self.indexPath!)
    }
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//
//        if anim.value(forKey: "animType") != nil {
//
//
//        }
//    }
}
