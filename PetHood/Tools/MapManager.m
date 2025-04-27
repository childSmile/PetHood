//
//  MapManager.m
//  PetHood
//
//  Created by MacPro on 2024/7/1.
//

#import "MapManager.h"

#import "TestMapViewController.h"
#import "QuickStartAnnotationView.h"

#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "PetAnnotationView.h"
#import "PetTripPolyline.h"


@interface MapManager ()<MAMapViewDelegate , AMapLocationManagerDelegate , AMapNaviDriveManagerDelegate , AMapNaviWalkManagerDelegate , AMapSearchDelegate>


@property (nonatomic , strong) AMapLocationManager *locationManager;

//导航
@property (nonatomic , strong) AMapNaviPoint *startPoint;
@property (nonatomic , strong) AMapNaviPoint *endPoint;

@property (nonatomic , strong) AMapSearchAPI *search;
@property (nonatomic , strong) MANaviRoute *naviRoute;
@property (nonatomic , strong) AMapRoute *route;
@property (nonatomic , strong) NSMutableArray *polyLines;
@property (nonatomic , assign) NSInteger currentRoutePlan;


@property (nonatomic , strong) AMapNaviRoute *mapNaviRoute;


@property (nonatomic , strong) MAAnnotationView *userLocationView;



@end

@implementation MapManager

-(instancetype)init {
    self = [super init];
    if(self) {
        self.polyLines = [NSMutableArray array];
        
        [self initMap];
        [self initLocation];
    }
    return self;
}



-(void)initMap {
    
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.mapView.delegate = self;
    
    //显示定位小蓝点
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    self.mapView.userLocation.title = @"您的位置在这里";
    _mapView.showsCompass = NO;
    
//    MAUserLocationRepresentation *presentation = [[MAUserLocationRepresentation alloc]init];
    //    ///精度圈是否显示，默认YES
//    presentation.showsAccuracyRing = YES;
    ///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
//    presentation.showsHeadingIndicator = YES;
    //    presentation.fillColor = UIColor.redColor;
    //    presentation.strokeColor = UIColor.lightGrayColor;
    //    presentation.lineWidth = 2.0;
    ////    presentation.image = [UIImage imageNamed:@"userPosition"];
//    [self.mapView updateUserLocationRepresentation:presentation];
    
}

-(void)initLocation {
    
    //单次定位
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        //定位成功回调
        NSLog(@"单次定位成功==%@" ,location);
        //        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        //        [self.mapView setCenterCoordinate:coor animated:YES];
        //
        //        self.startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        
        
    }];
}

//开始持续定位
-(void)startLocation {
    [self.locationManager startUpdatingLocation];
}

