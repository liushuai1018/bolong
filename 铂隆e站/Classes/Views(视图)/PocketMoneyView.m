//
//  PocketMoneyView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/29.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "PocketMoneyView.h"

@implementation PocketMoneyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView];
    }
    return self;
}

#pragma mark 创建所有子视图
- (void)createAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 图片
    CGFloat indexX = SCREEN_WIDTH / 3.0;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(indexX + 1, 60, indexX, indexX)];
    imageV.image = [UIImage imageNamed:@"bolongbi.png"];
    [self addSubview:imageV];
    
    // 提示
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(indexX + 1, CGRectGetMaxY(imageV.frame), indexX, 20)];
    label.text = @"我的铂隆币";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label];
    
    // 剩余零花钱
    self.pocketMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), SCREEN_WIDTH, 25)];
    _pocketMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _pocketMoneyLabel.font = [UIFont systemFontOfSize:17.0f];
    [self addSubview:_pocketMoneyLabel];
    
    
    // 去购物
    self.shoppingBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingBut.frame = CGRectMake(indexX - 20, CGRectGetMaxY(_pocketMoneyLabel.frame) + 50, indexX + 40, 35);
    [_shoppingBut setBackgroundImage:[UIImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
    [_shoppingBut setTitle:@"去Shopping" forState:UIControlStateNormal];
    [_shoppingBut.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_shoppingBut setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    _shoppingBut.tag = 11100;
    [self addSubview:_shoppingBut];
    
    // 缴纳
    self.payBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBut.frame = CGRectMake(CGRectGetMinX(_shoppingBut.frame), CGRectGetMaxY(_shoppingBut.frame) + 10, CGRectGetWidth(_shoppingBut.frame), 35);
    [_payBut setBackgroundImage:[UIImage imageNamed:@"kuang-2.png"] forState:UIControlStateNormal];
    [_payBut setTitle:@"缴纳" forState:UIControlStateNormal];
    [_payBut.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_payBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _payBut.tag = 11101;
    [self addSubview:_payBut];
    
    
}

@end
