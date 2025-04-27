//
//  ViewController.m
//  PetHood
//
//  Created by MacPro on 2024/6/4.
//

#import "ViewController.h"
#import <AVFoundation/AVFCapture.h>

#import "QRScanViewController2.h"
#import "TestMapViewController.h"
#import "DriveViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:scanButton];
    scanButton.frame = CGRectMake(30, 100, 100, 50);
    [scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(toScanAction:) forControlEvents:UIControlEventTouchUpInside];
    scanButton.backgroundColor = UIColor.blueColor;
    
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:mapButton];
    mapButton.frame = CGRectMake(30, 180, 100, 50);
    [mapButton setTitle:@"地图" forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(toMapAction:) forControlEvents:UIControlEventTouchUpInside];
    mapButton.backgroundColor = UIColor.blueColor;
    
    UIButton *driveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:driveButton];
    driveButton.frame = CGRectMake(30, 260, 100, 50);
    [driveButton setTitle:@"地图导航" forState:UIControlStateNormal];
    [driveButton addTarget:self action:@selector(toDriveAction:) forControlEvents:UIControlEventTouchUpInside];
    driveButton.backgroundColor = UIColor.blueColor;
    
}

-(void)toDriveAction:(id)sender {
    DriveViewController *vc = [DriveViewController new];
    [self.navigationController pushViewController:vc animated:true];
    
}

-(void)toMapAction:(id)sender {
    TestMapViewController *vc = [TestMapViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)toScanAction:(id)sender {
    QRScanViewController2 *vc = [[QRScanViewController2 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  
}



@end