-(void)routePlanStart:(AMapNaviPoint *)startPoint end:(AMapNaviPoint *)endPoint type:(MapNaviRoutePlanType)naviType{
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    
    NSLog(@"默认先规划完路径 规划完成后开始导航");
    if(naviType == WalkNaviRoutePlan) {
        [self walkRoutePlan];
    }else {
        [self driveRoutePlan];
    }
    
}
//路线规划
-(void)walkRoutePlan {
    
    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:self.startPoint.latitude longitude:self.startPoint.longitude];
    AMapGeoPoint *end = [AMapGeoPoint locationWithLatitude:self.endPoint.latitude longitude:self.endPoint.longitude];
    
    //步行规划
    AMapWalkingRouteSearchRequest *walkRequest = [[AMapWalkingRouteSearchRequest alloc]init];
    walkRequest.origin = start;
    walkRequest.destination = end;
    walkRequest.showFieldsType = AMapWalkingRouteShowFieldTypeAll;
    [self.search AMapWalkingRouteSearch:walkRequest];
    
    
}
-(void)driveRoutePlan {
    
    //开车规划
    /**
     ///规避道路类型 @since 9.2.0
     typedef NS_ENUM(NSUInteger, AMapDrivingRouteShowFieldType)
     {
     AMapDrivingRouteShowFieldTypeNone     = 1 << 0, ///< 不返回扩展信息
     AMapDrivingRouteShowFieldTypeCost     = 1 << 1, ///< 返回方案所需时间及费用成本
     AMapDrivingRouteShowFieldTypeTmcs     = 1 << 2, ///< 返回分段路况详情
     AMapDrivingRouteShowFieldTypeNavi     = 1 << 3, ///< 返回详细导航动作指令
     AMapDrivingRouteShowFieldTypeCities   = 1 << 4, ///< 返回分段途径城市信息
     AMapDrivingRouteShowFieldTypePolyline = 1 << 5, ///< 返回分段路坐标点串，两点间用“,”分隔
     AMapDrivingRouteShowFieldTypeNewEnergy = 1 << 6,///< 返回分段路坐标点串，两点间用“,”分隔
     AMapDrivingRouteShowFieldTypeAll      = ~0UL,   ///< 返回所有扩展信息
     };
     */
    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:self.startPoint.latitude longitude:self.startPoint.longitude];
    AMapGeoPoint *end = [AMapGeoPoint locationWithLatitude:self.endPoint.latitude longitude:self.endPoint.longitude];
    AMapDrivingCalRouteSearchRequest *drivingRequest = [[AMapDrivingCalRouteSearchRequest alloc]init];
    drivingRequest.showFieldType = AMapDrivingRouteShowFieldTypeCost
    | AMapDrivingRouteShowFieldTypeTmcs
    | AMapDrivingRouteShowFieldTypeNavi
    | AMapDrivingRouteShowFieldTypeCities
    | AMapDrivingRouteShowFieldTypePolyline;
    drivingRequest.origin = start;
    drivingRequest.destination = end;
    drivingRequest.strategy = 32;//高德默认
    [self.search AMapDrivingV2RouteSearch:drivingRequest];
}

-(void)startNavi {
    NSLog(@"开始导航 == %@" , self.class);
//    AMapPath *path = self.route.paths[self.currentRoutePlan];
    
    
}

-(void)startNaviStart:(AMapNaviPoint *)startPoint end:(AMapNaviPoint *)endPoint type:(int)naviType {
    
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    //0 步行； 1 开车
    if(naviType == 0 ) {
        //骑车、步行
        [AMapNaviWalkManager sharedInstance].delegate = self;
        [[AMapNaviWalkManager sharedInstance] calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
    }else {
        //驾车、货车开始规划路径
        [AMapNaviDriveManager sharedInstance].delegate = self;
        [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                                        endPoints:@[self.endPoint]
                                                                        wayPoints:nil
                                                                  drivingStrategy:AMapNaviDrivingStrategyMultipleDefault //多路径: 默认,速度优先(避让拥堵+速度优先+避免收费) 详见下方
        ];
        
        
    }
}

//展示当前路线方案
-(void)presentCurrentPlan {
    
    //    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    //    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    //    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:self.startPoint.latitude longitude:self.startPoint.longitude];
    //    AMapGeoPoint *end = [AMapGeoPoint locationWithLatitude:self.endPoint.latitude longitude:self.endPoint.longitude];
    //    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths.firstObject withNaviType:type showTraffic:YES startPoint:start endPoint:end];
    //
    //    [self.naviRoute addToMapView:self.mapView];
    //
    //    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines] edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
    
    [self.mapView removeOverlays:self.polyLines];
    [self.polyLines removeAllObjects];
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //选择默认的第一条
        AMapPath *path = self.route.paths.firstObject;
        NSString *polylineString = path.polyline;
        //        NSLog(@"路线点：%@ ， 距离：%ld , 时间:%ld" , polylineString , (long)path.distance , (long)path.duration);
        NSLog(@"polylineString== %@" , polylineString);
        
        MAPolyline *polyline = [CommonUtility polylineForCoordinateString:polylineString];
        PetTripPolyline *petPolyline = [[PetTripPolyline alloc]initWithPolyline:polyline traveled:false];
        
        [self.polyLines addObject:petPolyline];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            //路径绘制
            [self.mapView addOverlay:petPolyline];
//            [self.mapView showOverlays:self.polyLines edgePadding:UIEdgeInsetsMake(DHPX(80), DHPX(80), DHPX(80), DHPX(80)) animated:false];
        });
        
        
        //显示所有的路线
        /*
        for (AMapPath *path in self.route.paths) {
            
            //        AMapPath *path = response.route.paths.firstObject;
            NSString *polylineString = path.polyline;
            //        NSLog(@"路线点：%@ ， 距离：%ld , 时间:%ld" , polylineString , (long)path.distance , (long)path.duration);
            NSLog(@"polylineString== %@" , polylineString);
            
            MAPolyline *polyline = [CommonUtility polylineForCoordinateString:polylineString];
            
            [self.polyLines addObject:polyline];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                //路径绘制
                [self.mapView addOverlay:polyline];
            });
            
        }
         */
    });
}

