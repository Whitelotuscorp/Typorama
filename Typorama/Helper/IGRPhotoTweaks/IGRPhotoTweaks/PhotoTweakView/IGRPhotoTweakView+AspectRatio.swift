//
//  IGRPhotoTweakView+AspectRatio.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    public func resetAspectRect() {
        
        UIView.animate(withDuration: kAnimationDuration + 0.1, animations: {
            
            self.cropView.frame = CGRect(x: CGFloat.zero,
                                         y: CGFloat.zero,
                                         width: self.originalSize.width,
                                         height: self.originalSize.height)
            self.layoutIfNeeded()
            self.cropView.center = self.scrollView.center
            self.cropView.resetAspectRect()
            
            self.cropViewDidStopCrop(self.cropView)
            
        })
    }
    
    public func setCropAspectRect(aspect: String) {
        
        UIView.animate(withDuration: kAnimationDuration + 0.1, animations: {
            
            self.cropView.frame = self.cropView.setCropAspectRect(aspect: aspect, maxSize:self.originalSize)
            self.layoutIfNeeded()
            self.cropView.center = self.scrollView.center
            
            self.cropViewDidStopCrop(self.cropView)
        })
    }
    
    public func setCropAspectRectRecall(aspect: String) {
        
        UIView.animate(withDuration: kAnimationDuration + 0.1, animations: {
            
            self.cropView.frame = self.cropView.setCropAspectRect(aspect: aspect, maxSize:self.originalSize)
            self.layoutIfNeeded()
            self.cropView.center = self.scrollView.center
        })
    }
    
    public func lockAspectRatio(_ lock: Bool) {
        self.cropView.lockAspectRatio(lock)
    }
}
