//
//  LS_button.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/9.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_button.h"

static inline float radians (double degrees){
    return degrees * M_PI / 180.0;
}

@interface LS_button ()

@property (strong, nonatomic) NSMutableArray *pointAr;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation LS_button

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _pointAr = [NSMutableArray array];
    
    // 六个扇形区域
    for (int i = 0; i < 6; i++) {
        
        CGPoint center = self.center;
        CGFloat radius = CGRectGetWidth(self.frame) / 2.0 + 10;
        
        CGFloat startAngle = radians(60.0 * i);
        CGFloat endAngle = startAngle + M_PI / 3.0;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        CGPoint point; // 边
        
        // 外弧线
        [bezierPath addArcWithCenter:center
                              radius:radius
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];
        
        point.x = center.x + radius * cos(endAngle); // 计算扇形边
        point.y = center.y + radius * sin(endAngle);
        
        [bezierPath addLineToPoint:point];
        
        // 内弧度
        [bezierPath addArcWithCenter:center
                              radius:radius * 0.4
                          startAngle:endAngle
                            endAngle:startAngle
                           clockwise:NO];
        
        point.x = center.x + radius * cos(startAngle);
        point.y = center.y + radius * sin(startAngle);
        
        [bezierPath addLineToPoint:point];
        [bezierPath closePath];
        
        [_pointAr addObject:bezierPath];
        
    }
    
    // 添加白色掩盖物
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.fillColor = [UIColor colorWithRed:1.0
                                      green:1.0
                                       blue:1.0
                                      alpha:0.2].CGColor;
    shape.frame = self.bounds;
    
    UIBezierPath *path = [_pointAr objectAtIndex:2];
    shape.path = path.CGPath;
    
    _shapeLayer = shape;
    
    [self.layer addSublayer:_shapeLayer];
    
    
    // 提示框
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) * 0.4, CGRectGetWidth(self.frame) * 0.4)];
    _label.center = self.center;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_label];
}

//覆盖方法，点击时判断点是否在path内，YES则响应，NO则不响应
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    BOOL res = [super pointInside:point withEvent:event];
    
    if (res) {
        
        for (UIBezierPath *obje in _pointAr) {
            
            if ([obje containsPoint:point]) {
                
                NSInteger index = [_pointAr indexOfObject:obje];
                if (index == 0) {
                    index = 5;
                } else {
                    index = index - 1;
                }
                [_delegate selectButtonAction:self selectIndex:index];
                
                _shapeLayer.path = obje.CGPath;
                
                return YES;
            }
        }
        return NO;
    }
    return NO;
}

@end
