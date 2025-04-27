//
//  PetTripPolyline.m
//  PetHood
//
//  Created by MacPro on 2024/7/15.
//

#import "PetTripPolyline.h"

@implementation PetTripPolyline


-(id)initWithPolyline:(MAPolyline *)polyline traveled:(BOOL)traveled {
    self = [super init];
    if (self)
    {
        self.polyline = polyline;
        self.traveled = traveled;
    }
    return self;
}


- (MAMapRect) boundingMapRect
{
    return [_polyline boundingMapRect];
}


@end
