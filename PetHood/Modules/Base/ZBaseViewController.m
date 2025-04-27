//
//  ZBaseViewController.m
//  PetHood
//
//  Created by MacPro on 2024/6/27.
//

#import "ZBaseViewController.h"
#import "ZBaseNavigationBar.h"

@interface ZBaseViewController ()

@end

@implementation ZBaseViewController

/** 是否自动旋转
   /// 在16以下版本shouldAutorotate决定当前界面是否开启自动转屏，如果返回未NO，后面的两个方法也不会调用，
   /// 🚦在16及以上系统，这里的API有较大的变化，需要特别注意，shouldAutorotate方法在16及以上系统会不起作用，而是需要控制supportedInterfaceOrientations方法才有效果，系统中代码注释如下。
 
   /// 巨坑
   ///🚦强制某一方向横屏只能再model模式下实现，push模式下不行，push进入到一个页面的时候，是不会触发任何旋转类的方法的，只有旋转手机才会调用。
     采用push进入横屏页面是为了统一 navagation , 旋转方式相对好看一点
     所以强制旋转任然保留 [self forceOrientationLandscape]
 */

/*
- (BOOL)shouldAutorotate {
    if ([UIDevice currentDevice].isPad){
        return YES;
    }
    return NO;
}

/// 当前控制器支持的屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([UIDevice currentDevice].isPad){
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

/// 优先的屏幕方向 - 只会在 presentViewController:animated:completion时被调用
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
//    NSLog(@"viewWillTransitionToSize ======== %@", NSStringFromCGSize(size));
//    NSLog(@"self.view.frame ======== %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"self.view.frame.size ======== %@", NSStringFromCGSize(self.view.frame.size));
//    NSLog(@"self.view.bounces ======== %@", NSStringFromCGRect(self.view.bounds));
//    NSLog(@"self.view.center ======== %@", NSStringFromCGPoint(self.view.center));
}
*/
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (void)dealloc {
    NSLog(@"\n😊😊😊-----dealloc-----😊😊😊%@\n",[NSString stringWithUTF8String:object_getClassName(self)]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        if (_statusBarStyle == UIStatusBarStyleDefault) {
            return UIStatusBarStyleDarkContent;
        }
    }
    return _statusBarStyle;
}

/// 动态更新状态栏颜色
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma 处理界面的来向
- (BOOL)handleFromViewControllers {
    NSArray *viewControllers = self.navigationController.childViewControllers;
//    if (viewControllers.count > 2) {
//        UIViewController *vc = viewControllers[viewControllers.count -2];
//        if ([vc isKindOfClass:[MRKVideoController class]]) {
//            return YES;
//        }
//        if ([vc isKindOfClass:[MRKGameVideoController class]]) {
//            return YES;
//        }
//
//        if ([vc isKindOfClass:[MrkPlotVideoController class]]) {
//            return YES;
//        }
//
//        if ([vc isKindOfClass:[MRKHrCtrlSportsController class]]) {
//            return YES;
//        }
//    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //手势
    self.fd_interactivePopDisabled = [self handleFromViewControllers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.fd_interactivePopDisabled) {
        self.fd_interactivePopDisabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear== %@", self.className);
    
    ///刷新StatusBar
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear== %@", self.className);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8FA"];
    self.fd_prefersNavigationBarHidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusBarStyle = [self navControllerStatusBarStyle:self];
    });
    
    [self.view addSubview:self.z_navgationBar];
    [self.z_navgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(RealScreenWidth, kNavBarHeight));
    }];
    
    self.navTitleColor = [UIColor colorWithHexString:@"#000000"];
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50;

    [self.view addSubview:self.mrkContentView];
    [self.mrkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(RealScreenWidth);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.z_navgationBar];
}





- (void)tabBarItemClicked{
    NSLog(@"\ntabBarItemClicked : %@", NSStringFromClass([self class]));
}

- (UIView *)mrkContentView {
    if (!_mrkContentView) {
        _mrkContentView = [[UIView alloc] init];
    }
    return _mrkContentView;
}

- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle{
    return nil;
}

