//
//  ZCGUtilities.h
//  PetHood
//
//  Created by MacPro on 2024/6/28.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YYKitMacro.h"

YY_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN


BOOL isIPhoneXSeries(void);
#define IS_IPHONEX_SURE isIPhoneXSeries()

CGFloat tabBarHeight(void);
#define kTabBarHeight tabBarHeight()


CGFloat IPadDHPXscale(CGFloat px);
CGFloat PHNoCeilDHPXscale(CGFloat px);
CGFloat PHDHPXscale(CGFloat px);
CGFloat PHDHPXscaleH(CGFloat px);

///ipad 宽度大于810 放大1.5倍
#define IPadDHPX(px)          IPadDHPXscale(px)
///按375宽度无上限等比放大
#define PHDHPX(px)         PHNoCeilDHPXscale(px)

///按375宽度等比放大MAX 1.5倍
#define DHPX(px)            PHDHPXscale(px)
///按812高度等比放大MAX 1.5倍
#define HDHPX(px)           PHDHPXscaleH(px)





CGFloat PHStatusBarHeight(void);
CGFloat PHNavBarHeight(void);
CGFloat PHSafeArea_Bottom(void);
CGFloat PHScreenPadding(void);
NSInteger PHDeviceType(void);

#ifndef kStatusBarHeight
#define kStatusBarHeight    PHStatusBarHeight()
#endif

#ifndef kNavBarHeight
#define kNavBarHeight       PHNavBarHeight()
#endif

#ifndef kSafeArea_Bottom
#define kSafeArea_Bottom    PHSafeArea_Bottom()
#endif

#ifndef kScreenPadding
#define kScreenPadding      PHScreenPadding()
#endif

// 终端类型 1：安卓 2：iOS
#ifndef kTerminal
#define kTerminal           2
#endif

#ifndef kDeviceType
#define kDeviceType         PHDeviceType()
#endif



/// Get main screen's scale.
CGFloat PHScreenScale(void);

/// Get main screen's size. Height is always larger than width.
CGSize PHScreenRealSize(void);

/// Get main screen's size. Height and width by current time
CGSize PHScreenSize(void);

CGFloat PHMaxScreenSizeWidth(void);


// main screen's scale
#ifndef mScreenScale
#define mScreenScale       PHScreenScale()
#endif


// main screen's size (原始竖屏size, 不跟随旋转更新)
#ifndef ScreenPortraitSize
#define ScreenPortraitSize    PHScreenRealSize()
#endif
// main screen's width (原始竖屏size宽度)
#ifndef ScreenPortraitWidth
#define ScreenPortraitWidth   PHScreenRealSize().width
#endif
// main screen's height (原始竖屏size高度)
#ifndef ScreenPortraitHeight
#define ScreenPortraitHeight  PHScreenRealSize().height
#endif



// main screen's width  (最大宽度. iphone = mScreenRealWidth / ipad = mScreenRealWidth *0.8)
#ifndef RealScreenWidth
#define RealScreenWidth   PHMaxScreenSizeWidth()
#endif


// main screen's width  (跟随旋转适配屏幕尺寸, 动态更新)
#ifndef mRotateScreenSize
#define mRotateScreenSize      PHScreenSize()
#endif

// main screen's width  (跟随旋转适配size宽度)
#ifndef mRotateScreenWidth
#define mRotateScreenWidth     PHScreenSize().width
#endif

// main screen's height (跟随旋转适配size高度)
#ifndef mRotateScreenHeight
#define mRotateScreenHeight    PHScreenSize().height
#endif



NS_ASSUME_NONNULL_END
YY_EXTERN_C_END

