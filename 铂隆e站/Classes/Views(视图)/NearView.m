//
//  NearView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/10.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "NearView.h"

#define kLineWidth 10
@implementation NearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView]; // 创建所有子视图
    }
    return self;
}

// 创造所有子视图
- (void)createAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(50, 30, SCREEN_WIDTH - 100, SCREEN_WIDTH - 100)];
//    _backgroundView.backgroundColor = [UIColor redColor];
    [self addSubview:_backgroundView];
    
    // 创建背景蒙版
    CAShapeLayer *trackLayer = [CAShapeLayer new];
    [_backgroundView.layer addSublayer:trackLayer];
    trackLayer.fillColor = nil; // 背景填充的颜色
    trackLayer.frame = _backgroundView.bounds; // 背景蒙版的大小
    trackLayer.lineWidth = kLineWidth; // 边的宽度
    trackLayer.strokeColor = [UIColor yellowColor].CGColor; //边的颜色
    
    // 创建背景蒙版的路径
    /*
     center:弧线中心点的坐标
     radius:弧线所在圆的半径
     startAngle:弧线开始的角度值
     endAngle:弧线结束的角度值
     clockwise:是否顺时针画弧线
     */
    CGFloat radius = CGRectGetWidth(_backgroundView.frame) * 0.5 - kLineWidth;
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(_backgroundView.frame) * 0.5, CGRectGetHeight(_backgroundView.frame) * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    trackLayer.path = trackPath.CGPath;
    
    // 创建掩盖蒙版
    self.progressLayer = [CAShapeLayer new];
    [_backgroundView.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = nil;
    _progressLayer.frame = _backgroundView.bounds;
    _progressLayer.lineWidth = kLineWidth;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeColor = [UIColor orangeColor].CGColor;
    
    
    // 表示数字
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 15, CGRectGetMinY(_backgroundView.frame) - 21, 30, 21)];
    label1.text = @"0";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor lightGrayColor];
    label1.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_backgroundView.frame) - 30, _backgroundView.center.y - 10, 30, 21)];
    label2.text = @"50";
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = [UIColor lightGrayColor];
    label2.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label2];
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 15, CGRectGetMaxY(_backgroundView.frame), 30, 21)];
    label3.text = @"100";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor lightGrayColor];
    label3.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label3];
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backgroundView.frame), _backgroundView.center.y - 10, 30, 21)];
    label4.text = @"150";
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = [UIColor lightGrayColor];
    label4.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label4];
    
    
    // 剩余车位数量
    self.remainingNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backgroundView.frame) / 3, CGRectGetHeight(_backgroundView.frame) / 3)];
    _remainingNum.center = CGPointMake(CGRectGetWidth(_backgroundView.frame) * 0.5, CGRectGetHeight(_backgroundView.frame) * 0.5);
    _remainingNum.font = [UIFont systemFontOfSize:55.0];
    _remainingNum.textAlignment = NSTextAlignmentCenter;
    [_backgroundView addSubview:_remainingNum];
#warning mark - 临时显示
    _remainingNum.text = @"47";
    
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_remainingNum.frame), CGRectGetMaxY(_remainingNum.frame) - 30, 25, 20)];
    label5.text = @"空位";
    label5.textColor = [UIColor lightGrayColor];
    label5.font = [UIFont systemFontOfSize:10.0];
    [_backgroundView addSubview:label5];
    
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_remainingNum.frame), CGRectGetMaxY(_remainingNum.frame), CGRectGetWidth(_remainingNum.frame), 20)];
    label6.text = @"剩余";
    label6.textColor = [UIColor lightGrayColor];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.font = [UIFont systemFontOfSize:15.0];
    [_backgroundView addSubview:label6];
    
    
    // 分割线
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label3.frame) + 10, SCREEN_WIDTH - 20, 2)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame) + 60, CGRectGetWidth(view1.frame), 2)];
    view2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 1, CGRectGetMaxY(view1.frame) + 3, 2, CGRectGetMinY(view2.frame) - CGRectGetMaxY(view1.frame) - 6)];
    view3.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view3];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame), SCREEN_WIDTH * 0.5 - 11, 30)];
    label7.text = @"所在位置";
    label7.textAlignment = NSTextAlignmentCenter;
    label7.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:label7];
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view3.frame), CGRectGetMaxY(view1.frame), CGRectGetWidth(label7.frame), 30)];
    label8.text = @"所在位置";
    label8.textAlignment = NSTextAlignmentCenter;
    label8.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:label8];
    
    // 所在路
    self.roadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label7.frame), CGRectGetWidth(label7.frame), 30)];
    _roadLabel.text = @"上园路南口";
    _roadLabel.textColor = [UIColor lightGrayColor];
    _roadLabel.textAlignment = NSTextAlignmentCenter;
    _roadLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_roadLabel];
    
    // 所在街
    self.streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label8.frame), CGRectGetMaxY(label8.frame), CGRectGetWidth(label7.frame), 30)];
    _streetLabel.text = @"新东房街";
    _streetLabel.textAlignment = NSTextAlignmentCenter;
    _streetLabel.textColor = [UIColor lightGrayColor];
    _streetLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_streetLabel];
    
    
    // 抢走一个
    self.addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _addButton.frame = CGRectMake(SCREEN_WIDTH * 0.3, CGRectGetMaxY(view2.frame) + 20, SCREEN_WIDTH * 0.4, 30);
    [_addButton setTitle:@"抢走一个" forState:UIControlStateNormal];
    [_addButton setTintColor:[UIColor lightGrayColor]];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"qiangyige.png"] forState:UIControlStateNormal];
    [self addSubview:_addButton];
    
    // 我走了
    self.reduceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _reduceButton.frame = CGRectMake(CGRectGetMinX(_addButton.frame), CGRectGetMaxY(_addButton.frame) + 20, CGRectGetWidth(_addButton.frame), CGRectGetHeight(_addButton.frame));
    [_reduceButton setTitle:@"我走喽!" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"wozoulou"] forState:UIControlStateNormal];
    [self addSubview:_reduceButton];
    
    
}

- (void)setProgress
{
    // 计算掩盖蒙版的路径
    CGFloat radius = CGRectGetWidth(_backgroundView.frame) * 0.5 - kLineWidth;
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(_backgroundView.frame) * 0.5, CGRectGetHeight(_backgroundView.frame) * 0.5) radius:radius startAngle:-M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:NO];
    _progressLayer.path = progressPath.CGPath;
}

// 以停车所占比例数据
- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setProgress];
}



@end
