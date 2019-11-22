//
//  GradientLayer.swift
//  DemoGradient
//
//  Created by Apple on 19/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class GradientLayer: NSObject {
    
    var fadeIntensity: Float = 1.0
    
    static var instance: GradientLayer!
    
    class func shared() -> GradientLayer {
        
        self.instance = (self.instance ?? GradientLayer())
        return self.instance
    }
    
    func colorToCGColor(color: [UIColor]) -> [CGColor] {
        
        var colorCG : [CGColor] = []
        
        for clr in color {
            
            colorCG.append(clr.cgColor)
        }
        
        return colorCG
    }
    
    func gradientImageWithBounds(bounds: CGRect, colors: [UIColor], angleº: Float, location: Float) -> UIImage {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = self.colorToCGColor(color: colors)
        
        let points = self.startEndPoints(angleº: angleº)
        gradientLayer.startPoint = points.0
        gradientLayer.endPoint = points.1
        
        let colorLoc = self.locations(colorRatio: location)
        gradientLayer.locations = [NSNumber(value: colorLoc.0), NSNumber(value: colorLoc.1)]
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func startEndPoints(angleº: Float) -> (CGPoint, CGPoint) {
        
      var rotCalX: Float = 0.0
      var rotCalY: Float = 0.0
      
      // to convert from 0...360 range to 0...4
      let rotate = angleº / 90
      
      // 1...4 can be understood to denote the four quadrants
      if rotate <= 1
      {
        rotCalY = rotate
      }
      else if rotate <= 2
      {
        rotCalY = 1
        rotCalX = rotate - 1
      }
      else if rotate <= 3
      {
        rotCalX = 1
        rotCalY = 1 - (rotate - 2)
      }
      else if rotate <= 4
      {
        rotCalX = 1 - (rotate - 3)
      }
      
      let start = CGPoint(x: 1 - CGFloat(rotCalY), y: 0 + CGFloat(rotCalX))
      let end = CGPoint(x: 0 + CGFloat(rotCalY), y: 1 - CGFloat(rotCalX))
      
      return (start, end)
    }
    
    func locations(colorRatio : Float) -> (Float, Float) {
        
        let divider = fadeIntensity / self.divider(colorRatio: colorRatio)
      return(colorRatio - divider, colorRatio + divider)
    }
    
    func divider(colorRatio : Float) -> Float {
        
      if colorRatio == 0.1
      {
        return 10
      }
      if colorRatio < 0.5
      {
        let value = 0.5 - colorRatio + 0.5
        return 1 / (1 - value)
      }
      return 1 / (1 - colorRatio)
    }
}
