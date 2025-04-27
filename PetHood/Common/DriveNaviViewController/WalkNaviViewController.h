//
//  WalkNaviViewController.h
//  PetHood
//
//  Created by MacPro on 2024/7/1.
//

#import "ZBaseViewController.h"
#import <AMapNaviKit/AMapNaviWalkView.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalkNaviViewController : ZBaseViewController

@property (nonatomic , strong) AMapNaviWalkView *walkView;

@end

NS_ASSUME_NONNULL_END