//先计算路线再展示路线
-(void)showRoutes {
    
    int count = (int)self.mapNaviRoute.routeCoordinates.count;
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++) {
        AMapNaviPoint *coorPoint = self.mapNaviRoute.routeCoordinates[i];
        coords[i].latitude = coorPoint.latitude;
        coords[i].longitude = coorPoint.longitude;
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    
    [self.mapView addOverlay:polyline];
    
}


-(void)convertLocation:(CLLocationCoordinate2D)coor {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc]init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}


-(void)drawPath:(NSArray<AMapNaviPoint *> *)points{
    
    int count = (int)points.count;
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++) {
        AMapNaviPoint *coorPoint = points[i];
        coords[i].latitude = coorPoint.latitude;
        coords[i].longitude = coorPoint.longitude;
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    PetTripPolyline *petPolyline = [[PetTripPolyline alloc]initWithPolyline:polyline traveled:YES];
    
    [self.mapView addOverlay:petPolyline];
    
    
}

//搜索某个位置
-(void)searchWithKeyWord:(NSString *)keyWord {
    
    //设置关键字检索参数
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = keyWord;
    
    //发起关键字搜索
    [self searchWithRequest:request];
    
}
-(void)searchWithRequest:(AMapSearchObject *)request {
    
    if([request isKindOfClass:AMapPOIKeywordsSearchRequest.class]) {
        AMapPOIKeywordsSearchRequest *poiKeySearchRequest = (AMapPOIKeywordsSearchRequest *)request;
        [self.search AMapPOIKeywordsSearch:poiKeySearchRequest];
    }
}
- (void)addDefaultAnnotations:(AMapNaviPoint *)start end:(AMapNaviPoint *)end
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = CLLocationCoordinate2DMake(start.latitude, start.longitude);
    startAnnotation.title      = @"起点";
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
//    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = CLLocationCoordinate2DMake(end.latitude, end.longitude);
    destinationAnnotation.title      = @"终点";
//    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
//    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

