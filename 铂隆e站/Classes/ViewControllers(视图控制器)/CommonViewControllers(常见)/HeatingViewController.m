//
//  HeatingViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "HeatingViewController.h"
#import "HeatingView.h"
@interface HeatingViewController ()

@property (nonatomic, strong) HeatingView *heatV;

@end

@implementation HeatingViewController

- (void)loadView
{
    self.heatV = [[HeatingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _heatV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"暖气缴费";
    [self initializeTheSet]; // 初始化设置
    [self addPayEvent]; // 添加缴费按钮事件
}

// 初始化设置
- (void)initializeTheSet
{
    _heatV.iocImage.image = [UIImage imageNamed:@"nuanqi_iOC.png"];
    _heatV.pulldownMenusV.textField.text = @"北京市暖气XXXXX有限公司";
    _heatV.pulldownMenusV.tableArray = @[@"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司"];
}

#pragma mark 添加缴费按钮事件
- (void)addPayEvent
{
    [_heatV.payBUtton addTarget:self action:@selector(clickPayEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickPayEvent:(UIButton *)sender
{
    [_heatV createConfirmView];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [_heatV.confirmView viewWithTag:i + 12500];
        [button addTarget:self action:@selector(clickWhetherOrNotPay:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 点击是否缴费
- (void)clickWhetherOrNotPay:(UIButton *)sender
{
    
    
    switch (sender.tag) {
        case 12500:
            [_heatV createCompleteView];
#warning mark 假数据
            _heatV.nameLabel.text = @"白娘子";
            _heatV.accountLabel.text = @"1234567890";
            _heatV.accountBalanceLabel.text = @"235.00";
            _heatV.boLongBalanceLabel.text = @"300.02";
            [_heatV.confirmView removeFromSuperview];
            
            break;
        case 12501:
            [_heatV.confirmView removeFromSuperview];
            NSLog(@"取消缴纳暖气费用");
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
