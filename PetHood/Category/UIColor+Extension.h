//
//  UIColor+Extension.h
//  PetHood
//
//  Created by MacPro on 2024/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///渐变色的方向
typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};


@interface UIColor (Extension)

+(UIColor *)randomColor;

/**
 base64 字符串转图片
 @param base 字符串数据
 */
+ (UIImage *)imageWithBase64Data:(id)base;

/**
 返回一张渐变色的图片
 @param colors 渐变颜色
 @param gradientType 渐变色方向
 @param imgSize 图片大小
 */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;


@end

NS_ASSUME_NONNULL_END
