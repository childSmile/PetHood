//
//  NSArray+Extension.h
//  Student_IOS
//
//  Created by MacPro on 2022/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (Extension)

/**
 过滤数组元素，将第一个令 block 返回值为 YES 的元素返回，如果不存在则返回 nil
 */
- (ObjectType _Nullable)qmui_firstMatchWithBlock:(BOOL (NS_NOESCAPE^)(ObjectType item))block;

@end

NS_ASSUME_NONNULL_END
