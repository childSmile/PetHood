//
//  WalkNaviViewController.m
//  PetHood
//
//  Created by MacPro on 2024/7/1.
//

#import "WalkNaviViewController.h"
#import <AMapNaviKit/AMapNaviWalkManager.h>

@interface WalkNaviViewController ()<AMapNaviWalkViewDelegate>

@end

@implementation WalkNaviViewController

-(instancetype)init {
    if (self = [super init])
    {
//        [self initWalkView];
        [self.view addSubview:self.walkView];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//
//    [self.walkView setFrame:self.view.bounds];
//    [self.view addSubview:self.walkView];
}

- (void)initWalkView
{
    if (self.walkView == nil)
    {
        self.walkView = [[AMapNaviWalkView alloc] init];
        self.walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.walkView setDelegate:self];
    }
}
-(AMapNaviWalkView *)walkView {
    if(!_walkView) {
        _walkView = [[AMapNaviWalkView alloc]initWithFrame:self.view.bounds];
        _walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _walkView.delegate = self;
    }
    return _walkView;
}


#pragma mark - AMapNaviWalkViewDelegate
-(void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView {
    NSLog(@"停止步行导航");
    [[AMapNaviWalkManager sharedInstance] stopNavi];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)walkViewMoreButtonClicked:(AMapNaviWalkView *)walkView {
    NSLog(@"walkViewMoreButtonClicked");
}

-(void)walkViewTrunIndicatorViewTapped:(AMapNaviWalkView *)walkView {
    if (self.walkView.showMode == AMapNaviWalkViewShowModeCarPositionLocked)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeNormal];
    }
    else if (self.walkView.showMode == AMapNaviWalkViewShowModeNormal)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeOverview];
    }
    else if (self.walkView.showMode == AMapNaviWalkViewShowModeOverview)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeCarPositionLocked];
    }
}


-(BOOL)viewControllerIsNeedNavBar:(ZBaseViewController *)viewController {
    return NO;
}

@end
