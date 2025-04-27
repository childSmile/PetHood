//
//  MainTabViewController.m
//  PetHood
//
//  Created by MacPro on 2024/6/27.
//

#import "MainTabViewController.h"
#import "PHTabbar.h"
#import "ZBaseNavigationController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarConfig];
    
    [self setupTabBarControllers];
    

    
}

-(void)setupTabBarControllers {
    
    self.tabBar.tintColor = UIColor.whiteColor;
    PHTabBar *tabbar = [[PHTabBar alloc]init];
//    tabbar.frame = CGRectMake(0, 0, kScreenWidth, DHPX(66));
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    
//    [self.tabBar addSubview:tabbar];
//    [tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(@0);
//    }];
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];
//    ActivityViewController *mapVC = [[ActivityViewController alloc]init];
    DataViewController *dataVC = [[DataViewController alloc]init];
    MineViewController *mineVC = [[MineViewController alloc]init];
    
    [self setViewControllers:@[
        [[ZBaseNavigationController alloc]initWithRootViewController:homeVC] ,
//        [[ZBaseNavigationController alloc]initWithRootViewController:mapVC] ,
        [[ZBaseNavigationController alloc]initWithRootViewController:dataVC] ,
        [[ZBaseNavigationController alloc]initWithRootViewController:mineVC]
    ]];
    NSArray *titles = @[@"宠物+" , @"活动" , @"我的"];
    NSArray *icons = @[
        @"tab_pet_icon_unselected" ,
        @"tab_navi_icon_unselected" ,
        @"tab_mine_icon_unselected"];
    NSArray *selectIcons = @[
        @"tab_pet_icon_selected" ,
        @"tab_navi_icon_selected" ,
        @"tab_mine_icon_selected"];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitle:titles[idx]];
        item.tag = idx;
        item.image = [[UIImage imageNamed:icons[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:selectIcons[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#ff0000)} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#4C96FF)} forState:UIControlStateSelected];
            
    }];
    
    self.tabBar.backgroundColor = UIColor.redColor;
    
   
}

- (void)setupTabBarConfig {
    self.delegate = self;
    self.tabBar.translucent = false;
    
    UITabBar *item = self.tabBarItem;
    
        // 适配iOS 15的设置方式
        if (@available(iOS 13.0, *)){
            UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
            [appearance configureWithOpaqueBackground];
            appearance.backgroundImage = [UIImage new];;
            appearance.shadowImage = [UIImage new];;
            
                appearance.backgroundColor = UIColor.whiteColor;
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:UIColorHex(#848A9B)};
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:UIColorHex(#17D2E3)};
            
            item.standardAppearance = appearance;
            if (@available(iOS 15.0, *)){
                item.scrollEdgeAppearance = appearance;
            }
//            item.barTintColor = [UIColor whiteColor];
            
        } else {
            item.backgroundImage = [UIImage new];
            item.shadowImage = [UIImage new];
            item.tintColor = [UIColor clearColor];
           
            item.barTintColor = [UIColor whiteColor];
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#848A9B)} forState:UIControlStateNormal];
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#17D2E3)} forState:UIControlStateSelected];
        }
    
        

    
}





@end
