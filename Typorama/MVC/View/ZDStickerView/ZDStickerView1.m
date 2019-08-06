//
//  ZDStickerView.m
//
//  Created by Seonghyun Kim on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ZDStickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kSPUserResizableViewGlobalInset 0.0
#define kSPUserResizableViewInteractiveBorderSize 0.0
#define kZDStickerViewControlSize 36.0


@interface ZDStickerView ()

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;

@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;
@property (nonatomic) CGPoint beginStart;

@end

@implementation ZDStickerView
@synthesize contentView, touchStart;

@synthesize prevPoint;
@synthesize deltaAngle, startTransform; //rotation
@synthesize preventsPositionOutsideSuperview;
@synthesize minWidth, minHeight;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)longPress:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if([_delegate respondsToSelector:@selector(stickerViewDidLongPressed:)]) {
            [_delegate stickerViewDidLongPressed:self];
        }
    }
}


-(void)customTap:(UITapGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        int xB = self.beginStart.x;
        int yB = self.beginStart.y;
        int xC = self.center.x;
        int yC = self.center.y;
        
        if (xB == xC && yB == yC) {
         
            if([_delegate respondsToSelector:@selector(stickerViewDidTapOnView:)]) {
                
                [_delegate stickerViewDidTapOnView:self];
            }
        }
    }
}

-(void)doubleTap:(UITapGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        int xB = self.beginStart.x;
        int yB = self.beginStart.y;
        int xC = self.center.x;
        int yC = self.center.y;
        
        if (xB == xC && yB == yC) {
            
            if([_delegate respondsToSelector:@selector(stickerViewDidDoubleTapOnView:)]) {
                
                [_delegate stickerViewDidDoubleTapOnView:self];
            }
        }
    }
}

- (void)setupDefaultAttributes {

    self.minWidth = 40;
    self.minHeight = 35;
    
    self.preventsPositionOutsideSuperview = YES;

    UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longpress.minimumPressDuration=2.0;
    [self addGestureRecognizer:longpress];
    
    UITapGestureRecognizer * customTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customTap:)];
    customTapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:customTapGesture];
    
    UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x);
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        [self setupDefaultAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setContentView:(UIView *)newContentView
{
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
    
//    for (UIView* subview in [contentView subviews]) {
//        [subview setFrame:CGRectMake(0, 0,
//                                     contentView.frame.size.width,
//                                     contentView.frame.size.height)];
//        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    }
}

- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    for (UIView* subview in [contentView subviews]) {
        [subview setFrame:CGRectMake(0, 0,
                                     contentView.frame.size.width,
                                     contentView.frame.size.height)];
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    touchStart = [touch locationInView:self.superview];
    self.beginStart = self.center;
    if([_delegate respondsToSelector:@selector(stickerViewDidBeginEditing:)]) {
        [_delegate stickerViewDidBeginEditing:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
    if([_delegate respondsToSelector:@selector(stickerViewDidEndEditing:)]) {
        [_delegate stickerViewDidEndEditing:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
    if([_delegate respondsToSelector:@selector(stickerViewDidCancelEditing:)]) {
        [_delegate stickerViewDidCancelEditing:self];
    }
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y);
    
    if (self.preventsPositionOutsideSuperview) {
        
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX) {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }
        if (newCenter.x < midPointX) {
            newCenter.x = midPointX;
        }
        
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY) {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }
        if (newCenter.y < midPointY) {
            newCenter.y = midPointY;
        }
    }
   
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    touchStart = touch;
}

@end
