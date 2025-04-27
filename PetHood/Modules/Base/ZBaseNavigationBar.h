//
//  ZBaseNavigationBar.h
//  PetHood
//
//  Created by MacPro on 2024/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZBaseNavigationBar;

//显示
@protocol ZNavigationBarDataSource <NSObject>

@optional
/**
 头部标题
 */
- (NSMutableAttributedString*)zNavigationBarTitle:(ZBaseNavigationBar*)navigationBar;

/**
 背景图片
 */
- (UIImage *)zNavigationBarBackgroundImage:(ZBaseNavigationBar*)navigationBar;

/**
 背景色
 */
- (UIColor *)zNavigationBarBackgroundColor:(ZBaseNavigationBar*)navigationBar;

/**
 是否显示底部黑线
 */
- (BOOL)zNavigationBarIsHideBottomLine:(ZBaseNavigationBar*)navigationBar;

/**
 导航条的高度
 */
- (CGFloat)zNavigationBarHeight:(ZBaseNavigationBar*)navigationBar;

/**
 导航条的左边的 view
 */
- (UIView *)zNavigationBarLeftView:(ZBaseNavigationBar*)navigationBar;

/**
 导航条右边的 view
 */
- (UIView *)zNavigationBarRightView:(ZBaseNavigationBar*)navigationBar;

/**
 导航条中间的 View
 */
- (UIView *)zNavigationBarTitleView:(ZBaseNavigationBar*)navigationBar;

/**
 导航条左边的按钮
 */
- (UIImage *)zNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(ZBaseNavigationBar*)navigationBar;

/**
 导航条右边的按钮图片
 */
- (UIImage *)zNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(ZBaseNavigationBar*)navigationBar;

/**
 导航条右边的按钮文字
 */
- (NSString *)zNavigationBarRightButtonTitle:(UIButton *)rightButton navigationBar:(ZBaseNavigationBar*)navigationBar;


@end

//事件
@protocol ZNavigationBarDelegate <NSObject>
@optional
/**
 左边的按钮的点击
 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(ZBaseNavigationBar *)navigationBar;

/**
 右边的按钮的点击
 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(ZBaseNavigationBar *)navigationBar;

@end

@interface ZBaseNavigationBar : UIView

@property (weak, nonatomic) id<ZNavigationBarDataSource> dataSource;
@property (weak, nonatomic) id<ZNavigationBarDelegate> delegate;

@property (strong, nonatomic) UIView *bottomBlackLineView;
@property (strong, nonatomic) __kindof UIView *titleView;
@property (strong, nonatomic) __kindof UIView *leftView;
@property (strong, nonatomic) __kindof UIView *rightView;

@property (copy, nonatomic) NSMutableAttributedString *title;
@property (strong, nonatomic) UIImage *backgroundImage;

- (void)reloadRightView;

-(void)reloadTitleViewAlign:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