#pragma mark - AMapSearchDelegate
//搜索关键字回调
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    NSLog(@"搜索关键字回调 == %@" , response);
    if(self.delegate && [self.delegate respondsToSelector:@selector(onPOISearchDone:response:)]) {
        [self.delegate onPOISearchDone:request response:response];
    }
    
    /**
     
     if(response.pois.count == 0) {
         NSLog(@"没有搜索到");
         return;
     }
     //解析POI信息
     __block NSMutableArray<POIAnnotation *> *poiAnnotations = [NSMutableArray array];
     [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [poiAnnotations addObject:[[POIAnnotation alloc]initWithPOI:obj]];
     }];
     
     //显示在地图上
     [self.mapView addAnnotations:poiAnnotations];
     if(poiAnnotations.count == 1) {
         [self.mapView setCenterCoordinate:[poiAnnotations.firstObject coordinate] animated:YES];
     }else {
         [self.mapView showAnnotations:poiAnnotations animated:NO];
         [self.mapView showAnnotations:poiAnnotations edgePadding:UIEdgeInsetsMake(DHPX(100), DHPX(10), DHPX(200), DHPX(10)) animated:YES];
     }
     
     
     */
    
}
//转换坐标回调
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    NSLog(@"onReGeocodeSearchDone==%@" , response);
    if(self.delegate && [self.delegate respondsToSelector:@selector(onReGeocodeSearchDone:response:)]) {
        [self.delegate onReGeocodeSearchDone:request response:response];
    }
}
//搜索路径回调 - 失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"%@路径查询失败===%@" ,request, error);
    
}
//搜索路径回调 - 成功
-(void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    NSLog(@"路径查询完成 ==%@" , response);
    /**
     response.count  一共条线路
     route.paths 具体路径信息
     */
    
    //选择路线1
    if(response.count  == 0) {
        NSLog(@"没有合适的路线");
        return;
    }
    
    self.route = response.route;
    
    //展示当前路径
    [self presentCurrentPlan];
    
    
    //    AMapPath *path = response.route.paths.firstObject;
    //            NSString *polylineString = path.polyline;
    //    //        NSLog(@"路线点：%@ ， 距离：%ld , 时间:%ld" , polylineString , (long)path.distance , (long)path.duration);
    //
    //            MAPolyline *polyline = [CommonUtility polylineForCoordinateString:polylineString];
    //
    //            //路径绘制
    //            [self.mapView addOverlay:polyline];
    
    
    
    
    //    [self.naviRoute removeFromMapView];
    //    self.naviRoute = [MANaviRoute naviRouteForPath:response.route.paths.firstObject
    //                                      withNaviType:MANaviAnnotationTypeDrive
    //                                       showTraffic:YES
    //                                        startPoint:start
    //                                          endPoint:end];
    //    [self.naviRoute addToMapView:self.mapView];
    //
    //    [self.mapView setVisibleMapRect:[CommonUtility
    //                                     mapRectForOverlays:self.naviRoute.routePolylines]
    //                        edgePadding:UIEdgeInsetsMake(10, 10, 10, 10)
    //                           animated:YES];
    
    
    
    
    //    [self.mapView addOverlay: ];
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


//路径绘制代理
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    NSLog(@"rendererForOverlay==%@" , overlay);
    
    if([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc]initWithOverlay:overlay];
//        circleRenderer.strokeColor = [UIColor colorWithRGB:0x000000 alpha:0.4];
        circleRenderer.fillColor = [UIColor colorWithRGB:0x4C96FF alpha:0.1];
        return  circleRenderer;
    }else
    
    if([overlay isKindOfClass:[PetTripPolyline class]]) {
        NSLog(@"PetTripPolyline");
        PetTripPolyline *tripPoly = (PetTripPolyline *)overlay;
        if(tripPoly.traveled) {

            MAMultiPolyline *multiPolyline = [MAMultiPolyline polylineWithPoints:tripPoly.polyline.points count:tripPoly.polyline.pointCount];
            multiPolyline.drawStyleIndexes = @[@0 , @(tripPoly.polyline.pointCount)];
            MAMultiColoredPolylineRenderer *multiPolyView = [[MAMultiColoredPolylineRenderer alloc]initWithPolyline:multiPolyline];
            multiPolyView.lineWidth = 4;
            multiPolyView.gradient = YES;
            multiPolyView.strokeColors = @[[UIColor colorWithRGB:0xBECEDA alpha:1] , [UIColor colorWithRGB:0xBECEDA alpha:0.4] ];
            return multiPolyView;
        }else {
            MAPolylineRenderer *polyView = [[MAPolylineRenderer alloc]initWithPolyline:tripPoly.polyline];
            polyView.lineWidth = 4;
            polyView.strokeColor = tripPoly.traveled ?  [UIColor colorWithHexString:@"#BECEDA"] : [UIColor colorWithHexString:@"#4C96FF"];
            
            return polyView;
        }
        

        
    }else
        
        if([overlay isKindOfClass:[MANaviPolyline class]]) {
            NSLog(@"MANaviPolyline");
            MANaviPolyline *naviPoly = (MANaviPolyline *)overlay;
            MAPolylineRenderer *polyView = [[MAPolylineRenderer alloc]initWithPolyline:naviPoly.polyline];
            polyView.lineWidth = 4;
            polyView.strokeColor = UIColor.blueColor;
            return polyView;
            
        } else {
            
            MAPolyline *poly = (MAPolyline *)overlay;
            BOOL isCuurent = NO;
            if([self.polyLines indexOfObject:poly]  == self.currentRoutePlan ) {
                NSLog(@"我是选中的路线");
                isCuurent = YES;
            }else {
                NSLog(@"我是其他的路线");
                isCuurent = NO;
            }
            MAPolylineRenderer *polyView = [[MAPolylineRenderer alloc]initWithPolyline:poly];
            polyView.lineWidth = isCuurent ? 8.0 : 5.0;
            polyView.strokeColor = UIColor.blackColor;
            //    polyView.strokeImage = [UIImage imageWithColor:UIColor.greenColor size:CGSizeMake(10, 30)];
            return polyView;
            
        }
    
    return  nil;
    
}
-(void)mapViewDidFinishLoadingMap:(MAMapView *)mapView {
    NSLog(@"地图加载成功");
    if(self.delegate && [self.delegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)]) {
        [self.delegate mapViewDidFinishLoadingMap:mapView];
    }
}
-(void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error {
    NSLog(@"地图加载失败===%@" ,error);
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
//    NSLog(@"didUpdateUserLocation==%@" , userLocation);
    if(self.delegate && [self.delegate respondsToSelector:@selector(didUpdateUserLocation:)]) {
        [self.delegate didUpdateUserLocation: userLocation.location];
    }
    if(!updatingLocation && self.userLocationView != nil) {
        MAAnnotationView *userLocationView = [mapView viewForAnnotation:(MAUserLocation *)userLocation];
        [UIView animateWithDuration:0.1 animations:^{
            double degress = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            userLocationView.imageView.transform = CGAffineTransformMakeRotation(degress * M_PI / 180.f);
        }];
        
    }
}

-(void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"单击地图===%f===%f" , coordinate.latitude , coordinate.longitude);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:)]) {
        [self.delegate mapView:mapView didSingleTappedAtCoordinate:coordinate];
    }
    
    return;
    
    
    if(self.route.paths.count == 0) {
        return;
    }
    __block NSInteger hitIndex = -1;
    [self.polyLines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPolyline *poly = (MAPolyline *)obj;
        BOOL hit = [CommonUtility polylineHitTestWithCoordinate:coordinate mapView:self.mapView polylinePoints:poly.points pointCount:poly.pointCount lineWidth:20];
        if(hit) {
            hitIndex = (NSInteger)idx;
            *stop = YES;
        }
    }];
    
    
    if(hitIndex >= 0) {
        NSLog(@"选中了当前方案并开始导航");
        self.currentRoutePlan = hitIndex;
        [self presentCurrentPlan];
        
    }
    
}


