//
//  Text_VW.swift
//  Typorama
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum TextMenu : Int {
    
    case Styles
    case History
    case Color
    case Shadow
    case Gradient
    case Eraser
}

@objc protocol TextVWDelegate: class {
    
    @objc optional func text(view: TextVW, changeStyle style: infoStyle)
    @objc optional func text(view: TextVW, changeColor color: UIColor)
    
    @objc optional func text(view: TextVW, ChangeShadow value: Any, With type: ShadowValue)
    
    @objc optional func textDidChangeGradient(view: TextVW)
}

class TextVW: UIView {

    weak var delegate : TextVWDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Menu: UIView!
    
    @IBOutlet var vw_History: HistoryVW!
    @IBOutlet var vw_Style: StypleVW!
    @IBOutlet var vw_Color: ColorVW!
    @IBOutlet var vw_Shadow: ShadowVW!
    @IBOutlet var vw_Gradient: GradientVW!
    @IBOutlet var vw_Eraser: EraserVW!
    
    @IBOutlet weak var clc_Menu: UICollectionView!
    
    var currentLayer = ZDStickerView()
    
    var muary_Menu = NSMutableArray()
    
    var sizeCanvas : CGSize = CGSize.zero
    
    var isFisrtLoaded : Bool = false
    
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
        
        self.contentView.backgroundColor = COLOR_GrayL240
        self.vw_Menu.backgroundColor = COLOR_White
        
        let nib_CellCrop = UINib(nibName: "cell_c_Menu", bundle: nil)
        self.clc_Menu.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Menu")
        
        let layout_Cat = self.clc_Menu.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: 70, height: 50)
        self.clc_Menu.collectionViewLayout = layout_Cat        
        
        self.setMenuArray()
        let dict : [String:String] = self.muary_Menu.object(at: 0) as! [String : String]
        self.action_SelectMenu(menu: TextMenu(rawValue: Int(dict["option"]!)!)!)
        
        self.vw_Style.delegate = self
        self.vw_History.delegate = self
        self.vw_Color.delegate = self
        self.vw_Shadow.delegate = self
        self.vw_Gradient.delegate = self
    }
    
    func setMenuArray() {
     
        self.muary_Menu = NSMutableArray()
        if self.vw_History.muary_History.count > 0 {
        
            self.muary_Menu.add(["name":"History", "icon":"icon_history", "option": "1"])
        }
        
        self.muary_Menu.add(["name":"Styles", "icon":"icon_style", "option": "0"])
        self.muary_Menu.add(["name":"Color", "icon":"icon_color", "option": "2"])
        self.muary_Menu.add(["name":"Shadow", "icon":"icon_shadow", "option": "3"])
        self.muary_Menu.add(["name":"Gradient", "icon":"icon_gradient", "option": "4"])
        self.muary_Menu.add(["name":"Eraser", "icon":"icon_eraser", "option": "5"])
        
        self.clc_Menu.reloadData()
    }
    
    func action_SelectMenu(menu: TextMenu) {
        
        self.vw_History.isHidden = true
        self.vw_Style.isHidden = true
        self.vw_Color.isHidden = true
        self.vw_Shadow.isHidden = true
        self.vw_Gradient.isHidden = true
        self.vw_Eraser.isHidden = true
        
        if menu == TextMenu.History {
            
            self.vw_History.isHidden = false
        }
        else if menu == TextMenu.Styles {
            
            self.vw_Style.isHidden = false
        }
        else if menu == TextMenu.Color {
            
            self.vw_Color.isHidden = false
        }
        else if menu == TextMenu.Shadow {
            
            self.vw_Shadow.isHidden = false
        }
        else if menu == TextMenu.Gradient {
            
            self.vw_Gradient.setCurrentValue(info: (self.currentLayer.info as! infoLayer).gradient)
            self.vw_Gradient.isHidden = false
        }
        else {
            
            self.vw_Eraser.isHidden = false
        }
    }
    
    func addNewSticker() {

        
        let info_Style = self.vw_Style.muary_Layer[0]
        self.whenEditText(style: info_Style)
    }
    
    func whenEditText(style: infoStyle) {
        
        self.style(view: self.vw_Style, didSelected: style)
    }
    
    func layerDidBeginEditing(sticker: ZDStickerView) {
        
        self.currentLayer = sticker
        self.vw_Color.color = (sticker.info as! infoLayer).color
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.vw_Color.color.getRed(&r, green: &g, blue: &b, alpha: &a)        
        self.vw_Color.sld_Opacity.value = Float(a)
    }
}

