//
//  ZCGUtilities.m
//  PetHood
//
//  Created by MacPro on 2024/6/28.
//

#import "ZCGUtilities.h"

//@implementation ZCGUtilities
//
//@end

#import <Accelerate/Accelerate.h>

BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
     }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

CGFloat tabBarHeight() {
    CGFloat height = 49;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            if (isIPhoneXSeries()) {
                height = 83;
            }else {
                height = 69;
            }
        }
    }
    return height;
}










CGFloat PHNoCeilDHPXscale(CGFloat px){
    static CGFloat screenRatio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat realwidth = width > height ? height : width;
        screenRatio = realwidth/375;
    });
    return ceilf((px) * screenRatio);
}


CGFloat PHDHPXscale(CGFloat px){
    static CGFloat screenRatio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat realwidth = width > height ? height : width;
        screenRatio = realwidth/375;
        screenRatio = screenRatio > 1.5 ? 1.5 : screenRatio;
    });
    return ceilf((px) * screenRatio);
}


CGFloat PHDHPXscaleH(CGFloat px){
    static CGFloat screenRatio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat realHeight = width > height ? width : height;
        screenRatio = realHeight/812;
        screenRatio = screenRatio > 1.5 ? 1.5 : screenRatio;
    });
    return ceilf((px) * screenRatio);
}


CGFloat IPadDHPXscale(CGFloat px){
    static CGFloat widthRatio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat realwidth = width > height ? height : width;
        widthRatio = realwidth >= 810 ? 1.5 : 1.0;
    });
    return ceilf((px) * widthRatio);
}






CGFloat PHStatusBarHeight(void) {
    static CGFloat statusBar_H;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
            NSSet *set = [UIApplication sharedApplication].connectedScenes;
            UIWindowScene *windowScene = [set anyObject];
            UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
            statusBar_H = statusBarManager.statusBarFrame.size.height;
        } else {
            statusBar_H = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    });
    return statusBar_H;
}

CGFloat PHNavBarHeight(void) {
    static CGFloat NavBarHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NavBarHeight = PHStatusBarHeight() + 56.0f;
    });
    return NavBarHeight;
}

CGFloat PHSafeArea_Bottom(void) {
    static CGFloat bottomHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bottomHeight = IS_IPHONEX_SURE ? 17 : 0;
    });
    return bottomHeight;
}

CGFloat PHScreenPadding(void) {
    static CGFloat padding;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        padding = IS_IPHONEX_SURE ? 44 : 20;
    });
    return padding;
}

NSInteger PHDeviceType(void) {
    static NSInteger terminal;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        terminal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2 : 1;
    });
    return terminal;
}

CGFloat PHScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}


CGFloat PHMaxScreenSizeWidth() {
    static CGFloat maxWidth = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       CGSize size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.width = tmp;
        }
        maxWidth = size.width;
    });
    return maxWidth;
}


CGSize PHScreenRealSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

CGSize PHScreenSize() {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        int  scrWidth = MAX(screenFrame.size.width, screenFrame.size.height);
        int  scrHeight = MIN(screenFrame.size.width, screenFrame.size.height);
        return CGSizeMake(scrWidth, scrHeight);
    } else {
        int  scrWidth = MIN(screenFrame.size.width, screenFrame.size.height);
        int  scrHeight = MAX(screenFrame.size.width, screenFrame.size.height);
        return CGSizeMake(scrWidth, scrHeight);
    }
}
