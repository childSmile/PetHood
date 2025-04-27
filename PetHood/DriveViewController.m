//
//  DriveViewController.m
//  PetHood
//
//  Created by MacPro on 2024/6/18.
//

#import "DriveViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviDriveManager.h>
#import <AMapNaviKit/AMapNaviDriveView.h>
#import <AMapNaviKit/MAMapView.h>
#import <AMapLocationKit/AMapLocationManager.h>


#import "TestMapViewController.h"
#import "DriveNaviViewController.h"
#import "SpeechSynthesizer.h"
#import "QuickStartAnnotationView.h"

@interface DriveViewController ()<AMapSearchDelegate , AMapNaviDriveManagerDelegate , MAMapViewDelegate , AMapLocationManagerDelegate , DriveNaviViewControllerDelegate>

@property (nonatomic , strong) AMapSearchAPI *search;
@property (nonatomic , strong) AMapNaviDriveView *driveView;
@property (nonatomic , strong) AMapNaviPoint *startPoint;
@property (nonatomic , strong) AMapNaviPoint *endPoint;

@property (nonatomic , strong) MAMapView *mapView;
@property (nonatomic , strong) NSMutableArray *annotations;
@property (nonatomic , strong) AMapLocationManager *locationManager;

//导航
@property (nonatomic , strong) AMapNaviDriveManager *driverManager;



@end

@implementation DriveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    //后台语音播报权限是否需要开启 https://lbs.amap.com/api/ios-navi-sdk/guide/create-project/location-positioning-statement
     
    
    [self initMap];
    [self initSearch];
    [self initDriveManager];
    [self initLocationManager];
    
    [self initUI];
    
    [self updateCurrentLocation];
 
}

-(void)initUI{
    UIView *ui = [[UIView alloc]init];
    [self.view addSubview:ui];
    [ui mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(100));
    }];
    
    ui.backgroundColor = UIColor.whiteColor;
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ui addSubview:scanButton];
//    scanButton.frame = CGRectMake(30, 100, 100, 50);
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(10));
            make.width.equalTo(@(80));
            make.height.equalTo(@(40));
    }];
    [scanButton setTitle:@"搜索宝龙" forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(toScanAction:) forControlEvents:UIControlEventTouchUpInside];
    scanButton.backgroundColor = UIColor.blueColor;
    
    
}

-(void)toScanAction:(id)sender{
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = @"宝龙";
    request.city = @"杭州";
    NSLog(@"开始搜索");
    [self.search AMapPOIKeywordsSearch:request];
    
}

-(void)initMap{
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    
    //显示定位小蓝点
   _mapView.showsUserLocation = YES;
   _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
   
    //执行更新
    //如果用户自定义了userlocation的annotationView，或者该annotationView还未添加到地图上，此方法将不起作用
//    [_mapView updateUserLocationRepresentation:[self currentRepresentation]];
    
}

-(MAUserLocationRepresentation *)currentRepresentation {
    //自定义小蓝点
    MAUserLocationRepresentation *respresentation = [[MAUserLocationRepresentation alloc]init];
    //精度圈是否显示,默认YES
        respresentation.showsAccuracyRing = NO;
    //是都显示蓝点方向指向,默认YES
        respresentation.showsHeadingIndicator = NO;
    //调整精度圈填充颜色
        respresentation.fillColor = [UIColor redColor];
    //调整精度圈边线颜色
        respresentation.strokeColor = [UIColor blueColor];
    //调整精度圈变宽宽度,默认0
    //    respresentation.lineWidth = 2;
    //精度圈是否显示律动效果,默认YES
        respresentation.enablePulseAnnimation = NO;
    //调整定位蓝点的背景颜色
    respresentation.locationDotFillColor = [UIColor greenColor];
    //调整定位蓝点的颜色
//    respresentation.locationDotFillColor = [UIColor grayColor];
    //调整定位蓝点的图标,与蓝色原点互斥
//    respresentation.image = [UIImage imageNamed:@""];
    
    return  respresentation;
    
}

-(void)initSearch {
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    
    
}

-(void)initDriveManager {
    
    _driverManager = [AMapNaviDriveManager sharedInstance];
    _driverManager.delegate = self;
    
}

-(void)initLocationManager{
    
    _locationManager = [[AMapLocationManager alloc]init];
    _locationManager.delegate = self;
    
    [self.locationManager setLocationTimeout:3];
   
}

