//
//  FuelGasViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "FuelGasViewController.h"
#import "HeatingView.h"


@interface FuelGasViewController ()

@property (nonatomic, strong) HeatingView *fuelGasV;

@end

@implementation FuelGasViewController

- (void)loadView
{
    self.fuelGasV = [[HeatingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _fuelGasV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"燃气缴费";
    [self initializeTheSet]; // 初始化设置
    [self addPayEvent]; // 添加支付事件
}

// 初始化设置
- (void)initializeTheSet
{
    _fuelGasV.iocImage.image = [UIImage imageNamed:@"meiqi_iOC.png"];
    _fuelGasV.pulldownMenusV.textField.text = @"北京市燃气XXXXX有限公司";
    _fuelGasV.pulldownMenusV.tableArray = @[@"北京市燃气XXXXX有限公司", @"北京市燃气XXXXX有限公司", @"北京市燃气XXXXX有限公司", @"北京市燃气XXXXX有限公司", @"北京市燃气XXXXX有限公司"];
}

#pragma mark 添加缴费按钮事件
- (void)addPayEvent
{
    [_fuelGasV.payBUtton addTarget:self action:@selector(clickPayEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickPayEvent:(UIButton *)sender
{
    [_fuelGasV createConfirmView];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [_fuelGasV.confirmView viewWithTag:i + 12500];
        [button addTarget:self action:@selector(clickWhetherOrNotPay:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 点击是否缴费
- (void)clickWhetherOrNotPay:(UIButton *)sender
{
    switch (sender.tag) {
        case 12500:
            [_fuelGasV createCompleteView];
#warning mark 假数据
            _fuelGasV.nameLabel.text = @"白娘子";
            _fuelGasV.accountLabel.text = @"1234567890";
            _fuelGasV.accountBalanceLabel.text = @"235.00";
            _fuelGasV.boLongBalanceLabel.text = @"300.02";
            [_fuelGasV.confirmView removeFromSuperview];
            
            break;
        case 12501:
            [_fuelGasV.confirmView removeFromSuperview];
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
