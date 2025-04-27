//
//  ZBaseNavigationController.m
//  PetHood
//
//  Created by MacPro on 2024/6/27.
//

#import "ZBaseNavigationController.h"

@interface ZBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation ZBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    //UINavigationController 全局屏蔽
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    [super setViewControllers:viewControllers];
    _lastController = [viewControllers lastObject];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count != 0
        && [viewController respondsToSelector:@selector(setHidesBottomBarWhenPushed:)]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    _lastController = viewController;
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    _lastController = [self.viewControllers objectAtIndex:self.viewControllers.count > 1 ? self.viewControllers.count - 2 : 0];
    NSLog(@"popViewControllerAnimated==%@" , self.childViewControllers);
    return  [super popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.viewControllers containsObject:viewController]) {
        _lastController = viewController;
    }
    return [super popToViewController:viewController animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    _lastController = [self.viewControllers objectAtIndex:0];
    return [super popToRootViewControllerAnimated:animated];
}


/**
 是否已经push进去相同Class的控制器，当前控制器还没加载也有记录
 @param contrllerType contrller Class
 @return BOOL
 */
+ (BOOL)isAleradyPushContrllerType:(Class)contrllerType navigationContrller:(UINavigationController *)navigation {
    BOOL isPush = NO;
    if ([navigation isKindOfClass:[self class]] && [NSStringFromClass(contrllerType) isEqualToString:NSStringFromClass([((ZBaseNavigationController *) navigation).lastController class])]) {
        isPush = YES;
    }
    return isPush;
}

- (void)dealloc{
    NSLog(@"=========");
}


- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}


@end





@implementation UINavigationController (Extension)

- (void)navigationRemoveContrller:(UIViewController *)controller{
    NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.viewControllers];
    [tempMarr removeObject:controller];
    [self setViewControllers:tempMarr animated:YES];
}

- (void)popToNewController:(UIViewController *)newController animated:(BOOL)animated {
    NSMutableArray < UIViewController *> *controllers = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [controllers replaceObjectAtIndex:controllers.count - 2 withObject:newController];
    //这里直接setViewControllers即可，不需要push或者pop方法
    [self setViewControllers:controllers animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion: (void (^)(void))completion {
    [CATransaction setCompletionBlock:completion];
    [CATransaction begin];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (void)pushViewController:(UIViewController *)viewController backToController:(UIViewController *)backController animated:(BOOL)animated {
    if (self.childViewControllers.count != 0 && [viewController respondsToSelector:@selector(setHidesBottomBarWhenPushed:)]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    NSMutableArray <UIViewController *> *controllers = [NSMutableArray new];
    if ([self.viewControllers containsObject:backController]) {
        for (NSInteger i = 0; i <= [self.viewControllers indexOfObject:backController]; i++) {
            UIViewController *vc = [self.viewControllers objectAtIndex:i];
            [controllers addObject:vc];
        }
        [controllers addObject:viewController];
    } else {
        [controllers addObjectsFromArray:self.viewControllers];
        [controllers removeLastObject];
        [controllers addObject:backController];
        [controllers addObject:viewController];
    }
    //这里直接setViewControllers即可，不需要push或者pop方法
    [self setViewControllers:controllers animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController backToControllerIndex:(NSInteger)controllerIndex animated:(BOOL)animated {
    UIViewController *backVc = [self.viewControllers objectAtIndex:controllerIndex];
    [self pushViewController:viewController backToController:backVc animated:animated];
}

@end

