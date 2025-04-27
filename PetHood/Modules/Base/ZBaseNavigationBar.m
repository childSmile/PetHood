//
//  ZBaseNavigationBar.m
//  PetHood
//
//  Created by MacPro on 2024/6/28.
//

#import "ZBaseNavigationBar.h"

@interface ZBaseNavigationBar ()

@property (nonatomic, strong) UIView *navContentView;
@property (nonatomic ,assign) NSTextAlignment titleAlignment;

@end

@implementation ZBaseNavigationBar

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.navContentView = [UIView new];
        [self addSubview:self.navContentView];
        [self.navContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.left.right.bottom.mas_equalTo(@0);
                make.height.mas_equalTo(kNavBarHeight);
        }];
        _titleAlignment = NSTextAlignmentCenter;
        
//        _leftView = [UIView new];
//        [self.navContentView addSubview:self.leftView];
//        [self.navContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.mas_centerX);
//                make.left.right.bottom.mas_equalTo(@0);
//                make.height.mas_equalTo(kNavBarHeight);
//        }];
        
        
        self.backgroundColor = UIColor.clearColor;
    }
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if(!_leftView) {
        self.leftView = [UIView new];
        [self.navContentView addSubview:self.leftView];
        
    }
 
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.navContentView.mas_centerY).offset(kStatusBarHeight / 2.0);
        make.left.mas_equalTo(self.navContentView.mas_left).offset(20);
        make.size.mas_equalTo(self.leftView.size);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftView.mas_centerY);
        make.right.mas_equalTo(-DHPX(14));
        make.size.mas_equalTo(self.rightView.size);
    }];
    
    if (_titleAlignment == NSTextAlignmentLeft) {
        [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftView.mas_right).offset(8);
            make.centerY.mas_equalTo(self.navContentView.mas_centerY).offset(kStatusBarHeight / 2.0);
            make.width.mas_lessThanOrEqualTo(@150);
        }];
    }else if (_titleAlignment == NSTextAlignmentCenter) {
        
        [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.navContentView.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.navContentView.mas_centerY).offset(kStatusBarHeight / 2.0);
            make.width.mas_lessThanOrEqualTo(@150);
        }];
    }
    
    [self.bottomBlackLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.navContentView.mas_bottom);
        make.centerX.mas_equalTo(self.navContentView.mas_centerX);
        make.width.mas_equalTo(self.navContentView.mas_width);
        make.height.mas_equalTo(@1.0);
    }];
}

#pragma mark - Setter
- (void)setTitleView:(__kindof UIView *)titleView {
    [_titleView removeFromSuperview];
    [self.navContentView addSubview:titleView];
    _titleView = titleView;
    
    [self layoutIfNeeded];
}

- (void)setTitle:(NSMutableAttributedString *)title {
    // bug fix
    if ([self.dataSource respondsToSelector:@selector(zNavigationBarTitleView:)]) {
        return;
    }
    
    if (self.titleView != nil && [self.titleView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self.titleView;
        [label setAttributedText:title];
        return;
    }
    /**头部标题*/
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:24 weight:800];
    
    label.textColor = UIColorHex(#000000);
    [label setAttributedText:title];
    self.titleView = label;
}

- (void)setLeftView:(__kindof UIView *)leftView {
    [_leftView removeFromSuperview];
    [self.navContentView addSubview:leftView];
    _leftView = leftView;
   
    if ([leftView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)leftView;
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if([leftView isKindOfClass:[UIView class]]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBtnClick:)];
        leftView.userInteractionEnabled = YES;
        [leftView addGestureRecognizer:tap];
    }
    [self layoutIfNeeded];
}

- (void)setRightView:(__kindof UIView *)rightView {
    [_rightView removeFromSuperview];
    [self.navContentView addSubview:rightView];
    _rightView = rightView;
    [_rightView sizeToFit];

    if ([rightView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)rightView;
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self layoutIfNeeded];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if (backgroundImage != nil){
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.contents = (__bridge id _Nullable)(backgroundImage.CGImage);
        self.layer.masksToBounds = YES;
    }
}

- (UIView *)bottomBlackLineView {
    if(!_bottomBlackLineView) {
        UIView *bottomBlackLineView = [[UIView alloc] init];
        [self addSubview:bottomBlackLineView];
        _bottomBlackLineView = bottomBlackLineView;
        _bottomBlackLineView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];;
    }
    return _bottomBlackLineView;
}