extension TextVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Menu = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Menu", for: indexPath) as! cell_c_Menu
        
        let dict : [String:String] = self.muary_Menu.object(at: indexPath.row) as! [String : String]
        cell.lbl_Menu.text = dict["name"]
        cell.imgvw_Icon.image = UIImage(named: dict["icon"]!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict : [String:String] = self.muary_Menu.object(at: indexPath.row) as! [String : String]
        self.action_SelectMenu(menu: TextMenu(rawValue: Int(dict["option"]!)!)!)
    }
}

extension TextVW: StypleVWDelegate {
    
    func style(view: StypleVW, didSelected style: infoStyle) {

        let style_Current = self.currentLayer.info as! infoLayer
        let style_Prev = style_Current.style
        let str_Main = style_Current.text
        var isLineM = style_Current.isLine
        
        var ary_LineText = str_Main.components(separatedBy: "\n").filter { (str) -> Bool in
            return str != ""
        }
        let str_Text = str_Main == "" ? TEXT_Default : str_Main.condenseWhitespace()
        
        let style_Copy = infoStyle.copy(style: style)
        
        style_Copy.preText = TextProperty.preText(style: style_Copy.style!)
        style_Copy.postText = TextProperty.postText(style: style_Copy.style!)
        
        style_Copy.borderDiv = TextProperty.widthDiv(style: style_Copy.style!)
        style_Copy.lineDiv = TextProperty.widthDiv(style: style_Copy.style!)
        
        let isJustified = TextProperty.isJustifiedText(style: style_Copy.style!)
        style_Copy.isJustifiedText = isJustified
        
        if isJustified == true {
            
            style_Copy.textAlignment = .center
        }
        else {
            
            style_Copy.textAlignment = TextProperty.textAlignment(style: style_Copy.style!, align: style_Copy.textAlignment)
        }
        
        style_Copy.effect.isBorder = TextProperty.isBorder(style: style_Copy.style!)
        style_Copy.effect.isLine = TextProperty.isLine(style: style_Copy.style!)
        
        style_Copy.charcterSpacing = TextProperty.charcterSpacing(style: style_Copy.style!)
        style_Copy.lineSpacing = TextProperty.lineSpacing(style: style_Copy.style!)
        
        if style_Copy.style == style_Current.style.style && style_Copy.listFontFamily.count > 1 {
            
            style_Copy.fontFamily = TextProperty.fontFamily(list: style_Copy.listFontFamily, font: style_Current.style.fontFamily)
        }
        
        
        if str_Text != "" {
            
            var ary_Text = str_Text.components(separatedBy: " ")
            
            var int_Line = 1
            var int_Min = 1
            
            if ary_Text.count > 20 {
                
                int_Min =  4
                
            }
            else if ary_Text.count > 12 {
                
                int_Min =  2
                
            }
            else if ary_Text.count > 1 {
                
                int_Min =  1
            }
            
//            if ary_LineText.count > int_Min {
//
//                int_Min = ary_LineText.count
//            }
            
            var divLine = 2.0
            if ary_Text.count < 12 {
                
                divLine = 2.0
            }
            else if ary_Text.count < 20 {
                
                divLine = 3.0
            }
            else {
                
                divLine = 4.0
            }
            
            
            var int_Max = Int(ceil(Double(ary_Text.count) / Double(divLine)))
            if ary_Text.count == ary_LineText.count {
                
                isLineM = true
            }
            else {
                
                if int_Max - 1 == int_Min {
                    
                    int_Max = Int(ary_Text.count)
                }
                else if int_Min > int_Max {
                    
                    divLine = divLine - 1
                    int_Max = Int(ceil(Double(ary_Text.count) / Double(divLine)))
                }
            }
            
            print("---------------->")
            print("int_Min-> \(int_Min)")
            print("int_Max-> \(int_Max)")
            print("arycunt-> \(ary_Text.count)")
            
            if isLineM == true {
                
                int_Line = ary_LineText.count
            }
            else {
                
                if ary_Text.count > 3 && int_Max > int_Min {
                    
                    int_Line = AppSingletonObj.randomNumber(min: int_Min, max: int_Max)
                }
                else {
                    
                    int_Line = int_Min
                }
                
                print("calllll--------->")
                
                if ary_Text.count <= 3 && int_Line == style_Prev.effect.line && style_Copy.effect.isBorder == style_Prev.effect.isBorder && style_Copy.effect.isLine == style_Prev.effect.isLine {
                    
                    int_Line = style_Prev.effect.line == 1 ? 2 : 1
                }
                else if ary_Text.count > 3 && int_Line == style_Prev.effect.line && style_Copy.effect.isBorder == style_Prev.effect.isBorder && style_Copy.effect.isLine == style_Prev.effect.isLine {
                    
                    int_Line = AppSingletonObj.randomNumber(last: int_Line, min: int_Min, max: int_Max, isCheck: true)
                }
                
                if ary_Text.count > 5 && int_Line == 1 {
                    
                    int_Line = 2
                }
                
                if int_Line > 15 {
                    
                    int_Line = 15
                }
            }
            
            style_Copy.effect.line = int_Line
            
            var ary_Line : [Int] = []
            if style_Copy.effect.isLine == true && int_Line > 1 && style_Copy.style != LayerStyle.SOLID {
              
                var line_Solid = 1
                
                if int_Line > 4 {
                    
                    line_Solid = AppSingletonObj.randomNumber(min: 0, max: Int(int_Line - 2 > 8 ? 8 : int_Line - 2))
                }
                
                while ary_Line.count != line_Solid {
                    
                    var index_Line = AppSingletonObj.randomNumber(min: 0, max: int_Line - 1)
                    
                    if index_Line == 0 {
                        
                        index_Line = 1
                    }
                    
                    if !ary_Line.contains(index_Line) {
                     
                        ary_Line.append(index_Line)
                    }
                }
                
                int_Line = int_Line + line_Solid
            }
            
            var ary_StyleSting : [infoText] = []
            
            var lstCount = 0
            
            if int_Line > 1 && isLineM == false {
                
                while ary_Text.count > 0 {
                    
                    let min_Chr : Int = 1
                    var max_Chr : Int = Int(ceil(Double(ary_Text.count) / Double(2.0)))
                    
                    var count = 1
                    if max_Chr != min_Chr {
                        
                        max_Chr = max_Chr > 15 ? 14 : max_Chr
                        
                        count = AppSingletonObj.randomNumber(min: min_Chr, max: max_Chr)
                        
                        if lstCount == count {
                            
                            count = AppSingletonObj.randomNumber(min: min_Chr, max: max_Chr)
                        }
                        
                        lstCount = count
                    }
                    
                    if count > 5 {
                        
                        count = 5
                        
                        int_Line = int_Line + 1
                    }
                    
                    var subArray = ary_Text[0...count - 1]
                    
                    if subArray.joined(separator: " ").count > 22 {
                     
                        count -= 1
                        subArray = ary_Text[0...count - 1]
                    }
                    else if subArray.joined(separator: " ").count < 6 && ary_Text.count > 2 {
                        
                        count += 1
                        subArray = ary_Text[0...count - 1]
                        
                        if subArray.joined(separator: " ").count < 6 && ary_Text.count > 3 {
                            
                            count += 1
                            subArray = ary_Text[0...count - 1]
                        }
                    }
                    
                    
                    for _ in 0 ..< count {
                        
                        ary_Text.remove(at: 0)
                    }
                    
                    if ary_Text.joined(separator: " ").count < 5 {
                        
                        subArray.append(ary_Text.joined(separator: " "))
                        ary_Text = []
                    }
                    
                    let info_Text = infoText(text: subArray.joined(separator: " "))
                    ary_StyleSting.append(info_Text)
                    
                    if ary_Line.contains(ary_StyleSting.count) {
                        
                        let info_Text = infoText(text: "", line: true)
                        ary_StyleSting.append(info_Text)
                    }
                    
                    
                    if (ary_Text.count == 1 || ary_StyleSting.count == int_Line - 1) && ary_Text.count <= 5 && ary_Text.joined(separator: " ").count < 20 && ary_Text.joined(separator: " ").count != 0 {
                        
                        let info_Text = infoText(text: ary_Text.joined(separator: " "))
                        ary_StyleSting.append(info_Text)
                        ary_Text = []
                    }
                    else if ary_Text.count == 2 {
                        
                        let subArray1 = ary_Text[0...0]
                        
                        if subArray1.joined(separator: " ").count < 5 {
                            
                            let info_Text = infoText(text: ary_Text.joined(separator: " "))
                            ary_StyleSting.append(info_Text)
                            ary_Text = []
                        }
                    }
                }
            }
            else if isLineM == false {
                
                let info_Text = infoText(text: ary_Text.joined(separator: " "))
                ary_StyleSting.append(info_Text)
            }
            else {
                
                while ary_LineText.count > 0 {
                    
                    let info_Text = infoText(text: ary_LineText[0])
                    ary_StyleSting.append(info_Text)
                    ary_LineText.remove(at: 0)
                    
                    if ary_Line.contains(ary_StyleSting.count) {
                        
                        let info_Text = infoText(text: "", line: true)
                        ary_StyleSting.append(info_Text)
                    }
                }
            }
            
            style_Copy.effect.texts = ary_StyleSting
        }

        print("calllll---------> Finished")
        
        if self.isFisrtLoaded == true {
         
            self.vw_History.addToHistoty(style: style_Copy)
        }
        else {
            
            self.isFisrtLoaded = true
        }
        
        self.delegate?.text?(view: self, changeStyle: style_Copy)
        
        if self.vw_History.muary_History.count == 1 {
            
            self.setMenuArray()
        }
    }
}

