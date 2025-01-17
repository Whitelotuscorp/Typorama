//
// ZDStickerView.m
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ZDStickerView.h"
#import "SPGripViewBorderView.h"
#import "UIImage+Utility.h"
#import <Posterooh-Swift.h>


#define kSPUserResizableViewGlobalInset 3.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0
#define kZDStickerViewControlSize 26.0
#define kZDStickerViewControlIconSize 22.0



@interface ZDStickerView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) SPGripViewBorderView *borderView;

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *customControl;

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;

@property (nonatomic) BOOL preventsLayoutWhileResizing;

@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;

@end



@implementation ZDStickerView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

#ifdef ZDSTICKERVIEW_LONGPRESS
- (void)longPress:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidLongPressed:)])
        {
            [self.stickerViewDelegate stickerViewDidLongPressed:self];
        }
    }
}
#endif


- (void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidClose:)])
    {
        [self.stickerViewDelegate stickerViewDidClose:self];
    }

    if (NO == self.preventsDeleting)
    {
        UIView *close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
}

- (void)customTap:(UIPanGestureRecognizer *)recognizer
{
    if (NO == self.preventsCustomButton)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCustomButtonTap:)])
        {
            [self.stickerViewDelegate stickerViewDidCustomButtonTap:self];
        }
    }
}

static CGRect boundsBeforeScaling;
static CGAffineTransform transformBeforeScaling;

- (void)pinchTranslate:(UIPinchGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        boundsBeforeScaling = recognizer.view.bounds;
        transformBeforeScaling = recognizer.view.transform;
    }

    CGPoint center = recognizer.view.center;
    
    CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity,
                                                     recognizer.scale,
                                                     recognizer.scale);
    CGRect frame = CGRectApplyAffineTransform(boundsBeforeScaling, scale);

    frame.origin = CGPointMake(center.x - frame.size.width / 2,
                               center.y - frame.size.height / 2);

    recognizer.view.transform = CGAffineTransformIdentity;
    
    if (frame.size.width < self.superview.bounds.size.width * 2 && frame.size.height < self.superview.bounds.size.height * 2) {
     
        recognizer.view.frame = frame;
    }
    recognizer.view.transform = transformBeforeScaling;
    
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)]) {
            [self.stickerViewDelegate stickerViewDidEndEditing:self];
        }
    }
}

- (void)rotateTranslate:(UIRotationGestureRecognizer *)recognizer {
    
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
    
    transformBeforeScaling = recognizer.view.transform;
    
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)]) {
            [self.stickerViewDelegate stickerViewDidEndEditing:self];
        }
    }
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        [self enableTransluceny:YES];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
        
        // Inform delegate.
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidBeginEditing:)]) {
            [self.stickerViewDelegate stickerViewDidBeginEditing:self];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        [self enableTransluceny:YES];
        
        // preventing from the picture being shrinked too far by resizing
        
        CGPoint point = [recognizer locationInView:self];
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (point.x - self.prevPoint.x);
        float wRatioChange = (wChange/(float)self.bounds.size.width);
        
        hChange = wRatioChange * self.bounds.size.height;
        
        if (self.bounds.size.width + (wChange) > self.superview.bounds.size.width * 2 || self.bounds.size.height + (hChange) > self.superview.bounds.size.height * 2) {
            
        }
        else if (self.bounds.size.width + (wChange) > self.minWidth && self.bounds.size.height + (hChange) > self.minHeight) {
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
            
            
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                   self.bounds.size.height-kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(0, 0,
                                                  kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                 0,
                                                 kZDStickerViewControlSize,
                                                 kZDStickerViewControlSize);

        }
        
        self.prevPoint = [recognizer locationOfTouch:0 inView:self];

        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        
//        NSLog(@"%f", ang);
        float angleDiff = self.deltaAngle - ang;
        
        if (NO == self.preventsResizing)
        {
            self.transform = CGAffineTransformMakeRotation(-angleDiff);
        }

        self.borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
        [self.borderView setNeedsDisplay];

        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        [self enableTransluceny:NO];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
        
        // Inform delegate.
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)]) {
            [self.stickerViewDelegate stickerViewDidEndEditing:self];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateCancelled)
    {
        // Inform delegate.
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)]) {
            [self.stickerViewDelegate stickerViewDidCancelEditing:self];
        }
    }
}