#pragma mark - event
- (void)leftBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(leftButtonEvent:navigationBar:)]) {
        [self.delegate leftButtonEvent:btn navigationBar:self];
    }
}

- (void)rightBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(rightButtonEvent:navigationBar:)]) {
        [self.delegate rightButtonEvent:btn navigationBar:self];
    }
}

- (void)setDataSource:(id<ZNavigationBarDataSource>)dataSource {
    _dataSource = dataSource;
    [self setupDataSourceUI];
}

#pragma mark - custom
- (void)setupDataSourceUI {
    /** 导航条的高度 */
//    if ([self.dataSource respondsToSelector:@selector(zNavigationBarHeight:)]) {
//        self.mj_size = CGSizeMake(MainWidth, [self.dataSource zNavigationBarHeight:self]);
//    } else {
        self.size = CGSizeMake(RealScreenWidth, kNavBarHeight);
//    }
    
    /** 是否显示底部黑线 */
    if ([self.dataSource respondsToSelector:@selector(zNavigationBarIsHideBottomLine:)]) {
        if ([self.dataSource zNavigationBarIsHideBottomLine:self]) {
            self.bottomBlackLineView.hidden = YES;
        }
    }
    
    /** 背景图片 */
    if ([self.dataSource respondsToSelector:@selector(zNavigationBarBackgroundImage:)]) {
        self.backgroundImage = [self.dataSource zNavigationBarBackgroundImage:self];
    }
    
    /** 背景色 */
    if ([self.dataSource respondsToSelector:@selector(zNavigationBarBackgroundColor:)]) {
        self.backgroundColor = [self.dataSource zNavigationBarBackgroundColor:self];
    }
    
    /** 导航条中间的 View */
    if ([self.dataSource respondsToSelector:@selector(zNavigationBarTitleView:)]) {
        self.titleView = [self.dataSource zNavigationBarTitleView:self];
    }else if ([self.dataSource respondsToSelector:@selector(zNavigationBarTitle:)]){
        /**头部标题*/
        self.title = [self.dataSource zNavigationBarTitle:self];
    }
    
    /** 导航条的左边的 view */
    if ([self.dataSource respondsToSelector:@selector(zNavigationBarLeftView:)]) {
        self.leftView = [self.dataSource zNavigationBarLeftView:self];
    }else if ([self.dataSource respondsToSelector:@selector(zNavigationBarLeftButtonImage:navigationBar:)]){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(30, 44);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        UIImage *image = [self.dataSource zNavigationBarLeftButtonImage:btn navigationBar:self];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        self.leftView = btn;
    }
    
    /** 导航条右边的 view */
    if ([self.dataSource respondsToSelector:@selector(zNavigationBarRightView:)]) {
        self.rightView = [self.dataSource zNavigationBarRightView:self];
    }else if ([self.dataSource respondsToSelector:@selector(zNavigationBarRightButtonImage:navigationBar:)]){
        UIButton *btn = self.rightControlView;
        UIImage *image = [self.dataSource zNavigationBarRightButtonImage:btn navigationBar:self];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        self.rightView = btn;
    }else if ([self.dataSource respondsToSelector:@selector(zNavigationBarRightButtonTitle:navigationBar:)]){
        UIButton *btn = self.rightControlView;
        NSString *title = [self.dataSource zNavigationBarRightButtonTitle:btn navigationBar:self];
        if (title) {
            [btn setTitle:title forState:UIControlStateNormal];
        }
        self.rightView = btn;
    }
}

///刷新控件
- (void)reloadRightView {
    if ([self.rightView isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)self.rightView;
        if ([self.dataSource respondsToSelector:@selector(zNavigationBarRightButtonImage:navigationBar:)]){
            UIImage *image = [self.dataSource zNavigationBarRightButtonImage:btn navigationBar:self];
            if (image) {
                [btn setImage:image forState:UIControlStateNormal];
            }
        }
        
        if ([self.dataSource respondsToSelector:@selector(zNavigationBarRightButtonTitle:navigationBar:)]){
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            NSString *title = [self.dataSource zNavigationBarRightButtonTitle:btn navigationBar:self];
            if (title) {
                [btn setTitle:title forState:UIControlStateNormal];
            }
        }
    }
}

- (UIButton *)rightControlView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(44, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    return button;
}

-(void)reloadTitleViewAlign:(NSTextAlignment)alignment {
    _titleAlignment = alignment;
    [self layoutSubviews];
    
}

@end