//显示位置
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    NSLog(@"viewForAnnotation == %@" , annotation);
    
    if([annotation isKindOfClass:[MAUserLocation class]]) {
        NSLog(@"MAUserLocation");
        static NSString *pointReuseIndetifier = @"usertReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;
        
        annotationView.image = [UIImage imageNamed:@"map_my_position_icon"];
        
        self.userLocationView = annotationView;
        
        return annotationView;
    } else
        if([annotation isKindOfClass:[PetMAPointAnnotation class]]) {
            NSLog(@"petPointReuseIndetifier");
            PetMAPointAnnotation *pet = (PetMAPointAnnotation *)annotation;
            MAAnnotationView *annotationView;
            
            if(pet.isCurrent) {
                static NSString *pointReuseIndetifier = @"currentPetPointReuseIndetifier";
                annotationView = (CurrentPetAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
                if (annotationView == nil) {
                    annotationView = [[CurrentPetAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
                }
                
                self.currentPetView = annotationView;
                
                for ( id obj in mapView.overlays) {
                    if ([obj isKindOfClass:[MACircle class]]) {
                        [mapView removeOverlay:obj];
                        break;
                    }
                }

                MACircle * circle = [MACircle circleWithCenterCoordinate:pet.coordinate radius:500];
                [mapView addOverlay:circle];
                
            } else {
                static NSString *pointReuseIndetifier = @"petPointReuseIndetifier";
                annotationView = (PetAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
                if (annotationView == nil)
                {
                    annotationView = [[PetAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
                }
            }
            
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            
            return annotationView;
        } else if([annotation isKindOfClass:[MAPointAnnotation class]]) {
            NSLog(@"normalReuseIndetifier");
            static NSString *pointReuseIndetifier = @"normalReuseIndetifier";
            MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            
            /* 起点. */
            if ([[annotation title] isEqualToString:@"起点"])
            {
                annotationView.image = [UIImage imageNamed:@"map_trip_start_icon"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:@"终点"])
            {
                annotationView.image = [UIImage imageNamed:@"map_trip_end_icon"];
            }
            
            return annotationView;
        }
    
    return nil;
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"didSelectAnnotationView");
    if(self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)]) {
        [self.delegate mapView:mapView didSelectAnnotationView:view];
    }
}


-(void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view {
    NSLog(@"didAnnotationViewCalloutTapped == %@" , view);
}
-(void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id<MAAnnotation> annotation = view.annotation;
    NSLog(@"calloutAccessoryControlTapped==latitude: %f , longitude:%f , title:%@"  , annotation.coordinate.latitude , annotation.coordinate.longitude , annotation.title);
    
    self.endPoint = [AMapNaviPoint locationWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    
}
#pragma mark - AMapNaviDriveManagerDelegate
-(void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"驾车路线规划成功回调，可以在这里开启导航");
    if(self.delegate && [self.delegate respondsToSelector:@selector(driveManagerOnCalculateRouteSuccess:)]) {
        [self.delegate driveManagerOnCalculateRouteSuccess:driveManager];
    }
    
}
-(void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error routePlanType:(AMapNaviRoutePlanType)type {
    NSLog(@"驾车路线规划失败回调,可以在这里提示==%@" , error);
}


#pragma mark - AMapNaviWalkManagerDelegate
-(void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager {
    NSLog(@"步行路线规划成功回调，可以在这里开启导航");
    
//    self.mapNaviRoute = walkManager.naviRoute;
//    //展示路线
//    [self showRoutes];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(walkManagerOnCalculateRouteSuccess:)]) {
        [self.delegate walkManagerOnCalculateRouteSuccess:walkManager];
    }
}
-(void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"步行路线规划失败回调,可以在这里提示==%@" , error);
}
- (void)walkManager:(AMapNaviWalkManager *)walkManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)walkManagerNeedRecalculateRouteForYaw:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
}

- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onArrivedDestination");
}




