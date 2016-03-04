//
//  AddBankCardView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/5.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "AddBankCardView.h"

@implementation AddBankCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubViews]; // 创建子视图
    }
    return self;
}

#pragma mark 创建添加银行卡视图
- (void)createSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 添加银行卡
    self.bankCardView = [[UIView alloc] initWithFrame:self.bounds];
    _bankCardView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bankCardView];
    
    // 开户名
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 40)];
    label.text = @"开户名";
    label.font = [UIFont systemFontOfSize:12.0f];
    [_bankCardView addSubview:label];
    
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMinY(label.frame), SCREEN_WIDTH - 120, 40)];
    _name.placeholder = @"请输入账户名";
    _name.font = [UIFont systemFontOfSize:12.0f];
    [_bankCardView addSubview:_name];
    
    //分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame), SCREEN_WIDTH - 40, 1)];
    view.backgroundColor = [UIColor colorWithRed:55.0/256.0 green:55.0/256.0 blue:55.0/256.0 alpha:0.4];
    [_bankCardView addSubview:view];
    
    
    // 银行卡号
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(view.frame) + 10, 80, 40)];
    label2.text = @"银行卡号";
    label2.font = [UIFont systemFontOfSize:12.0f];
    [_bankCardView addSubview:label2];
    
    self.bankcardNumber = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMinY(label2.frame), SCREEN_WIDTH - 120, 40)];
    _bankcardNumber.placeholder = @"请输入银行卡号";
    
    
}

@end