extension TextVW: HistoryVWDelegate {
    
    func history(view: HistoryVW, didSelected style: infoStyle) {
        
        self.delegate?.text?(view: self, changeStyle: style)
    }
}

extension TextVW: ColorVWDelegate {
    
    func color(view: ColorVW, didSelected color: UIColor) {
        
        self.delegate?.text?(view: self, changeColor: color)
    }
}

extension TextVW: ShadowVWDelegate {    
    
    func shadow(view: ShadowVW, Change value: Any, With type: ShadowValue) {
        
        self.delegate?.text?(view: self, ChangeShadow: value, With: type)
    }
}

extension TextVW: GradientVWDelegate {
    
    func gradient(view: GradientVW, ShouldChange isEnable: Bool) {
        
        (self.currentLayer.info as! infoLayer).gradient.isGradient = isEnable
//        self.delegate?.textDidChangeGradient?(view: self)
    }
    
    func gradient(view: GradientVW, DidChange colors: [UIColor], ratio: Float, With direction: Float) {
        
        (self.currentLayer.info as! infoLayer).gradient.colors = colors
        (self.currentLayer.info as! infoLayer).gradient.ratio = ratio
        (self.currentLayer.info as! infoLayer).gradient.direction = direction
        self.delegate?.textDidChangeGradient?(view: self)
    }
}