#pragma mark - AMapLocationManagerDelegate
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败==%@" , error);
}

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    NSLog(@"连续定位，位置更新回调==%@" , location);
    if(self.delegate && [self.delegate respondsToSelector:@selector(didUpdateUserLocation:)]) {
        [self.delegate didUpdateUserLocation:location];
    }
}
/**
 AuthorizedAlways    3
 AuthorizedWhenInUse    4
 Denied    2  不允许该应用使用定位服务。
 NotDetermined    0 用户尚未选择是否允许定位服务。
 Restricted    1 位置服务不可用，用户无法更改授权 (例如，受家长控制) 的约束。
 */
-(void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"iOS13以及之前版本，定位权限改变回调===%@" ,@(status));
    [self alertAuth:status manager:manager];
}
- (void)amapLocationManager:(AMapLocationManager *)manager locationManagerDidChangeAuthorization:(CLLocationManager *)locationManager {
    
    if (@available(iOS 14.0, *)) {
        NSLog(@"iOS14以及之后版本，定位权限改变回调===%@" , @(locationManager.authorizationStatus));
        [self alertAuth:locationManager.authorizationStatus manager:manager];
    } else {
        // Fallback on earlier versions
    }
    
}


-(void)alertAuth:(CLAuthorizationStatus)status manager:(AMapLocationManager*)manager {
    NSLog(@"定位权限改变回调===%@" , @(status));
    self.authStatus = status;
    if(self.delegate && [self.delegate respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]) {
        [self.delegate locationManager:manager didChangeAuthorizationStatus:status];
    }
}

