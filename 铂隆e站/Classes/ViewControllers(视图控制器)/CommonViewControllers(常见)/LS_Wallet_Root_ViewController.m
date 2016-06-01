//
//  LS_Wallet_Root_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/25.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Wallet_Root_ViewController.h"

#import "PayTableViewController.h"
#import "ConvenientViewController.h"
#import "FoodViewController.h"
#import "LS_Other_Sign_ViewController.h"
#import "LS_Mall_ViewController.h"
#import "LS_topUpBLB_ViewController.h"

@interface LS_Wallet_Root_ViewController ()

// 剩余铂隆币
@property (weak, nonatomic) IBOutlet UILabel *dough;

// 设置铂隆币距离上边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceTop;

@end

@implementation LS_Wallet_Root_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
    self.navigationController.navigationBar.translucent = NO;
    
    [self createrItem];
    [self adapter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTheLatestBalance];
}

#pragma mark - 获取最新余额
- (void)getTheLatestBalance
{
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    __weak LS_Wallet_Root_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] wallet_obtainMoneyUserID:userInfo.user_id returns:^(NSString *money) {
        LS_Wallet_Root_ViewController *strong_control = weak_control;
        if (strong_control) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程更新余额
                strong_control.dough.text = money;
            });
            
        }
    }];
}

#pragma mark - 适配
- (void)adapter
{
    _distanceTop.constant = SCREEN_HEIGHT * 0.12;
}

#pragma mark - 添加返回按钮
- (void)createrItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(cancelItemAction:)];
    self.navigationItem.leftBarButtonItem = item;
}

// item监听事件
- (void)cancelItemAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 物业服务
- (IBAction)service:(UIButton *)sender {
    PayTableViewController *pay = [[PayTableViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark - 铂隆商城
- (IBAction)boLongMall:(UIButton *)sender {
    LS_Mall_ViewController *mall = [[LS_Mall_ViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:mall];
    
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - 购物车
- (IBAction)shoppingCart:(UIButton *)sender {
}

#pragma mark - 消费清单
- (IBAction)consumerList:(UIButton *)sender {
}

#pragma mark - 附近商店
- (IBAction)nearTheShop:(UIButton *)sender {
    ConvenientViewController *control = [[ConvenientViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 附近小吃
- (IBAction)nearTheSnack:(UIButton *)sender {
    FoodViewController *control = [[FoodViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 每日签到
- (IBAction)dailyCheck:(UIButton *)sender {
    LS_Other_Sign_ViewController *control = [[LS_Other_Sign_ViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 充值
- (IBAction)topUp:(UIButton *)sender {
    LS_topUpBLB_ViewController *topUp = [[LS_topUpBLB_ViewController alloc] init];
    [self.navigationController pushViewController:topUp animated:YES];
}

@end
