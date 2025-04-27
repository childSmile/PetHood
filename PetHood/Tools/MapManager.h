//
//  MapManager.h
//  PetHood
//
//  Created by MacPro on 2024/7/1.
//

#import <Foundation/Foundation.h>

#import <AMapNaviKit/MAMapView.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import <AMapNaviKit/MAPinAnnotationView.h>
#import "AMapNaviKit/AMapNaviDriveManager.h"
#import <AMapNaviKit/AMapNaviWalkManager.h>

#import <AMapSearchKit/AMapSearchAPI.h>

NS_ASSUME_NONNULL_BEGIN
 
typedef enum {
    WalkNaviRoutePlan,
    DriveNaviRoutePlan,
}MapNaviRoutePlanType;

@protocol MapMangerDelegate <NSObject>

@optional
//地图加载成功
-(void)mapViewDidFinishLoadingMap:(MAMapView *)mapView ;

//点击AnnotationView
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view;
//单击地图
-(void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate;
//更新定位
-(void)didUpdateUserLocation:(CLLocation *)location ;

//自定义定位显示（默认是小蓝点，大头针）
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation;

//路线规划成功
//驾车
-(void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager ;
//步行
-(void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager;
//定位转换地址
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response ;

//定位权限发生改变
- (void)locationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

//搜索关键字回调
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response;

@end


//默认初始化时，单次定位
@interface MapManager : NSObject

@property (nonatomic , strong) MAMapView *mapView;
@property (nonatomic , weak) id<MapMangerDelegate> delegate;
@property (nonatomic , strong) MAAnnotationView *currentPetView;
@property (nonatomic , assign) CLAuthorizationStatus authStatus;

//规划路线
-(void)routePlanStart:(AMapNaviPoint *)startPoint end:(AMapNaviPoint *)endPoint type:(MapNaviRoutePlanType)naviType;

//定位转换地址
-(void)convertLocation:(CLLocationCoordinate2D)coor ;

//搜索
-(void)searchWithRequest:(AMapSearchObject *)request ;

//画路线
-(void)drawPath:(NSArray<AMapNaviPoint *> *)points;

//开始持续定位
-(void)startLocation;

//开始导航
-(void)startNavi;


/// 开始导航
/// - Parameters:
///   - startPoint: 起点
///   - endPoint: 终点
///   - naviType: 出行方式 0：步行；1：开车
-(void)startNaviStart:(AMapNaviPoint *)startPoint end:(AMapNaviPoint *)endPoint type:(int)naviType;

- (void)addDefaultAnnotations:(AMapNaviPoint *)start end:(AMapNaviPoint *)end;

@end

NS_ASSUME_NONNULL_END