-(void)doubleTap:(UITapGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidDoubleTapOnView:)]) {
            [self.stickerViewDelegate stickerViewDidDoubleTapOnView:self];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

- (void)setupDefaultAttributes {
    
    self.undo = [[NSMutableArray alloc] init];
    
    self.logoID = @"";
    self.borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
    self.borderView.borderColor = self.borderColor;
    self.borderView.borderWidth = self.borderWidth;
    [self.borderView setHidden:NO];
    [self addSubview:self.borderView];

//    if (kSPUserResizableViewDefaultMinWidth > self.bounds.size.width*0.5)
//    {
        self.minWidth = kSPUserResizableViewDefaultMinWidth;
        self.minHeight = self.bounds.size.height * (kSPUserResizableViewDefaultMinWidth/self.bounds.size.width);
//    }
//    else
//    {
//        self.minWidth = self.bounds.size.width*0.5;
//        self.minHeight = self.bounds.size.height*0.5;
//    }

    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    self.preventsCustomButton = YES;
    self.translucencySticker = YES;
    self.allowDragging = YES;

#ifdef ZDSTICKERVIEW_LONGPRESS
    UILongPressGestureRecognizer*longpress = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self
                                                      action:@selector(longPress:)];
    [self addGestureRecognizer:longpress];
#endif

    self.deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
    kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.deleteControl.backgroundColor = [UIColor clearColor];
    self.deleteControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/ZDBtn3.png"];
    self.deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                                 action:@selector(singleTap:)];
    [self.deleteControl addGestureRecognizer:singleTap];
    [self addSubview:self.deleteControl];
    self.deleteControl.contentMode = UIViewContentModeTopLeft;
    
    self.resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
    self.frame.size.height-kZDStickerViewControlSize,
    kZDStickerViewControlSize, kZDStickerViewControlSize)];
    
    self.resizingControl.backgroundColor = [UIColor clearColor];
    self.resizingControl.userInteractionEnabled = YES;
    self.resizingControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/ZDBtn2.png"];
    UIPanGestureRecognizer*panResizeGesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                                       action:@selector(resizeTranslate:)];
    [self.resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:self.resizingControl];
    self.resizingControl.contentMode = UIViewContentModeBottomRight;
    
    self.customControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width+kZDStickerViewControlSize-kZDStickerViewControlIconSize/2,
                                                                      0,
                                                                      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.customControl.backgroundColor = [UIColor clearColor];
    self.customControl.userInteractionEnabled = YES;
    self.customControl.image = nil;
    
    // Add pinch gesture recognizer.
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                            initWithTarget:self
                            action:@selector(pinchTranslate:)];
    self.pinchRecognizer.delegate = self;
    [self addGestureRecognizer:self.pinchRecognizer];
    
    // Add rotation recognizer.
    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(rotateTranslate:)];
    self.rotationRecognizer.delegate = self;
    [self addGestureRecognizer:self.rotationRecognizer];
    
    // Add custom control recognizer.
    UITapGestureRecognizer *customTapGesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(customTap:)];
    [self.customControl addGestureRecognizer:customTapGesture];
    [self addSubview:self.customControl];
    
    UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    
    self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                            self.frame.origin.x+self.frame.size.width - self.center.x);
}

- (void)updateDelta {
    
    self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
    self.frame.origin.x+self.frame.size.width - self.center.x);
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}

