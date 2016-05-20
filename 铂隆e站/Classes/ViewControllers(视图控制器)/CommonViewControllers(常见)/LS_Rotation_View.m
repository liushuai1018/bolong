//
//  LS_Rotation_View.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Rotation_View.h"

@interface LS_Rotation_View ()

@property (strong, nonatomic) UIBezierPath *path;

@end

@implementation LS_Rotation_View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置可点击范围
        UIBezierPath *path = [[UIBezierPath alloc] init];
        // 获取中心点
        CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
        CGFloat radius = center.x;
        
        [path addArcWithCenter:center
                        radius:radius
                    startAngle:0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
        [path closePath];
        _path = path;
    }
    return self;
}

// 设置可点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL res = [super pointInside:point withEvent:event];
    if (res) {
        if ([_path containsPoint:point]) {
            return YES;
        }
        return NO;
    }
    return NO;
}
// 单手指旋转
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSInteger toucheNumber = [[event allTouches] count];
    
    if (toucheNumber > 1) {
        return;
    }
    
    // 获取中心点
    CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
    
    CGPoint previousPoint = [[touches anyObject] previousLocationInView:self];
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    
    CGFloat angle_old = atan2f(previousPoint.y - center.y, previousPoint.x - center.x);
    CGFloat angle_new = atan2f(currentPoint.y - center.y, currentPoint.x - center.x);
    CGFloat angle = angle_new - angle_old;
    
    
    self.transform = CGAffineTransformRotate(self.transform, angle);
    
    NSArray *subViews = [self subviews];
    
    for (UILabel *obje in subViews) { // 反向旋转所有子view
        
        obje.transform = CGAffineTransformRotate(obje.transform, -angle);
        
        
        CGRect rect = [obje convertRect:obje.bounds toView:self.superview];
        
        UIView *view = [self.superview viewWithTag:12359];
        
        // 判断view上所有子view是否与指定点重合
        BOOL is = CGRectContainsPoint(rect, CGPointMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame)));
        
        if (is) {
            obje.textColor = [UIColor colorWithRed:0.95 green:0.73 blue:0.24 alpha:1.0];
            if (self.block) {
                
                self.block(obje.tag);
            }
            
        } else {
            obje.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.76 alpha:1.0];
        }
    }
}

@end
