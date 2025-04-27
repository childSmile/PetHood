//
//  NSArray+Extension.m
//  Student_IOS
//
//  Created by MacPro on 2022/6/27.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

- (id)qmui_firstMatchWithBlock:(BOOL (NS_NOESCAPE^)(id _Nonnull))block {
    if (!block) {
        return nil;
    }
    for (id item in self) {
        if (block(item)) {
            return item;
        }
    }
    return nil;
}


@end
