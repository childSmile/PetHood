//
//  AppDelegate.m
//  PetHood
//
//  Created by MacPro on 2024/6/4.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/MAMapView.h>

#import "MainTabViewController.h"
#import "ZBaseNavigationController.h"
#import "ViewController.h"

//flutter
//#import <GeneratedPluginRegistrant.h>

static NSString *APIKey = @"a9cbb4a845f7bd1634e8f219a16941e9";

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //多引擎
//    self.flutterEngineGroup = [[FlutterEngineGroup alloc]initWithName:@"flutter_group" project:nil];
    
    //单引擎
//    self.flutterEngine = [[FlutterEngine alloc]initWithName:@"my_flutter_engine"];
//    [self.flutterEngine run];
//    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //初始化高德地图
//    [self initMap];
    
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc] init]];
    
    self.window.rootViewController = [[ZBaseNavigationController alloc] initWithRootViewController:[[MainTabViewController alloc]init]];
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

#pragma mark -  高德
-(void)initMap {
    [AMapServices sharedServices].apiKey = APIKey;
    //更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 8.1.0
    [MAMapView updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [MAMapView updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UISceneSession lifecycle

//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
