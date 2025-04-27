//
//  PetAnnotationView.h
//  PetHood
//
//  Created by MacPro on 2024/7/9.
//

#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PetAnnotationView : MAAnnotationView

@end



@interface CurrentPetAnnotationView : MAAnnotationView
@property (nonatomic , strong) UIView *calloutView;

@end


@interface PetCalloutView : UIView

@end


@interface PetMAPointAnnotation : MAPointAnnotation

@property (nonatomic , strong) NSString *mac;
///是否是当前宠物
@property (nonatomic , assign) BOOL isCurrent;

@end
NS_ASSUME_NONNULL_END