-(AMapLocationManager *)locationManager {
    if(!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

-(AMapSearchAPI *)search {
    if(!_search) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}



@end


/**
 ///驾车、货车路径规划策略.
 typedef NS_ENUM(NSInteger, AMapNaviDrivingStrategy)
 {
 AMapNaviDrivingStrategySingleInvalid = -1,                              ///< -1 非法
 AMapNaviDrivingStrategySingleDefault = 0,                               ///< 0 单路径: 默认,速度优先(常规最快)
 AMapNaviDrivingStrategySingleAvoidCost = 1,                             ///< 1 单路径: 避免收费
 AMapNaviDrivingStrategySinglePrioritiseDistance = 2,                    ///< 2 单路径: 距离优先
 AMapNaviDrivingStrategySingleAvoidExpressway = 3,                       ///< 3 单路径: 不走快速路
 AMapNaviDrivingStrategySingleAvoidCongestion = 4,                       ///< 4 单路径: 躲避拥堵
 AMapNaviDrivingStrategySinglePrioritiseSpeedCostDistance = 5,           ///< 5 单路径: 速度优先 & 费用优先 & 距离优先
 AMapNaviDrivingStrategySingleAvoidHighway = 6,                          ///< 6 单路径: 不走高速
 AMapNaviDrivingStrategySingleAvoidHighwayAndCost = 7,                   ///< 7 单路径: 不走高速 & 避免收费
 AMapNaviDrivingStrategySingleAvoidCostAndCongestion = 8,                ///< 8 单路径: 避免收费 & 躲避拥堵
 AMapNaviDrivingStrategySingleAvoidHighwayAndCostAndCongestion = 9,      ///< 9 单路径: 不走高速 & 避免收费 & 躲避拥堵
 
 AMapNaviDrivingStrategyMultipleDefault = 10,                            ///< 10  多路径: 默认,速度优先(避让拥堵+速度优先+避免收费)
 AMapNaviDrivingStrategyMultipleShortestTimeDistance = 11,               ///< 11  多路径: 时间最短 & 距离最短
 AMapNaviDrivingStrategyMultipleAvoidCongestion = 12,                    ///< 12  多路径: 躲避拥堵
 AMapNaviDrivingStrategyMultipleAvoidHighway = 13,                       ///< 13  多路径: 不走高速
 AMapNaviDrivingStrategyMultipleAvoidCost = 14,                          ///< 14  多路径: 避免收费
 AMapNaviDrivingStrategyMultipleAvoidHighwayAndCongestion = 15,          ///< 15  多路径: 不走高速 & 躲避拥堵
 AMapNaviDrivingStrategyMultipleAvoidHighwayAndCost = 16,                ///< 16  多路径: 不走高速 & 避免收费
 AMapNaviDrivingStrategyMultipleAvoidCostAndCongestion = 17,             ///< 17  多路径: 避免收费 & 躲避拥堵
 AMapNaviDrivingStrategyMultipleAvoidHighwayAndCostAndCongestion = 18,   ///< 18  多路径: 不走高速 & 避免收费 & 躲避拥堵
 AMapNaviDrivingStrategyMultiplePrioritiseHighway = 19,                  ///< 19  多路径: 高速优先
 AMapNaviDrivingStrategyMultiplePrioritiseHighwayAvoidCongestion = 20,   ///< 20  多路径: 高速优先 & 躲避拥堵
 
 AMapNaviMotorStrategyMultipleDefault = 2001,                     ///< 2001 针对摩托车多路径: 默认  since 8.0.0
 AMapNaviMotorStrategyMultipleAvoidHighway = 2002,                ///< 2002 针对摩托车多路径: 不走高速   since 8.0.0
 AMapNaviMotorStrategyMultiplePrioritiseHighway = 2003,           ///< 2003 针对摩托车多路径: 高速优先   since 8.0.0
 AMapNaviMotorStrategyMultipleAvoidCost = 2004,                   ///< 2004 针对摩托车多路径: 避免收费   since 8.0.0
 };
 
 
 
 
 
 
 
 */