- (void)setShadowView:(UIView *)newShadowView
{
    [self.shadowView removeFromSuperview];
    _shadowView = newShadowView;
    
    self.shadowView.frame = self.bounds;
//    self.shadowView.frame = CGRectInset(self.bounds,
//                                        kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
//                                        kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;    
    [self addSubview:self.shadowView];
    
    if (![self.shadowView isKindOfClass:[UIView self]]) {
        
        for (UIView *subview in [self.shadowView subviews])
        {
            [subview setFrame:CGRectMake(0, 0,
                                         self.shadowView.frame.size.width,
                                         self.shadowView.frame.size.height)];
            
            subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
    }
    
    [self bringSubviewToFront:self.contentView];
    [self bringSubviewToFront:self.borderView];
    [self bringSubviewToFront:self.resizingControl];
    [self bringSubviewToFront:self.deleteControl];
    [self bringSubviewToFront:self.customControl];
}

- (void)setContentView:(UIView *)newContentView
{
    [self.contentView removeFromSuperview];
    _contentView = newContentView;

    self.contentView.frame = self.bounds;
//    self.contentView.frame = CGRectInset(self.bounds,
//                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
//                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//printf(self.contentView.frame)
    [self addSubview:self.contentView];

    if (![self.contentView isKindOfClass:[UIView self]]) {
     
        for (UIView *subview in [self.contentView subviews])
        {
            [subview setFrame:CGRectMake(0, 0,
                                         self.contentView.frame.size.width,
                                         self.contentView.frame.size.height)];
            
            subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
    }

    [self bringSubviewToFront:self.borderView];
    [self bringSubviewToFront:self.resizingControl];
    [self bringSubviewToFront:self.deleteControl];
    [self bringSubviewToFront:self.customControl];
}

- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    
    self.contentView.frame = self.bounds;
//    self.contentView.frame = CGRectInset(self.bounds,
//                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
//                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    if (![self.contentView isKindOfClass:[UIView self]]) {
        
        for (UIView *subview in [self.contentView subviews])
        {
            [subview setFrame:CGRectMake(0, 0,
                                         self.contentView.frame.size.width,
                                         self.contentView.frame.size.height)];
            
            subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
    }
    
    self.shadowView.frame = self.bounds;
//    self.shadowView.frame = CGRectInset(self.bounds,
//                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
//                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (![self.shadowView isKindOfClass:[UIView self]]) {
        
        for (UIView *subview in [self.shadowView subviews])
        {
            [subview setFrame:CGRectMake(0, 0,
                                         self.shadowView.frame.size.width,
                                         self.shadowView.frame.size.height)];
            
            subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
    }
    
    self.borderView.frame = CGRectInset(self.bounds,
                                        kSPUserResizableViewGlobalInset,
                                        kSPUserResizableViewGlobalInset);

    self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                           self.bounds.size.height-kZDStickerViewControlSize,
                                           kZDStickerViewControlSize,
                                           kZDStickerViewControlSize);

    self.deleteControl.frame = CGRectMake(0, 0,
                                          kZDStickerViewControlSize, kZDStickerViewControlSize);

    self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                         0,
                                         kZDStickerViewControlSize,
                                         kZDStickerViewControlSize);

    [self.borderView setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidBeginEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidBeginEditing:self];
    }
    
    if (!self.allowDragging)
    {
        UITouch *touch = [touches anyObject];
        self.touchStart = [touch locationInView:self];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.touchStart = [touch locationInView:self.superview];


    [self enableTransluceny:YES];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self enableTransluceny:NO];
    if (!self.allowDragging)
    {
        CGPoint touch = [[touches anyObject] locationInView:self];
        [self eraseUsingTouchLocation:touch EndEditing:YES];
        self.touchStart = touch;
    }
    
    // Notify the delegate we've ended our editing session.
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidEndEditing:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self enableTransluceny:NO];

    // Notify the delegate we've ended our editing session.
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidCancelEditing:self];
    }
}



- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.touchStart.x,
                                    self.center.y + touchPoint.y - self.touchStart.y);

    if (self.preventsPositionOutsideSuperview)
    {
        // Ensure the translation won't cause the view to move offscreen.
//        CGFloat midPointX = CGRectGetMidX(self.bounds);
//        if (newCenter.x > self.superview.bounds.size.width - midPointX)
//        {
//            newCenter.x = self.superview.bounds.size.width - midPointX;
//        }
//
//        if (newCenter.x < midPointX)
//        {
//            newCenter.x = midPointX;
//        }
//
//        CGFloat midPointY = CGRectGetMidY(self.bounds);
//        if (newCenter.y > self.superview.bounds.size.height - midPointY)
//        {
//            newCenter.y = self.superview.bounds.size.height - midPointY;
//        }
//
//        if (newCenter.y < midPointY)
//        {
//            newCenter.y = midPointY;
//        }
    }
    else {
        
        if (newCenter.x > self.superview.bounds.size.width) {
            
            newCenter.x = self.superview.bounds.size.width;
        }
        else if (newCenter.x < 0) {
            
            newCenter.x = 0;
        }
        
        if (newCenter.y > self.superview.bounds.size.height) {
            
            newCenter.y = self.superview.bounds.size.height;
        }
        else if (newCenter.y < 0) {
            
            newCenter.y = 0;
        }
    }

    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.allowDragging)
    {
        CGPoint touch = [[touches anyObject] locationInView:self];
        [self eraseUsingTouchLocation:touch EndEditing:NO];
        self.touchStart = touch;
    }
    else {
        
        [self enableTransluceny:YES];

        CGPoint touchLocation = [[touches anyObject] locationInView:self];
        if (CGRectContainsPoint(self.resizingControl.frame, touchLocation))
        {
            return;
        }

        CGPoint touch = [[touches anyObject] locationInView:self.superview];
        [self translateUsingTouchLocation:touch];
        self.touchStart = touch;
    }
}

-(CGRect) updatePathFrom:(CGPoint)start To:(CGPoint)end WithSize:(CGFloat)width {
    
    CGSize size = CGSizeMake(end.x - start.x + width*2, end.y - start.y + width*2);
    return CGRectMake(start.x - width, start.y - width, size.width, size.height);
}

