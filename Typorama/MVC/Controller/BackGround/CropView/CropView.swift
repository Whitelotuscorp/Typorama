//
//  CropView.swift
//  Typorama
//
//  Created by Apple on 13/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
protocol CropViewDelegate: class {
    
    func crop(view: CropView, didCrop size: String, With image: UIImage, type: ImageType)
    func crop(view: CropView, didCancel size: String)
}

class CropView: UIView {
    
    weak var delegate : CropViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Canvas: UIView!
    
    @IBOutlet weak var clc_Size: UICollectionView!
    
    @IBOutlet weak var imgvw_Main: UIImageView!
    
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Next: UIButton!
    
    @IBOutlet weak var lbl_Creation: UILabel!
    var sticker_Size: OTResizableView!
    
    @IBOutlet weak var lyl_w_Canvas: NSLayoutConstraint!
    @IBOutlet weak var lyl_h_Canvas: NSLayoutConstraint!
    
    var muary_Size = NSMutableArray()
    
    var typeBG = ImageType(rawValue: 0)
    
    var image: UIImage!
    var color: UIColor!
    
    var index_Selected : IndexPath = IndexPath(item: 0, section: 0)
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        configureXIB()
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        configureXIB()
    }
    
    func configureNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func configureXIB() {
        
        self.contentView = configureNib()
        self.contentView.frame = bounds
        self.contentView.backgroundColor = .clear
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.contentView)
        
        self.backgroundColor = .clear
        self.isHidden = true
        
        let nib_CellCrop = UINib(nibName: "cell_c_Crop", bundle: nil)
        self.clc_Size.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Crop")
               
        let layout_Cat = self.clc_Size.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: self.clc_Size.frame.height - 60, height: self.clc_Size.frame.height)
        self.clc_Size.collectionViewLayout = layout_Cat
        
        self.muary_Size = NSMutableArray(array: ARRAY_CanvasSize)
        self.clc_Size.reloadData()
        
        self.btn_Next.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.btn_Next.setTitleColor(COLOR_White, for: .normal)
        
        self.btn_Cancel.titleLabel!.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.btn_Cancel.setTitleColor(COLOR_White, for: .normal)
        
        self.lbl_Creation.text = "How do you want to use your creation?"
        self.lbl_Creation.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Creation.textColor = COLOR_White
        
//        self.lyl_w_Canvas.constant = self.frame.width - 20
        self.updateConstraintsIfNeeded()
        
        
        
        self.perform(#selector(self.loadViewDelay), with:nil, afterDelay: 0.23)
        self.perform(#selector(self.setCropFrame(indexPath:)), with: self.index_Selected, afterDelay: 0.25)
    }
    
    @objc func loadViewDelay() {
        
        let yourView = UIView(frame: CGRect(x: 0, y: 0, width: self.vw_Canvas.frame.width, height: self.vw_Canvas.frame.height))
        yourView.backgroundColor = UIColor.clear
        self.sticker_Size = OTResizableView(contentView: yourView)
        self.sticker_Size.delegate = self
        self.vw_Canvas.addSubview(self.sticker_Size)
        self.sticker_Size.backgroundColor = .clear
        self.sticker_Size.clipsToBounds = true
        self.sticker_Size.layer.borderColor = COLOR_White.cgColor
    }
    
    func setCroperCustomFrame() {
        
        self.sticker_Size.setResizedFrame(newFrame: CGRect(x: 0, y: 0, width: self.vw_Canvas.frame.width, height: self.vw_Canvas.frame.height))
    }
    
    func showCropView(image: UIImage, With color: UIColor, typeBG : ImageType) {
     
        self.image = image
        self.color = color
        self.typeBG = typeBG
        
        self.imgvw_Main.image = image
        self.vw_Canvas.backgroundColor = color
        self.isHidden = false
    }
    
    func hideCropView() {
        
        self.isHidden = true
    }
    
    @IBAction func action_Cancel(_ sender: Any) {
        
        self.hideCropView()
        self.delegate?.crop(view: self, didCancel: "")
    }
    
    @IBAction func action_Next(_ sender: Any) {
        
        self.hideCropView()
        
        let dict : [String:String] = self.muary_Size.object(at: self.index_Selected.row) as! [String : String]
        let size = dict["size"]
        
        if CUSTOME_Size == size {
            
        }
        
        self.delegate?.crop(view: self, didCrop: size!, With: self.image, type: self.typeBG!)
    }
}

extension CropView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Size.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Crop = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Crop", for: indexPath) as! cell_c_Crop
        
        let dict : [String:String] = self.muary_Size.object(at: indexPath.row) as! [String : String]
        cell.lbl_Name.text = dict["name"]
        cell.lbl_Size.text = dict["scale"]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.index_Selected = indexPath
        self.clc_Size.reloadData()
        self.setCropFrame(indexPath: indexPath)
    }
    
    @objc func setCropFrame(indexPath: IndexPath) {
        
        let dict : [String:String] = self.muary_Size.object(at: indexPath.row) as! [String : String]
        let size = dict["size"]
        let ary_Size = dict["size"]?.components(separatedBy: "x")
        
        var frame_New : CGRect = CGRect.zero
        
        if size != "" && ary_Size!.count > 1 {
      
            let w_Can : CGFloat = CGFloat(Float(ary_Size![0])!)
            let h_Can : CGFloat = CGFloat(Float(ary_Size![1])!)
            
            var w_New : CGFloat = self.vw_Canvas.frame.width
            var h_New : CGFloat = self.vw_Canvas.frame.height
         
            if h_Can > w_Can {
                
                w_New = (w_Can * h_New) / h_Can
            }
            else {
                
                h_New = (h_Can * w_New) / w_Can
            }
            
            frame_New = CGRect(x: 0, y: 0, width: w_New, height: h_New)
        }
        else {
            
            frame_New = self.vw_Canvas.frame
        }        
        
        self.sticker_Size.resizeEnabled = false
        self.sticker_Size.layer.borderWidth = 2.0
        self.sticker_Size.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.sticker_Size.frame = frame_New
            self.sticker_Size.center = CGPoint(x: self.vw_Canvas.frame.width / 2, y: self.vw_Canvas.frame.height / 2)
        }) { (success) in
         
            if size == CUSTOME_Size {
                
                self.setCroperCustomFrame()
                self.sticker_Size.resizeEnabled = true
                self.sticker_Size.isUserInteractionEnabled = true
                self.sticker_Size.layer.borderWidth = 0.0
            }
        }
    }
}

extension CropView : OTResizableViewDelegate {
    
    func tapBegin(_ resizableView:OTResizableView) {
        
    }
    
    func tapChanged(_ resizableView:OTResizableView) {
        
    }
    
    func tapMoved(_ resizableView:OTResizableView) {
        
    }
    
    func tapEnd(_ resizableView:OTResizableView) {
        
    }
}
