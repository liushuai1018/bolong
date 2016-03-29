//
//  WuYePayCostViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "WuYePayCostViewController.h"
#import "WuYePayCostView.h"

@interface WuYePayCostViewController ()

@property (strong, nonatomic) WuYePayCostView *wuyePayCostView;

@end

@implementation WuYePayCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self createrView];
    [self setBlock];
}

#pragma mark - 创建 SubView
- (void)createrView
{
    self.wuyePayCostView = [[WuYePayCostView alloc] initWithFrame:self.view.bounds];
    
    self.view = _wuyePayCostView;
}

#pragma mark - 设置block
- (void)setBlock
{
    _wuyePayCostView.block = ^(){
        
        NSLog(@"确认支付物业费");
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
