//
//  ZBaseViewController.h
//  PetHood
//
//  Created by MacPro on 2024/6/27.
//

#import <UIKit/UIKit.h>
#import "ZBaseNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN
@class ZBaseViewController;


@protocol ZBaseViewControllerDataSource <NSObject>
@optional
/**是否显示导航栏， 默认不显示*/
- (BOOL)viewControllerIsNeedNavBar:(ZBaseViewController *)viewController;
/*导航栏UIStatusBarStyle*/
- (UIStatusBarStyle)navControllerStatusBarStyle:(ZBaseViewController *)viewController;
@end

@interface ZBaseViewController : UIViewController<ZNavigationBarDelegate , ZNavigationBarDataSource , ZBaseViewControllerDataSource>

///导航栏标题
@property (nonatomic, copy) NSString *navTitle;
///导航栏标题色
@property (nonatomic, strong) UIColor *navTitleColor;
/// 导航栏
@property (nonatomic, strong) ZBaseNavigationBar *z_navgationBar;
/// 修改状态栏颜色
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
///用于横屏跳横屏, 不刷新竖屏
@property (nonatomic, assign) BOOL notRefreshRotation;

- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle;

//强制横屏
- (void)forceOrientationLandscape;
//
//强制竖屏
- (void)forceOrientationPortrait;

/**tabbar点击*/
- (void)tabBarItemClicked;

/// view容器
@property (nullable ,nonatomic, strong) UIView *mrkContentView;


@end

NS_ASSUME_NONNULL_END
