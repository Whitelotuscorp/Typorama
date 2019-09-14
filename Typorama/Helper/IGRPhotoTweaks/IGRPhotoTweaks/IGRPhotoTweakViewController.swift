//
//  IGRPhotoTweakViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit


public protocol IGRPhotoTweakViewControllerDelegate : class {
    
    /**
     Called on image cropped.
     */
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController)
}

open class IGRPhotoTweakViewController: UIViewController {
    
    //MARK: - Public VARs
    
    /*
     Image to process.
     */
    public var image: UIImage!
    public var imageBG: UIImage!
    
    public var sizeFrame : String = ""
    /*
     The optional photo tweaks controller delegate.
     */
    public weak var delegate: IGRPhotoTweakViewControllerDelegate?
    
    //MARK: - Protected VARs
    
    /*
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    internal var isAutoSaveToLibray: Bool = false
    
    //MARK: - Extra VARs

    
    
    
    public lazy var photoView: IGRPhotoTweakView! = { [unowned self] by in
        
        let top_Gap : CGFloat = 10
        let left_Gap : CGFloat = 0
        
        let y = UIApplication.shared.statusBarFrame.height + 50
        
        let new_frame = CGRect(x: left_Gap, y: y, width: self.view.bounds.width - (left_Gap * 2), height: self.view.bounds.height - (y + 190))
        let photoView = IGRPhotoTweakView(frame: new_frame,
                                          image: self.image,
                                          customizationDelegate: self)
        photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoView.backgroundColor = UIColor.clear
        self.view.addSubview(photoView)
        
        return photoView
        }(())
    
    // MARK: - Life Cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        self.setupThemes()
        self.setupSubviews()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.photoView.applyDeviceRotation()
        })
    }
    
    fileprivate func setupSubviews() {
        
        self.view.sendSubviewToBack(self.photoView)
        self.photoView.clipsToBounds = true
        
        let rect = UIScreen.main.bounds
        let top_Blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        top_Blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        top_Blur.frame = rect
        self.view.addSubview(top_Blur)
        self.view.sendSubviewToBack(top_Blur)
        
//        let layerBlur = self.view.subviews.index(of: top_Blur)
//        self.view.exchangeSubview(at: 0, withSubviewAt: layerBlur!)
        
        let imgvwBG = UIImageView(frame: rect)
        imgvwBG.image = self.imageBG
        imgvwBG.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgvwBG.backgroundColor = UIColor.red
        self.view.addSubview(imgvwBG)
        self.view.sendSubviewToBack(imgvwBG)
        
//        let layerPossession = self.view.subviews.index(of: imgvwBG)
//        self.view.exchangeSubview(at: 0, withSubviewAt: layerPossession!)
    }
    
    open func setupThemes() {
        
        IGRPhotoTweakView.appearance().backgroundColor = UIColor.clear
        IGRPhotoContentView.appearance().backgroundColor = UIColor.clear
        IGRCropView.appearance().backgroundColor = UIColor.clear
        IGRCropGridLine.appearance().backgroundColor = UIColor.gridLine()
        IGRCropLine.appearance().backgroundColor = UIColor.cropLine()
        IGRCropCornerView.appearance().backgroundColor = UIColor.clear
        IGRCropCornerLine.appearance().backgroundColor = UIColor.cropLine()
        IGRCropMaskView.appearance().backgroundColor = UIColor.clear
        
    }
    
    // MARK: - Public
    
    public func resetView() {
        self.photoView.resetView()
        self.stopChangeAngle()
    }
    
    public func dismissAction() {
        
        self.delegate?.photoTweaksControllerDidCancel(self)
    }
    
    public func cropAction() {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: self.photoView.radians)
        // scale
        
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        if let fixedImage = self.image.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(transform,
                                                       zoomScale: self.photoView.scrollView.zoomScale,
                                                       sourceSize: self.image.size,
                                                       cropSize: self.photoView.cropView.frame.size,
                                                       imageViewSize: self.photoView.photoContentView.bounds.size)
            
            let image = UIImage(cgImage: imageRef)
            
            if self.isAutoSaveToLibray {
                
                self.saveToLibrary(image: image)
            }
            
            self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
        }
    }
    
    //MARK: - Customization
    
    open func customBorderColor() -> UIColor {
        return UIColor.cropLine()
    }
    
    open func customBorderWidth() -> CGFloat {
        return 1.0
    }
    
    open func customCornerBorderWidth() -> CGFloat {
        return kCropViewCornerWidth
    }
    
    open func customCornerBorderLength() -> CGFloat {
        return kCropViewCornerLength
    }
    
    open func customCropLinesCount() -> Int {
        return kCropLinesCount
    }
    
    open func customGridLinesCount() -> Int {
        return kGridLinesCount
    }
    
    open func customIsHighlightMask() -> Bool {
        return true
    }
    
    open func customHighlightMaskAlphaValue() -> CGFloat {
        return 1.0
    }
    
    open func customCanvasInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: kCanvasHeaderHeigth, left: 0, bottom: 0, right: 0)
    }
}
