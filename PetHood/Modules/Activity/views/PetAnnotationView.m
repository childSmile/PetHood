//
//  PetAnnotationView.m
//  PetHood
//
//  Created by MacPro on 2024/7/9.
//

#define kArrorHeight    4

#define pet1 @"https://t11.baidu.com/it/u=1869226403,207948928&fm=30&app=106&f=JPEG?w=640&h=853&s=BFC22ED1CF1070C63A795D4F0300B074"
#define  pet2 @"https://t11.baidu.com/it/u=1950606372,216145805&fm=30&app=106&f=JPEG?w=640&h=853&s=598BAB554CAB761F50B1856E03006033"
#import "PetAnnotationView.h"

@interface PetAnnotationView ()
@property (nonatomic , strong) UIImageView *photoImgV;
@property (nonatomic , strong) UIView *calloutView;

@end

@implementation PetAnnotationView

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        
        self.bounds = CGRectMake(0, 0, DHPX(40), DHPX(40) + kArrorHeight);
        self.layer.cornerRadius = self.bounds.size.width / 2.0;
        self.backgroundColor = UIColor.clearColor;
        [self addAllSubviews];
        
    }
    return self;
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
//            self.calloutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 70)];
////            self.calloutView.backgroundColor = UIColor.redColor;
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  - CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y - 6) ;
//            
////            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
////                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(10, 10, 40, 40);
//            [btn setTitle:@"Test" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//            [btn setBackgroundColor:[UIColor whiteColor]];
//            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self.calloutView addSubview:btn];
//            
//            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
//            name.backgroundColor = [UIColor clearColor];
//            name.textColor = [UIColor whiteColor];
//            name.text = @"Hello Amap!";
//            [self.calloutView addSubview:name];
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
    
}
#pragma mark - draw rect
-(void)drawRect:(CGRect)rect {
    
    [self getDrawPath:UIGraphicsGetCurrentContext()];
//    [self drawInContext: UIGraphicsGetCurrentContext()];
}

- (void)getDrawPath:(CGContextRef)context
{
    CGFloat arrH = kArrorHeight;
    
    CGFloat lineW = 2;
    
    CGRect rrect = self.bounds;
    CGFloat radius = (rrect.size.width - lineW) / 2.0;
    CGFloat midx = CGRectGetMidX(rrect),
    midy = CGRectGetMidY(rrect) - arrH / 2,
//    minx = CGRectGetMinX(rrect),
//    maxx = CGRectGetMaxX(rrect),
    maxy = CGRectGetMaxY(rrect);
//    CGFloat miny = CGRectGetMinY(rrect),
//    maxy = CGRectGetMaxY(rrect)-kArrorHeight ;
//
//    CGContextMoveToPoint(context, midx+kArrorHeight , maxy);
//    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
//    CGContextAddLineToPoint(context,midx-kArrorHeight , maxy );
    
//    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
//    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
//    CGContextClosePath(context);
    
    CGContextSaveGState(context);
    
    
    CGFloat arrowAngle = M_PI / 18;
    
//    CGPoint arrTip = CGPointMake(
//                                 radius * cos(arrowAngle), radius * sin(arrowAngle)
//                                 );
//    CGPoint arrBase = CGPointMake(
//                                  arrTip.x - arrW / 2 * cos(arrowAngle + M_PI_4),
//                                  arrTip.y - arrH / 2 * sin( arrowAngle + M_PI_4)
//                                  );
//
//    CGPoint arrStart = CGPointMake(
//                                   arrTip.x - arrW / 2 * cos(arrowAngle - M_PI_4),
//                                   arrTip.y - arrW / 2 * sin(arrowAngle - M_PI_4)
//                                   );
    
    UIBezierPath *arrPath = [[UIBezierPath alloc]init];
    CGFloat r = radius + lineW / 2;
//    CGFloat ar = 4;
    [arrPath moveToPoint:CGPointMake(midx + r * sin(arrowAngle), midy + r * cos(arrowAngle))];
        [arrPath addLineToPoint:CGPointMake(midx, maxy)];
//    [arrPath addLineToPoint:CGPointMake(midx + ar, maxy - ar )];
//    [arrPath addArcWithCenter:CGPointMake(midx, midy - ar) radius:ar startAngle:0 endAngle:M_PI clockwise:YES];
//    [arrPath addLineToPoint:CGPointMake(midx - ar, maxy - ar )];
    [arrPath addLineToPoint:CGPointMake(midx - r * sin(arrowAngle), midy + r * cos(arrowAngle))];
    [arrPath closePath];
    
    [UIColorHex(#ffffFF) setFill];
    [arrPath fill];
  
    // 恢复图形上下文状态
    CGContextRestoreGState(context);
   
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(midx, midy) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    circle.lineWidth = lineW;
    [UIColorHex(#ffffFF) setStroke];
    [circle stroke];
    
}


/*
#pragma mark - draw rect
-(void)drawRect:(CGRect)rect {
    
    [self drawInContext: UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, UIColorHex(#ffffff).CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}


- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = rrect.size.width / 2.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}
*/


#pragma mark - UI
-(void)addAllSubviews {
    [self addSubview:self.photoImgV];
    [self.photoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(2, 2, 2 + kArrorHeight, 2));
    }];
    _photoImgV.layer.cornerRadius = (self.bounds.size.width - 2 * 2) / 2.0;
    _photoImgV.clipsToBounds = YES;
    [self.photoImgV setImageWithURL:[NSURL URLWithString:pet1] options:YYWebImageOptionUseNSURLCache];
}


-(UIImageView *)photoImgV {
    if (!_photoImgV) {
        _photoImgV = [UIImageView new];
//        _photoImgV.backgroundColor = UIColor.blueColor;
        
    }
    return _photoImgV;
}

//-(UIView *)calloutView {
//    if(!_calloutView) {
//        UIView *clv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
//        clv.backgroundColor = UIColor.redColor;
//        _calloutView = clv;
//        
//    }
//    return _calloutView;
//}

@end



@interface CurrentPetAnnotationView ()

@property (nonatomic , strong) UIView *pointView;


@end

@implementation CurrentPetAnnotationView

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addAllSubViews];
    }
    return  self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[PetCalloutView alloc]initWithFrame:CGRectMake(0, 0, DHPX(68), DHPX(73))];
            //            self.calloutView.backgroundColor = UIColor.redColor;
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  - CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y - 8) ;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setBackgroundImageWithURL:[NSURL URLWithString:pet2] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.calloutView addSubview:btn];
            CGFloat margin = 4;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(margin, margin, margin + kArrorHeight, margin));
