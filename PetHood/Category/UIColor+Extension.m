//
//  UIColor+Extension.m
//  PetHood
//
//  Created by MacPro on 2024/7/2.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+(UIColor *)randomColor{
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    
}

+ (UIImage *)imageWithBase64Data:(id)base
{
    if ([base isKindOfClass:[NSString class]]) {
        NSData * imageData =[[NSData alloc] initWithBase64EncodedString:base options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *photo = [UIImage imageWithData:imageData];
        return photo;
    }else {
        return [UIImage new];
    }
}

///返回一张渐变色的图片
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];

    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }

    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;

    switch (gradientType) {
        case GradientTypeTopToBottom:
//            start = CGPointMake(0.0, 0.0);
//            end = CGPointMake(0.0, imgSize.height);
            start = CGPointMake(imgSize.width/2, 0.0);
            end = CGPointMake(imgSize.width/2, imgSize.height);
            break;
        case GradientTypeLeftToRight:
//            start = CGPointMake(0.0, 0.0);
//            end = CGPointMake(imgSize.width, 0.0);
            start = CGPointMake(0.0, imgSize.height/2);
            end = CGPointMake(imgSize.width, imgSize.height/2);
            break;
        case GradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
            
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}


@end
