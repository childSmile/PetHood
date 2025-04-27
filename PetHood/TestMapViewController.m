//
//  MapViewController.m
//  PetHood
//
//  Created by MacPro on 2024/6/18.
//

#import "TestMapViewController.h"
#import <AMapNaviKit/MAMapView.h>
#import <AMapNaviKit/MAPinAnnotationView.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationManager.h>



@interface TestMapViewController ()<MAMapViewDelegate , AMapSearchDelegate , AMapLocationManagerDelegate>
@property (nonatomic , strong) MAMapView *mapView;
@property (nonatomic , strong) NSMutableArray *annotations;
@property (nonatomic , strong) AMapSearchAPI *search;
@property (nonatomic , strong) AMapLocationManager *locationManager;

@end

@implementation TestMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.redColor;
    
    
    [self setUI];
    
    
    self.locationManager = [[AMapLocationManager alloc]init];
    _locationManager.delegate = self;
    
    
    @weakify(self);
    [_locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [self.mapView setCenterCoordinate:coor animated:YES];
    }];
//    [self drawMarker];
    
//    [self searchUI];
    
    
}

-(void)searchUI {
    
    //1.获取POI数据
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    //2.设置关键字检索参数
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = @"先锋科技大厦";
    request.city = @"杭州";
    
    //限制城市搜索
    request.cityLimit = YES;
    
    // 3.发起POI关键字搜索
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"开始搜索");
        [self.search AMapPOIKeywordsSearch:request];
    });

    //周边
//    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
//    //{30.992520, 120.336170},
//    request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
//    request.keywords = @"北京大学";
//    request.showFieldsType      = AMapPOISearchShowFieldsTypeAll;
//    /* 按照距离排序. */
//    request.sortrule            = 0;

//    [self.search AMapPOIAroundSearch:request];
    
   
    
    //绘制点标记
//    MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
//    point.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
//    point.title = @"方恒国际";
//    point.subtitle = @"东大街6号";
//    [self.mapView addAnnotation:point];
    
    //计算距离/面积
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(39.989612,116.480972));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(39.990347,116.480441));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);
    NSLog(@"distance==%.3f" , distance);
    
    //是否在圆形内
    //判断一个点是否在圆内，类似于地理围栏功能，返回YES，表示进入围栏，返回NO，表示离开围栏。
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(39.989612,116.480972);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.990347,116.480441);
    BOOL isContains = MACircleContainsCoordinate(location, center, 200);
    NSLog(@"是否在围栏内==%@" , isContains ? @"是" : @"否");
    
    //是否在可视范围内
    //判断一个用户指定的annotation是否在可视区域
    //1.将annotation的经纬度点转成投影点
//    MAMapPoint point = MAMapPointForCoordinate(annotation.coordinate);
    //2.判断该点是否在地图可视范围
//    BOOL isContains = MAMapRectContainsPoint(mapview.visibleMapRect, point);

    

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
//        MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
//        point.coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
//        point.title = obj.address;
//        point.subtitle = obj.name;
//        [poiAnnotations addObject:point];
        
        
        [poiAnnotations addObject:[[POIAnnotation alloc]initWithPOI:obj]];
    }];
    
    //将结果以annotation的形式加载到地图上
    [self.mapView addAnnotations:poiAnnotations];
    
    //如果只有一个结果，设置其为中心点
//    if(poiAnnotations.count == 1) {
//        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
//    } else {
//        //多个结果 设置地图使所有的annotation可见
//        [self.mapView showAnnotations:poiAnnotations animated:NO];
//    }
}

-(void)setUI{
    
    [AMapServices sharedServices].enableHTTPS = YES;
    //初始化地图
    MAMapView *mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mapView];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    
    //显示定位小蓝点
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //自定义小蓝点
    MAUserLocationRepresentation *respresentation = [[MAUserLocationRepresentation alloc]init];
    //精度圈是否显示,默认YES
    //    respresentation.showsAccuracyRing = NO;
    //是都显示蓝点方向指向,默认YES
    //    respresentation.showsHeadingIndicator = NO;
    //调整精度圈填充颜色
    //    respresentation.fillColor = [UIColor redColor];
    //调整精度圈边线颜色
    //    respresentation.strokeColor = [UIColor blueColor];
    //调整精度圈变宽宽度,默认0
    //    respresentation.lineWidth = 2;
    //精度圈是否显示律动效果,默认YES
    //    respresentation.enablePulseAnnimation = NO;
    //调整定位蓝点的背景颜色
//    respresentation.locationDotFillColor = [UIColor greenColor];
    //调整定位蓝点的颜色
    //    respresentation.locationDotFillColor = [UIColor grayColor];
    //调整定位蓝点的图标,与蓝色原点互斥
//    respresentation.image = [UIImage imageNamed:@""];
    
    //执行更新
    [mapView updateUserLocationRepresentation:respresentation];
    
    //开启室内地图方法
//    mapView.showsIndoorMap = YES;
    
    //切换地图图层
    /**
     标准地图         MAMapTypeStandard
     卫星地图         MAMapTypeSatellite
     夜景模式地图  MAMapTypeStandardNight
     导航模式地图  MAMapTypeStandardNavi
     */
    [mapView setMapType:MAMapTypeStandard];
    
    //路况图层
    mapView.showTraffic = YES;
    
    //地图logo 地图Logo不能移除 可以通过调整位置隐藏
    mapView.logoCenter = CGPointMake(CGRectGetMinX(self.view.bounds) - 550, 0);
    
    //指南针控件 可控制是否显示
    mapView.showsCompass = YES;
    //设置指南针的位置
    //    mapView.compassOrigin = CGPointMake(100, 20);
    
    //比例尺控件
    mapView.showsScale = NO;//NO 是否显示
    mapView.scaleOrigin = CGPointMake(100, CGRectGetHeight(self.view.bounds) - 100); //比例尺位置
    
    //手势交互
    /**
     MAMapView.zoomEnabled 此属性用于地图缩放手势的开启和关闭
     
     MAMapView.scrollEnabled 此属性用于地图滑动手势的开启和关闭
     
     MAMapView.rotateEnabled 此属性用于地图旋转手势的开启和关闭
     
     MAMapView.rotateCameraEnabled  此属性用于地图仰角手势的开启和关闭
     */
    
    //截屏
