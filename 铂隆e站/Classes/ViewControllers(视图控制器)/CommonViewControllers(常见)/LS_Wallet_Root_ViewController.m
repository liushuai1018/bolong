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
// 铂隆币余额
@property (weak, nonatomic) IBOutlet UILabel *bolongbi;

// 设置铂隆币距离上边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qianbao_yue_widht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qianbao_yue_height;


// 小logo
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_top;
@end

@implementation LS_Wallet_Root_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
    self.navigationController.navigationBar.translucent = NO;
    
    [self createrItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self adapter];
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    _dough.text = userInfo.money;
}

- (void)adapter
{
    NSString *equipmentModel = [[LS_EquipmentModel sharedEquipmentModel] accessModel];
    if ([equipmentModel isEqualToString:@"3.5_inch"]) {
        _distanceTop.constant = SCREEN_HEIGHT * 0.1; // 剩余铂隆币距离上边的距离
        _dough.font = [UIFont systemFontOfSize:25];  // 设置字体
        _bolongbi.font = [UIFont systemFontOfSize:15]; // 设置字体
        _qianbao_yue_height.constant =  -(CGRectGetHeight(self.view.frame) * 0.05);
        _qianbao_yue_widht.constant = -(CGRectGetWidth(self.view.frame) * 0.1);
        return;
    }
    if ([equipmentModel isEqualToString:@"4_inch"]) {
        _distanceTop.constant = SCREEN_HEIGHT * 0.14; // 剩余铂隆币距离上边的距离
        _dough.font = [UIFont systemFontOfSize:28];  // 设置字体
        _bolongbi.font = [UIFont systemFontOfSize:18]; // 设置字体
        return;
    }
    if ([equipmentModel isEqualToString:@"4.7_inch"]) {
        _distanceTop.constant = SCREEN_HEIGHT * 0.16; // 剩余铂隆币距离上边的距离
        return;
    }
    if ([equipmentModel isEqualToString:@"5.5_inch"]) {
        _logo_top.constant = 100;
        _distanceTop.constant = SCREEN_HEIGHT * 0.16; // 剩余铂隆币距离上边的距离
        return;
    }
    
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
    /*
    LS_Mall_ViewController *mall = [[LS_Mall_ViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:mall];
    
    [self presentViewController:navigation animated:YES completion:nil];
     */
    [self alertControlTitle:@"攻城狮正在努力开发中..."];
}
#warning mark - 隐藏购物车,消费清单, 在 XIB 中
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

#pragma mark - alertControl
- (void)alertControlTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
