//
//  LineDashPolyline.h
//  OfficialDemo3D
//
//  Created by Li Fei on 10/25/13.
//  Copyright (c) 2013 songjian. All rights reserved.
//

#import <AMapNaviKit/MAMapView.h>
#import <AMapNaviKit/MAPolyline.h>

@interface LineDashPolyline :MABaseOverlay

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) MAMapRect boundingMapRect;

@property (nonatomic, retain)  MAPolyline *polyline;

- (id)initWithPolyline:(MAPolyline *)polyline;

@end