- (ZBaseNavigationBar *)z_navgationBar{
    if (![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return nil;
    }
    if (![self viewControllerIsNeedNavBar:self]) {
        return nil;
    }
    // 父类控制器必须是导航控制器
    if(!_z_navgationBar) {
        ZBaseNavigationBar *navigationBar = [[ZBaseNavigationBar alloc] init];
        navigationBar.dataSource = self;
        navigationBar.delegate = self;
        _z_navgationBar = navigationBar;
    }
    return _z_navgationBar;
}

- (void)setTitle:(NSString *)title {
    NSAssert(![title isNotBlank], @"页面设置title 请使用navTitle, 谢谢 [二级页面赋值title, push可能会导致tabbar 色值闪烁]");
    self.z_navgationBar.title = [self changeNavTitle:title];
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    self.z_navgationBar.title = [self changeNavTitle:navTitle];
}

- (void)setNavTitleColor:(UIColor *)navTitleColor {
    _navTitleColor = navTitleColor;
    if ([self.z_navgationBar.titleView isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)self.z_navgationBar.titleView;
        lab.textColor = navTitleColor;
    }
}

- (NSMutableAttributedString *)changeNavTitle:(NSString *)curTitle{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    attributedStr.color = self.navTitleColor;
    attributedStr.font = [UIFont systemFontOfSize:24 weight:800];
    return attributedStr;
}


#pragma mark - ZNavigationBarDataSource
- (BOOL)viewControllerIsNeedNavBar:(ZBaseViewController *)viewController {
    return YES;
}
-(BOOL)zNavigationBarIsHideBottomLine:(ZBaseNavigationBar *)navigationBar {
    return YES;
}


-(UIImage *)zNavigationBarBackgroundImage:(ZBaseNavigationBar *)navigationBar {
    return [UIColor gradientColorImageFromColors:@[[UIColor colorWithRGBA:0x0075FFff] , [UIColor colorWithRGBA:0x0075FF00]] gradientType:GradientTypeTopToBottom imgSize:navigationBar.frame.size];
}

//- (UIColor *)zNavigationBarBackgroundColor:(ZBaseNavigationBar *)navigationBar {
//    return [UIColor whiteColor];
//}
- (UIStatusBarStyle)navControllerStatusBarStyle:(ZBaseViewController *)viewController {
    return self.statusBarStyle;
}
- (NSMutableAttributedString*)zNavigationBarTitle:(ZBaseNavigationBar *)navigationBar {
    return [self changeNavTitle:self.navTitle?:self.navigationItem.title];
}

#pragma mark - ZNavigationBarDelegate
//-(UIView *)zNavigationBarLeftView:(ZBaseNavigationBar *)navigationBar {
//    
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 32)];
//    v.backgroundColor = [UIColor colorWithRGB:0xffffff alpha:0.6];
//    v.layer.cornerRadius = 8;
//    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_arrow_icon"]];
//    if(self.navigationController.childViewControllers.count > 1) {
//        v.frame = CGRectMake(0, 0, 32, 32);
//        [v addSubview:img];
//        [img mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(v.mas_centerX);
//            make.centerY.equalTo(v.mas_centerY);
//        }];
//    }
//   
//    return v;
//}
-(UIImage *)zNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(ZBaseNavigationBar *)navigationBar {
    leftButton.frame = CGRectMake(0, 0, self.navigationController.childViewControllers.count == 1 ? 0 : 32, 32);
    return  self.navigationController.childViewControllers.count == 1 ? nil : [UIImage imageNamed:@"nav_back_icon"];
}
-(UIView *)zNavigationBarRightView:(ZBaseNavigationBar *)navigationBar {
    UIView *rv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 0)];
    if(self.navigationController.childViewControllers.count == 1) {
        rv.frame = CGRectMake(0, 0, 100, 44);
//        rv.backgroundColor = UIColor.redColor;
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn  setImage:[UIImage imageNamed:@"nav_add_icon"] forState:UIControlStateNormal];
        [rv addSubview: addBtn];
        [addBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(DHPX(-16));
            make.centerY.mas_equalTo(rv.mas_centerY);
        }];
        
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageBtn setImage:[UIImage imageNamed:@"nav_message_icon"] forState:UIControlStateNormal];
        [rv addSubview:messageBtn];
        [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(addBtn.mas_left).offset(DHPX(-10));
            make.centerY.mas_equalTo(rv.mas_centerY);
        }];
        
        
        addBtn.tag = 100;
        addBtn.tag = 101;
        
        [addBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return  rv;
}
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(ZBaseNavigationBar *)navigationBar {
    [self backClick:sender];
}

- (void)backClick:(UIButton *)sender {
    
    if (self.navigationController) {
        if (self.navigationController.childViewControllers.count == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)rightButtonAction:(UIButton *)sender {
    
    if(sender.tag == 100) {
        NSLog(@"消息");
    }else if(sender.tag == 101) {
        NSLog(@"添加");
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)forceOrientationPortrait {
}

- (void)forceOrientationLandscape {
}






@end
