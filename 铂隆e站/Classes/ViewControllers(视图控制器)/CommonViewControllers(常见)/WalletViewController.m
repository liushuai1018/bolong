//
//  WalletViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/25.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletView.h"
#import "PocketMoneyViewController.h"
#import "PhoneViewController.h"
#import "WaterAndElectricityViewController.h"
#import "BankCardTableViewController.h"
#import "PropertyViewController.h"
#import "GasStationViewController.h"
#import "FoodViewController.h"
#import "ConvenientViewController.h"

@interface WalletViewController ()
{
    NSString *_remaining; // 记录剩余零花钱
    NSString *_numberBanCard; // 绑定几张银行卡
    
    // 零花钱
    PocketMoneyViewController *_pocketMoneyVC;
    // 手机充值
    PhoneViewController *_phoneVC;
    // 水电缴费
    WaterAndElectricityViewController *_waterVC;
    // 绑定银行卡
    BankCardTableViewController *_bankCardTVC;
    // 物业缴费
    PropertyViewController *_propertyVC;
    // 加油站
    GasStationViewController *_gasStationVC;
    // 美食
    FoodViewController *_foodVC;
    // 便利店
    ConvenientViewController *_convenientVC;
}
@property (nonatomic, strong) WalletView *walletView; // 钱包视图类

@end

@implementation WalletViewController

- (void)loadView
{
    self.walletView = [[WalletView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _walletView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO; // navigation 不透明
    self.title = @"钱包";
#warning 剩余多少钱 几张银行卡
    _remaining = @"500.00";
    _numberBanCard = @"2";
    _walletView.pocketMoneyLabel.text = _remaining;
    _walletView.bankCardLabel.text = _numberBanCard;
    
    // 添加左 barButtonItem
    [self addLeftBut];
    
    // 添加按钮事件
    [self addDidAction];
}

- (void)addLeftBut
{
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didCilckLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftBut;
}

- (void)didCilckLeftAction:(UIBarButtonItem *)but
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma 添加点击事件
- (void)addDidAction
{
    
    // 根据tag 值获取页面上所有 button
    for (int i = 11000; i < 11009; i++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:i];
        [but addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

- (void)didClickButton:(UIButton *)but
{
    NSInteger index = but.tag;
    switch (index) {
            
        case 11000: {
            _pocketMoneyVC = [[PocketMoneyViewController alloc] init];
            _pocketMoneyVC.remaining = _remaining;
            [self.navigationController pushViewController:_pocketMoneyVC animated:YES];
            NSLog(@"剩余零钱 500 元");
            break;
        }
            
        case 11001: {
//            _bankCardTVC = [[BankCardTableViewController alloc] init];
//            [self.navigationController pushViewController:_bankCardTVC animated:YES];
//            NSLog(@"添加银行卡");
            break;
        }
            
        case 11002: {
            _phoneVC = [[PhoneViewController alloc] init];
            _phoneVC.remaining = _remaining;
            [self.navigationController pushViewController:_phoneVC animated:YES];
            NSLog(@"手机充值");
            break;
        }
            
        case 11003: {
            _propertyVC = [[PropertyViewController alloc] init];
            [self.navigationController pushViewController:_propertyVC animated:YES];
            NSLog(@"物业缴费");
            break;
        }
            
        case 11004: {
            _waterVC = [[WaterAndElectricityViewController alloc] init];
            [self.navigationController pushViewController:_waterVC animated:YES];
            NSLog(@"水电缴费");
            break;
        }
            
        case 11005: {
            NSLog(@"购物车");
            break;
        }
            
        case 11006: {
            _gasStationVC = [[GasStationViewController alloc] init];
            [self.navigationController pushViewController:_gasStationVC animated:YES];
            NSLog(@"加油站");
            break;
        }
            
        case 11007: {
            _convenientVC = [[ConvenientViewController alloc] init];
            [self.navigationController pushViewController:_convenientVC animated:YES];
            NSLog(@"便利店");
            break;
        }
            
        case 11008: {
            _foodVC = [[FoodViewController alloc] init];
            [self.navigationController pushViewController:_foodVC animated:YES];
            NSLog(@"美食");
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
