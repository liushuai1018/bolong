//
//  PocketMoneyViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/29.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "PocketMoneyViewController.h"
#import "PocketMoneyView.h"

@interface PocketMoneyViewController ()

@end

@implementation PocketMoneyViewController

- (void)loadView
{
    self.pocketMoneyV = [[PocketMoneyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _pocketMoneyV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"零花钱";
#warning mark 剩余的零花钱
    NSString *str = [NSString stringWithFormat:@"＄%@", _remaining];
    _pocketMoneyV.pocketMoneyLabel.text = str;
    
    // 添加事件
    [self addAction];
}

// 按钮添加事件
- (void)addAction
{
    [_pocketMoneyV.shoppingBut addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pocketMoneyV.payBut addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickAction:(UIButton *)but
{
    switch (but.tag) {
        case 11100:
            NSLog(@"你点击了去 shopping");
            break;
        case 11101:
            NSLog(@"你点击了缴纳");
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
