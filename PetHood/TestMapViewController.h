//
//  TestMapViewController.h
//  PetHood
//
//  Created by MacPro on 2024/6/18.
//

#import <UIKit/UIKit.h>
#import "ZBaseViewController.h"

#import <AMapSearchKit/AMapCommonObj.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapNaviKit/MAAnnotation.h>

NS_ASSUME_NONNULL_BEGIN

@interface POIAnnotation : NSObject <MAAnnotation>

- (id)initWithPOI:(AMapPOI *)poi;

@property (nonatomic, readwrite ,strong) AMapPOI *poi;

@property (nonatomic , assign) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

@end

@interface TestMapViewController : ZBaseViewController

@end

NS_ASSUME_NONNULL_END
