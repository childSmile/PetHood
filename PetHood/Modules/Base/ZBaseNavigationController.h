//
//  ZBaseNavigationController.h
//  PetHood
//
//  Created by MacPro on 2024/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBaseNavigationController : UINavigationController

@property (nonatomic, weak) UIViewController *lastController;
/**
 是否已经push进去相同Class的控制器，当前控制器还没加载也有记录
 @param contrllerType contrller Class
 @return BOOL
 */
+ (BOOL)isAleradyPushContrllerType:(Class)contrllerType navigationContrller:(UINavigationController *)navigation;

@end

@interface UINavigationController (Extension)

- (void)navigationRemoveContrller:(UIViewController *)controller;
/**
 pop时返回到一个新Controller，适用于传值
 @param newController pop时返回到一个新Controller
 @param animated animated
 */
- (void)popToNewController:(UIViewController *)newController animated:(BOOL)animated;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
/**
 导航push，返回时返回到一个新控制器，不适用于需要传值的需求
 @param viewController 显示 Controller
 @param backController 返回时返回到一个新控制器
 @param animated animated
 */
- (void)pushViewController:(UIViewController *)viewController backToController:(UIViewController *)backController animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController backToControllerIndex:(NSInteger)controllerIndex animated:(BOOL)animated;
@end


NS_ASSUME_NONNULL_END