//                make.top.left.mas_equalTo(2);
//                make.bottom.right.mas_equalTo(-2);
            }];
            btn.layer.cornerRadius = (self.calloutView.size.width -  2*margin) / 2.0;
            btn.clipsToBounds = YES;
 
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
    
}

-(void)btnAction {
    NSLog(@"btnAction");
}


-(void)addAllSubViews {
//    self.bounds = CGRectMake(0, 0, 42, 42);
//    self.layer.cornerRadius = 21;
//    self.backgroundColor =[UIColor colorWithRGB:0x1475FF alpha:0.1];
    [self addSubview:self.pointView];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@16);
    }];
    
    self.pointView.layer.cornerRadius = 8;
}

#pragma mark - lazy
-(UIView *)pointView {
    if(!_pointView) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor = UIColorHex(#1475FF);
        v.layer.borderColor = UIColor.whiteColor.CGColor;
        v.layer.borderWidth = 2;
        _pointView = v;
    }
    return _pointView;
}


@end



//#define kArrorWidth     10

//CustomCalloutView
@implementation PetCalloutView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.01];
    }
    return self;
}

#pragma mark - draw rect
-(void)drawRect:(CGRect)rect {
    
    [self getDrawPath:UIGraphicsGetCurrentContext()];
//    [self drawInContext: UIGraphicsGetCurrentContext()];
}

- (void)getDrawPath:(CGContextRef)context
{
    
    CGFloat arrW = 12;
    CGFloat arrH = 6;
    
    CGFloat lineW = 4;
    
    CGRect rrect = self.bounds;
    CGFloat radius = (rrect.size.width - lineW) / 2.0;
    CGFloat midx = CGRectGetMidX(rrect),
    midy = CGRectGetMidY(rrect) - arrH / 2,
//    minx = CGRectGetMinX(rrect),
//    maxx = CGRectGetMaxX(rrect),
    maxy = CGRectGetMaxY(rrect);
//    CGFloat miny = CGRectGetMinY(rrect),
//    maxy = CGRectGetMaxY(rrect)-kArrorHeight ;
//    
//    CGContextMoveToPoint(context, midx+kArrorHeight , maxy);
//    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
//    CGContextAddLineToPoint(context,midx-kArrorHeight , maxy );
    
//    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
//    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
//    CGContextClosePath(context);
    
    CGContextSaveGState(context);
    
    
    CGFloat arrowAngle = M_PI / 20;
    
//    CGPoint arrTip = CGPointMake(
//                                 radius * cos(arrowAngle), radius * sin(arrowAngle)
//                                 );
//    CGPoint arrBase = CGPointMake(
//                                  arrTip.x - arrW / 2 * cos(arrowAngle + M_PI_4),
//                                  arrTip.y - arrH / 2 * sin( arrowAngle + M_PI_4)
//                                  );
//    
//    CGPoint arrStart = CGPointMake(
//                                   arrTip.x - arrW / 2 * cos(arrowAngle - M_PI_4),
//                                   arrTip.y - arrW / 2 * sin(arrowAngle - M_PI_4)
//                                   );
    
    UIBezierPath *arrPath = [[UIBezierPath alloc]init];
    CGFloat r = radius + lineW / 2;
//    CGFloat ar = 4;
    [arrPath moveToPoint:CGPointMake(midx + r * sin(arrowAngle), midy + r * cos(arrowAngle))];
        [arrPath addLineToPoint:CGPointMake(midx, maxy)];
//    [arrPath addLineToPoint:CGPointMake(midx + ar, maxy - ar )];
//    [arrPath addArcWithCenter:CGPointMake(midx, midy - ar) radius:ar startAngle:0 endAngle:M_PI clockwise:YES];
//    [arrPath addLineToPoint:CGPointMake(midx - ar, maxy - ar )];
    [arrPath addLineToPoint:CGPointMake(midx - r * sin(arrowAngle), midy + r * cos(arrowAngle))];
    [arrPath closePath];
    
    [UIColorHex(#1475FF) setFill];
    [arrPath fill];
  
    // 恢复图形上下文状态
    CGContextRestoreGState(context);
   
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(midx, midy) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    circle.lineWidth = lineW;
    [UIColorHex(#1475FF) setStroke];
    [circle stroke];
    
}


@end



@implementation PetMAPointAnnotation



@end
