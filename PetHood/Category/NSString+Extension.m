//
//  NSString+Extension.m
//  PetHood
//
//  Created by MacPro on 2024/7/22.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


//https://www.jianshu.com/p/b821607606c9
+ (NSMutableAttributedString *)stringWithHighLightSubstring:(NSString *)totalString substring:(NSString *)substring color:(UIColor *)highColor{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSString * copyTotalString = totalString;
    NSMutableString * replaceString = [NSMutableString stringWithString:@" "];
    for (int i = 0; i < substring.length; i ++) {
        NSString *singleString = [substring substringWithRange:NSMakeRange(i, 1)];
        while ([copyTotalString rangeOfString:singleString].location != NSNotFound) {
             NSRange range = [copyTotalString rangeOfString:singleString];
             //颜色如果统一的话可写在这里，如果颜色根据内容在改变，可把颜色作为参数，调用方法的时候传入
             [attributedString addAttribute:NSForegroundColorAttributeName value:highColor range:range];
             copyTotalString = [copyTotalString stringByReplacingCharactersInRange:range withString:replaceString];
         }
    }
    return attributedString;
}


@end
