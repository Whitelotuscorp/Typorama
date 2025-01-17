//
//  PaddingLabel.swift
//  PaddingLabel
//
//  Created by levantAJ on 11/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

@IBDesignable public class PaddingLabel: UILabel {
    
    @IBInspectable public var topInset: CGFloat = 0.0
    @IBInspectable public var bottomInset: CGFloat = 0.0
    @IBInspectable public var leftInset: CGFloat = 0.0
    @IBInspectable public var rightInset: CGFloat = 0.0
    
    override public func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
