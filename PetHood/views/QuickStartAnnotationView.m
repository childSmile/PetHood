//
//  QuickStartAnnotationView.m
//  AMapNaviKit
//
//  Created by 刘博 on 16/3/9.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "QuickStartAnnotationView.h"

#define naviButtonWidth 44
#define naviButtonHeight 74

@implementation NaviButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"naviBackgroundNormal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"naviBackgroundHighlighted"] forState:UIControlStateSelected];
        
        //imageView
        _carImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi"]];
        [self addSubview:_carImageView];
        
        //label
        _naviLabel = [[UILabel alloc] init];
        _naviLabel.text = @"导航";
        _naviLabel.font = [_naviLabel.font fontWithSize:9];
        _naviLabel.textColor = [UIColor redColor];
        [_naviLabel sizeToFit];
        
        [self addSubview:_naviLabel];
    }
    
    return self;
}

#define kMarginRatio 0.1
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _carImageView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.superview.frame) - CGRectGetHeight(_carImageView.frame) * (0.5 + kMarginRatio));
    
    _naviLabel.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.superview.frame) + CGRectGetHeight(_naviLabel.frame) * (0.5 + kMarginRatio));
}

@end

@implementation QuickStartAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NaviButton *naviButton = [[NaviButton alloc] initWithFrame:(CGRectMake(0, 0, naviButtonWidth, naviButtonHeight))];
        
        self.leftCalloutAccessoryView = naviButton;
    }
    return self;
}

@end

@implementation CurrentLocationAnnotation

@end
