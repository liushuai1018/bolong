//
//  LS_TopUpBLB_View.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^kBlock)(NSInteger index);

@interface LS_TopUpBLB_View : UIView

// 余额
@property (strong, nonatomic) UILabel *balance;

// 金额
@property (strong, nonatomic) UITextField *money;

// 显示
@property (strong, nonatomic) UILabel *show;

// 输入金额
@property (strong, nonatomic) UITextField *textField;

// 购买
@property (strong, nonatomic) UIButton *purchase;

// 轮盘选中的金额
@property (copy, nonatomic) kBlock block;

@end