//    __block UIImage *screenshotImage = nil;
//    __block NSInteger reState = 0;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [mapView takeSnapshotInRect:self.view.bounds withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
//            screenshotImage = resultImage;
//            reState = state;//state表示地图此时是否完整，0-不完整，1-完整
//            NSLog(@"image == %@" , resultImage);
//        }];
//    });
    
    
    self.mapView = mapView;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"添加标记点");
//        [self drawMarker];
//    });
    
    
}

-(void)drawMarker{
    
    /*添加annotation*/
    self.annotations = [NSMutableArray array];
    CLLocationCoordinate2D coordinates[10] = {
        {30.992520, 120.336170},
        {30.772520, 120.366170},
        {39.992520, 116.336170},
        {39.998293, 116.352343},
        {40.004087, 116.348904},
        {40.001442, 116.353915},
        {39.989105, 116.353915},
        {39.989098, 116.360200},
        {39.998439, 116.360201},
        {39.979590, 116.324219},
        {39.978234, 116.352792}
    };
    for (int i = 0; i < 10; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"anno: %d", i];
        [self.annotations addObject:a1];
    }
    
    [self.mapView addAnnotations:self.annotations];
}

#pragma mark - MAMapViewDelegate
/**
 *  @brief 当plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription，并且[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined，会调用代理的此方法。
    此方法实现调用后台权限API即可（ 该回调必须实现 [locationManager requestAlwaysAuthorization] ）; since 6.8.0
 *  @param locationManager  地图的CLLocationManager。
 */
-(void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager {
    //请求获取定位
    [locationManager requestAlwaysAuthorization];
    
}

/**
 * @brief 地图区域改变过程中会调用此接口 since 4.6.0
 * @param mapView 地图View
 */
-(void)mapViewRegionChanged:(MAMapView *)mapView {
    NSLog(@"🥬🥬====%s", __FUNCTION__);
}
/**
 * @brief 地图移动结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    NSLog(@"🥬🥬====%s", __FUNCTION__);
}
/**
 * @brief 地图缩放结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    NSLog(@"🥬🥬====%s", __FUNCTION__);
}
/**
 * @brief 地图加载成功
 * @param mapView 地图View
 */
- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView{
    NSLog(@"🥬🥬====%s", __FUNCTION__);
}
/**
 * @brief 地图加载失败
 * @param mapView 地图View
 * @param error 错误信息
 */
- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error {
    NSLog(@"🥬🥬====%s", __FUNCTION__);
}

/* 实现代理方法：*/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    NSLog(@"🥬🥬viewForAnnotation ==%@" , annotation.class);
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
     } else
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
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
        NSLog(@"POIAnnotation");
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if(poiAnnotationView == nil){
            poiAnnotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        //自定义标注图标 ，默认是大头针
//        poiAnnotationView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://iconfont.alicdn.com/p/illus/preview_image/pMhdd5wW6xfB/f75d50f2-15ef-40da-9d6b-0fb351b75009.png?w=120&h=12"]]];
        //设置中心点便宜，使得标注底部点成为经纬度对应点
        poiAnnotationView.centerOffset = CGPointMake(0, -18);
        
        //自定义气泡
        
        
        
        return poiAnnotationView;
    }
    return nil;
}
-(void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id<MAAnnotation> annotation = view.annotation;
    NSLog(@"🥬🥬点击了====%.f , %.f" , annotation.coordinate.latitude , annotation.coordinate.longitude);
    
}

#pragma mark - AMapLocationManagerDelegate

/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"🍇🍇====%s", __FUNCTION__);
}
/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    NSLog(@"🍇🍇====%s", __FUNCTION__);
    MAAnimatedAnnotation *annotation = [[MAAnimatedAnnotation alloc]init];
    annotation.coordinate = location.coordinate;
    annotation.title = @"当前位置";
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

/**
 *  @brief 定位权限状态改变时回调函数。注意：iOS13及之前版本回调
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"🍇🍇====%s", __FUNCTION__);
}

/**
 *  @brief 定位权限状态改变时回调函数。注意：iOS14及之后版本回调
 *  @param manager 定位 AMapLocationManager 类。
 *  @param locationManager  定位CLLocationManager类，可通过locationManager.authorizationStatus获取定位权限，通过locationManager.accuracyAuthorization获取定位精度权限
 */
- (void)amapLocationManager:(AMapLocationManager *)manager locationManagerDidChangeAuthorization:(CLLocationManager*)locationManager{
    NSLog(@"🍇🍇====%s", __FUNCTION__);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(BOOL)viewControllerIsNeedNavBar:(ZBaseViewController *)viewController {
    return YES;
}

@end





@interface POIAnnotation ()

//@property (nonatomic, readwrite, strong) AMapPOI *poi;

@end

@implementation POIAnnotation
@synthesize poi = _poi;

#pragma mark - MAAnnotation Protocol

-(void)setTitle:(NSString *)title {
    _poi.name = title;
}

- (NSString *)title
{
    return self.poi.name;
}

- (NSString *)subtitle
{
    return self.poi.address;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init])
    {
        self.poi = poi;
    }
    
    return self;
}


@end
