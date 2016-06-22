//
//  WuYePayCostView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "WuYePayCostView.h"

@implementation WuYePayCostView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createrAllSubView];
    }
    return self;
}

#pragma mark - 创建子视图
- (void)createrAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat X = 30;
    CGFloat interval = 20;
    CGFloat width = SCREEN_WIDTH - 60;
    CGFloat height = 25;
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(X, SCREEN_HEIGHT * 0.08, width, height)];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_name];
    
    self.number = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetMaxY(_name.frame) + interval, width, height)];
    _number.textAlignment= NSTextAlignmentCenter;
    _number.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_number];
    
    /*
    self.pulldownMenus = [[PulldownMenusView alloc] initWithFrame:CGRectMake(X, CGRectGetMaxY(_number.frame) + interval, width, height)];
    _pulldownMenus.textField.textAlignment = NSTextAlignmentCenter;
    _pulldownMenus.textField.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_pulldownMenus];
    */
    self.pulldownMenus = [UIButton buttonWithType:UIButtonTypeSystem];
    _pulldownMenus.frame = CGRectMake(X, CGRectGetMaxY(_number.frame) + interval, width, height);
    [_pulldownMenus setTitle:@"选择缴纳的房屋" forState:UIControlStateNormal];
    [self addSubview:_pulldownMenus];
    
    self.paymentDetails = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetMaxY(_pulldownMenus.frame) + interval, width, height)];
    _paymentDetails.textAlignment = NSTextAlignmentCenter;
    _paymentDetails.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_paymentDetails];
    
    self.totalFee = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetMaxY(_paymentDetails.frame) + 40, width, height)];
    _totalFee.textAlignment = NSTextAlignmentRight;
    _totalFee.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_totalFee];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 50, CGRectGetMaxY(_totalFee.frame) + 40, 100, 30);
    [_button setTitle:@"确定" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:0.98 green:0.42 blue:0.43 alpha:1.0] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(didAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
}

- (void)didAction:(UIButton *)sender
{
    if (self.block) {
        
        self.block();
    }
}

@end