-(void)updateCurrentLocation{
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if(error){
                NSLog(@"error==%@" , error);
                return;
            }
        
        @strongify(self);
        MAUserLocation *annotation = [[MAUserLocation alloc]init];
//        CurrentLocationAnnotation *annotation = [[CurrentLocationAnnotation alloc]init];
        annotation.coordinate = location.coordinate;
        annotation.title = @"当前位置";
        [self.mapView addAnnotation:annotation];
        [self.mapView selectAnnotation:annotation animated:YES];
        
//        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//        [self.mapView setCenterCoordinate:coor animated:YES];
        
    
        
        
        
        
       self.startPoint =  [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        
    }];
}

//路径规划
-(void)routePlanAction{

    [self.driverManager calculateDriveRouteWithStartPoints:@[_startPoint] 
                                                 endPoints:@[_endPoint]
                                                 wayPoints:nil
                                           drivingStrategy:AMapNaviDrivingStrategySingleDefault];
    
    
}



#pragma mark - AMapLocationManagerDelegate


#pragma mark - AMapNaviDriveManagerDelegate
-(void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"driveManagerOnCalculateRouteSuccess");
    //规划路线成功，开始导航
    DriveNaviViewController *vc = [[DriveNaviViewController alloc]init];
    vc.delegate = self;
    //将driverView添加为导航数据的Representative , 使其可以接受到导航诱导数据
    [_driverManager addDataRepresentative:vc.driveView];
    
    [self.navigationController pushViewController:vc animated:NO];
    
    //开始模拟导航
    [_driverManager startEmulatorNavi];
    
    
}
-(void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"driveManageronCalculateRouteFailure===%@" , error);
}

#pragma mark - DriveNaviViewControllerDelegate
-(void)driveNaviViewCloseButtonClicked {
    NSLog(@"停止导航");
    [_driverManager stopNavi];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark - MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    NSLog(@"didUpdateUserLocation===%@" , userLocation);
}
-(void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager {
    NSLog(@"mapViewRequireLocationAuth====%@" , locationManager);
    //请求获取定位
//    [locationManager requestAlwaysAuthorization];
    
}
/* 实现代理方法：*/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    NSLog(@"viewForAnnotation ==%@" , annotation.class);
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
    
        static NSString *pointReuseIndetifier = @"MAUserLocationIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        annotationView.image =  [UIImage imageNamed:@"时尚小鸟"];
        
        
        return annotationView;
        
    } else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.rightCalloutAccessoryView  = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor  = [self.annotations indexOfObject:annotation] % 3;
        return annotationView;
    } else if([annotation isKindOfClass:[POIAnnotation class]]) {
//        NSLog(@"POIAnnotation");
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if(poiAnnotationView == nil){
            poiAnnotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        poiAnnotationView.leftCalloutAccessoryView = UIButton
        
        //自定义标注图标 ，默认是大头针
//        poiAnnotationView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://iconfont.alicdn.com/p/illus/preview_image/pMhdd5wW6xfB/f75d50f2-15ef-40da-9d6b-0fb351b75009.png?w=120&h=12"]]];
        //设置中心点偏移，使得标注底部点成为经纬度对应点
        poiAnnotationView.centerOffset = CGPointMake(0, -18);
        
        //自定义气泡
        
        return poiAnnotationView;
    } else  if ([annotation isKindOfClass:[CurrentLocationAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"CurrentLocationAnnotationView";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.pinColor = MAPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        
        return annotationView;
    }
    return nil;
}
-(void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id<MAAnnotation> annotation = view.annotation;
    NSLog(@"点击了====%.f , %.f" , annotation.coordinate.latitude , annotation.coordinate.longitude);
    if([view.annotation isKindOfClass:[POIAnnotation class]]) {
        POIAnnotation *annotation = (POIAnnotation *)view.annotation;
        _endPoint = [AMapNaviPoint locationWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        [self routePlanAction];
        
    }
    
}

#pragma mark - AMapSearchDelegate

-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"search_fail:%@" , error.localizedDescription);
}
//4.回调中处理数据
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    NSLog(@"request:%@,搜索回调==%@" ,request , response);
    if(response.pois.count == 0) {
        NSLog(@"没有搜索到");
        return;
    }
    //解析POI信息
    __block NSMutableArray *poiAnnotations = [NSMutableArray array];
    
    NSLog(@"搜到结果：%@" , response.pois);
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc]initWithPOI:obj]];
    }];
    
    //将结果以annotation的形式加载到地图上
    [self.mapView addAnnotations:poiAnnotations];
    
    //如果只有一个结果，设置其为中心点
    if(poiAnnotations.count == 1) {
//        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
//        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    } else {
        //多个结果 设置地图使所有的annotation可见
        [self.mapView showAnnotations:poiAnnotations animated:NO];
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


-(void)dealloc {
    //销毁导航
    [AMapNaviDriveManager destroyInstance];
    
    NSLog(@"%@=====dealloc" , [self class]);
    
}

@end



