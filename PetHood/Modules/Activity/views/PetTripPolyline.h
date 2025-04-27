//
//  PetTripPolyline.h
//  PetHood
//
//  Created by MacPro on 2024/7/15.
//

#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PetTripPolyline : MABaseOverlay

@property (nonatomic , assign) BOOL traveled;
@property (nonatomic , strong) MAPolyline *polyline;

- (id)initWithPolyline:(MAPolyline *)polyline traveled:(BOOL)traveled;

@end

NS_ASSUME_NONNULL_END
