//
//  Utility.swift
//  Typorama
//
//  Created by Apple on 10/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Photos

class Utility: NSObject {

}

extension String {
    
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

extension NSAttributedString {
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)        
        return ceil(boundingBox.width)
    }
}

extension UIColor {
    
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}

extension UIImageView {
    
    func fetchImage(asset: infoPhoto, targetSize: CGSize) {
        
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset.asset!, targetSize: targetSize, contentMode: PHImageContentMode.default, options: options) { image, _ in
            guard let image = image else { return }
            asset.image = image
            self.image = image
        }
    }
    
    func fetchImage111(asset: PHAsset, targetSize: CGSize) {
        
        let options = PHImageRequestOptions()
        options.version = .original
        
        PHCachingImageManager.init().requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.default, options: options) { (image, info) in
            
            guard let image = image else { return }
            self.image = image
        }
    }
}

extension UILabel{
    
    func adjustFontSizeToFitRect(rect : CGRect){
        
        if text == nil{
            return
        }
        
        frame = rect
        
        let maxFontSize: CGFloat = 100.0
        let minFontSize: CGFloat = 5.0
        
        var q = Int(maxFontSize)
        var p = Int(minFontSize)
        
        let constraintSize = CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude)
        
        while(p <= q){
            let currentSize = (p + q) / 2
            font = font.withSize( CGFloat(currentSize) )
            let text = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font:font as Any])
            let textRect = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, context: nil)
            
            let labelSize = textRect.size
            
            if labelSize.height < frame.height &&
                labelSize.height >= frame.height-10 &&
                labelSize.width < frame.width &&
                labelSize.width >= frame.width-10 {
                break
            }else if labelSize.height > frame.height || labelSize.width > frame.width{
                q = currentSize - 1
            }else{
                p = currentSize + 1
            }
        }
    }
}
