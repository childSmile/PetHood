//
//  ScaningView.h
//  PetHood
//
//  Created by MacPro on 2024/6/4.
//


#import <UIKit/UIKit.h>

@interface ScaningView : UIView
- (instancetype)initWithFrame:(CGRect)frame outsideViewLayer:(CALayer *)outsideViewLayer;

+ (instancetype)scanningQRCodeViewWithFrame:(CGRect )frame outsideViewLayer:(CALayer *)outsideViewLayer;

/** 移除定时器(切记：一定要在Controller视图消失的时候，停止定时器) */
- (void)removeTimer;
@end
