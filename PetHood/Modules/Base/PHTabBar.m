//
//  PHTabBar.m
//  PetHood
//
//  Created by MacPro on 2024/7/8.
//

#import "PHTabBar.h"

@implementation PHTabBar


-(instancetype)init {
    self = [super init];
    if(self) {
    
        
        NSLog(@"init");
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        NSLog(@"initWithFrame");
        
    }
    return  self;
}



-(void)layoutSubviews {
    NSLog(@"layoutSubviews===tabbar");
    self.backgroundColor = UIColor.whiteColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    self.layer.mask = layer;
    
}

@end