- (void)eraseUsingTouchLocation:(CGPoint)currentPoint EndEditing:(BOOL)end {
    
    infoLayer *info_L = (infoLayer*)self.info;
    UIImage *img_BG = [info_L getImage];
    UIImage *img_Main = [info_L getMain];
    CGFloat sizeP = [info_L getEraserSize];
    CGFloat intensity = [info_L getEraserIntensity];
//    UIColor *color = [[info_L getColor] colorWithAlphaComponent:[info_L getEraserIntensity]];
    
    CGSize size = img_BG.size;
    CGRect area_BG = CGRectMake(0, 0, size.width, size.height);
    
    UIImageView *imgvw = (UIImageView *)self.contentView;
    
    CGFloat ox = (img_BG.size.width * self.touchStart.x) / imgvw.frame.size.width;
    CGFloat oy = (img_BG.size.height * self.touchStart.y) / imgvw.frame.size.height;
    
    CGFloat nx = (img_BG.size.width * currentPoint.x) / imgvw.frame.size.width;;
    CGFloat ny = (img_BG.size.height * currentPoint.y) / imgvw.frame.size.height;;

    
    UIGraphicsBeginImageContext(img_BG.size);
    [img_BG drawInRect:area_BG];
    
    // I add this
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), sizeP); //size
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), ox, oy);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), nx, ny);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIGraphicsBeginImageContext(img_BG.size);
//    [img_Main drawInRect:area_BG];
//    UIImage *imageMain = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    CGRect rect = [self updatePathFrom:CGPointMake(ox, oy) To:CGPointMake(nx, ny) WithSize:sizeP];
//    CGImageRef imageRef = CGImageCreateWithImageInRect([imageMain CGImage], rect);
//    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:area_BG blendMode:kCGBlendModeNormal alpha:1.0];
//    [cropImage drawInRect:rect blendMode:kCGBlendModeNormal alpha: intensity];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    ((UIImageView *)self.contentView).image = image;
//    [self.contentView setNeedsDisplay];
    [self setNeedsDisplay];
    
    if (end == YES) {
        
        [self.undo addObject:image];
    }
    
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerView:EraseImage:)])
    {
        [self.stickerViewDelegate stickerView:self EraseImage:image];
    }
}

#pragma mark - Property setter and getter

- (void)hideDelHandle
{
    self.deleteControl.hidden = YES;
}



- (void)showDelHandle
{
    self.deleteControl.hidden = NO;
}



- (void)hideEditingHandles
{
    self.resizingControl.hidden = YES;
    self.deleteControl.hidden = YES;
    self.customControl.hidden = YES;
    [self.borderView setHidden:YES];
}

- (void)showEditingHandles
{
    self.resizingControl.hidden = NO;
    self.deleteControl.hidden = NO;
    [self.borderView setHidden:NO];
}



- (void)showEditingHandles1
{
    if (NO == self.preventsCustomButton)
    {
        self.customControl.hidden = NO;
    }
    else
    {
        self.customControl.hidden = YES;
    }

    if (NO == self.preventsDeleting)
    {
        self.deleteControl.hidden = NO;
    }
    else
    {
        self.deleteControl.hidden = YES;
    }

    if (NO == self.preventsResizing)
    {
        self.resizingControl.hidden = NO;
    }
    else
    {
        self.resizingControl.hidden = YES;
    }

    [self.borderView setHidden:NO];
}



- (void)showCustomHandle
{
    self.customControl.hidden = NO;
}



- (void)hideCustomHandle
{
    self.customControl.hidden = YES;
}



- (void)setButton:(ZDStickerViewButton)type image:(UIImage*)image
{
    switch (type)
    {
        case ZDStickerViewButtonResize:
            self.resizingControl.image = image;
            break;
        case ZDStickerViewButtonDel:
            self.deleteControl.image = image;
            break;
        case ZDStickerViewButtonCustom:
            self.customControl.image = image;
            break;

        default:
            break;
    }
}



- (BOOL)isEditingHandlesHidden
{
    return self.borderView.hidden;
}



- (void)enableTransluceny:(BOOL)state
{
    if (self.translucencySticker == YES)
    {
        if (state == YES)
        {
            self.alpha = 0.65;
        }
        else
        {
            self.alpha = 1.0;
        }
    }
}

- (UIColor *)borderColor {
    return self.borderView.borderColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.borderView.borderColor = borderColor;
}

- (CGFloat)borderWidth {
    return self.borderView.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.borderView.borderWidth = borderWidth;
}

- (BOOL)allowPinchToZoom {
    return self.pinchRecognizer.isEnabled;
}

- (void)setAllowPinchToZoom:(BOOL)allowPinchToZoom {
    self.pinchRecognizer.enabled = allowPinchToZoom;
}

- (BOOL)allowRotationGesture {
    return self.rotationRecognizer.isEnabled;
}

-(void)setAllowRotationGesture:(BOOL)allowRotationGesture {
    self.rotationRecognizer.enabled = allowRotationGesture;
}


@end
