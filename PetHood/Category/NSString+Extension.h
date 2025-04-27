//
//  NSString+Extension.h
//  PetHood
//
//  Created by MacPro on 2024/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

+ (NSMutableAttributedString *)stringWithHighLightSubstring:(NSString *)totalString substring:(NSString *)substring color:(UIColor *)highColor;

@end

NS_ASSUME_NONNULL_END
