//
//  GradientVW.swift
//  Typorama
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

@objc protocol GradientVWDelegate: class {
    
    @objc optional func gradient(view: GradientVW, ShouldChange isEnable: Bool)
    @objc optional func gradient(view: GradientVW, DidChange colors: [UIColor], ratio: Float, With direction: Float)
}

class GradientVW: UIView {

    weak var delegate : GradientVWDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var swtch_Gradient: UISwitch!
    
    @IBOutlet weak var sld_Ratio: TactileSlider!
    
    @IBOutlet weak var sld_Direction: UISlider!
    
    @IBOutlet weak var lbl_Direction: UILabel!
    @IBOutlet weak var lbl_Gradient: UILabel!
    
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
        
        self.sld_Direction.setThumbImage(UIImage(named: "thumb_cir"), for: .normal)
        
        self.sld_Ratio.delegate = self
        self.sld_Ratio.clipsToBounds = true
        self.sld_Ratio.layer.cornerRadius = self.sld_Ratio.cornerRadius
        
        self.swtch_Gradient.clipsToBounds = true
        self.swtch_Gradient.layer.cornerRadius = self.swtch_Gradient.frame.height / 2
        self.swtch_Gradient.layer.borderWidth = 1.0
        
        self.lbl_Direction.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Direction.textColor = COLOR_Black
        
        self.lbl_Gradient.font = UIFont(name: APPFONT_Bold, size: APPFONT_Size15)
        self.lbl_Gradient.textColor = COLOR_White
        self.lbl_Gradient.backgroundColor = COLOR_GrayD060
        self.lbl_Gradient.clipsToBounds = true
        self.lbl_Gradient.layer.cornerRadius = 5
    }
    
    func setCurrentValue(info: infoLayerGradient) {
        
        self.swtch_Gradient.isOn = info.isGradient
        self.sld_Ratio.setValue(info.ratio, animated: false)
        self.sld_Direction.value = info.direction
        
        if info.colors.count > 1 {
            
            self.sld_Ratio.trackBackground = info.colors[1]
            self.sld_Ratio.thumbTint = info.colors[0]
        }
        
        self.setUIEnable(isEnable: info.isGradient)
    }
    
    func setUIEnable(isEnable: Bool) {
        
        self.sld_Ratio.isEnabled = isEnable
        self.sld_Direction.isEnabled = isEnable
    }
    
    @IBAction func action_ChangeDirection(_ slider: UISlider) {
        
        self.action_CallDelegate()
    }
    
    @IBAction func action_ChangeColorRatio(_ slider: TactileSlider) {
        
        self.action_CallDelegate()
    }
    
    @IBAction func action_ChangeSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
           
            sender.thumbTintColor = .darkGray
        }
        else {
            
            sender.thumbTintColor = .black
        }
        
        self.setUIEnable(isEnable: sender.isOn)
        self.delegate?.gradient?(view: self, ShouldChange: sender.isOn)
        self.action_CallDelegate()
    }
    
    func action_CallDelegate() {
        
        let ary_Color = [self.sld_Ratio.thumbTint, self.sld_Ratio.trackBackground]
        let direction = self.sld_Direction.value > 360.0 ? (self.sld_Direction.value - 45.0) : self.sld_Direction.value
        self.delegate?.gradient?(view: self, DidChange: ary_Color, ratio: floorf(self.sld_Ratio.value * 10) / 10, With: ceilf(direction))
    }
}

extension GradientVW : TactileSliderWDelegate {
    
    func tactileSlider(slider: TactileSlider, DidTapAt value: Float) {
                
        let superview = self.superview?.superview?.superview
        let h_Bottom : CGFloat = (AppDelegateObj.window?.safeAreaInsets.bottom)!
        let rect = CGRect(x: 0, y: (superview?.frame.height)! - 197 - h_Bottom, width: (superview?.frame.width)!, height: 197)
        let colorPicker = ColorPickerVW(frame: rect)
        superview?.addSubview(colorPicker)
        colorPicker.show()
        
        var color = slider.trackBackground
        var tag = 0
        if slider.value > value {
            
            color = slider.thumbTint
            tag = 1
        }
        
        colorPicker.colorPicker.tag = tag
        colorPicker.colorPicker.delegate = self
        colorPicker.colorPicker.color = color
        colorPicker.huePicker.color = color
        superview?.bringSubviewToFront(colorPicker)
    }
}

extension GradientVW : ILSaturationBrightnessPickerViewDelegate {
    
    func colorPicked(_ newColor: UIColor!, forPicker picker: ILSaturationBrightnessPickerView!) {
        
        if picker.tag == 0 {
            
            self.sld_Ratio.trackBackground = newColor
        }
        else {
            
            self.sld_Ratio.thumbTint = newColor
        }
            
        self.action_CallDelegate()
    }
}
