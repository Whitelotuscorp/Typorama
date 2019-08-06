//
//  ZDStickerView.h
//
//  Created by Seonghyun Kim on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZDSTICKERVIEW_BUTTON_NULL,
    ZDSTICKERVIEW_BUTTON_DEL,
    ZDSTICKERVIEW_BUTTON_RESIZE,
    ZDSTICKERVIEW_BUTTON_CUSTOM,
    ZDSTICKERVIEW_BUTTON_MAX
} ZDSTICKERVIEW_BUTTONS;

@protocol ZDStickerViewDelegate;

@interface ZDStickerView : UIView
{
    CGFloat _lastScale;
}


@property (assign, nonatomic) UIView *contentView;

@property (nonatomic,strong) NSString *objectID;

@property (nonatomic,strong) id info;

@property (nonatomic) BOOL preventsPositionOutsideSuperview; //default = YES

@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

@property (strong, nonatomic) id <ZDStickerViewDelegate> delegate;

@end

@protocol ZDStickerViewDelegate <NSObject>
@required
@optional
- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidEndEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidCancelEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidLongPressed:(ZDStickerView *)sticker;
- (void)stickerViewDidTapOnView:(ZDStickerView *)sticker;
- (void)stickerViewDidDoubleTapOnView:(ZDStickerView *)sticker;

@end


