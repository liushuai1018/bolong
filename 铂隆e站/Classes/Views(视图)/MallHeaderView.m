//
//  MallHeaderView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "MallHeaderView.h"

@implementation MallHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView]; // 创建所有子视图
    }
    return self;
}

- (void)createAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 商城图
    self.imageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), SCREEN_HEIGHT * 0.2)];
    [self addSubview:_imageVeiw];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageVeiw.frame), SCREEN_WIDTH, 3)];
    view.backgroundColor = [UIColor colorWithRed:205.0/256.0 green:205.0/256.0 blue:205.0/256.0 alpha:1.0];
    [self addSubview:view];
    
    CGFloat y = CGRectGetMaxY(_imageVeiw.frame) + 15;
    CGFloat width = SCREEN_WIDTH / 9.0;
    
    int inddx = 0;
    
    // button
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 4; j++) {
            
            // button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width * j * 2 + width, y + (width + 18) * i, width, width);
            button.tag = 12400 + inddx;
            [self addSubview:button];
            
            // label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame), CGRectGetWidth(button.frame), 15)];
            label.font = [UIFont systemFontOfSize:8.0f];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 12410 + inddx;
            [self addSubview:label];
            
            inddx++;
            
        }
    }
}

@end
