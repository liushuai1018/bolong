//
//  LS_HomeViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/14.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_HomeViewController.h"
#import "LS_pay_TableViewController.h"
#import "LS_ParkingRootViewController.h"
#import "MallTableViewController.h"

@interface LS_HomeViewController ()
{
    LS_pay_TableViewController *_pay;  // 缴费
    LS_ParkingRootViewController *_parking; // 停车
    MallTableViewController *_mall; // 商城
    
}

@end

@implementation LS_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"铂隆";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - 物业缴费
- (IBAction)wuyePay:(UIButton *)sender {
    
    _pay = [[LS_pay_TableViewController alloc] init];
    [self presentViewcontrol:@[_pay]];
}

#pragma mark - 停车
- (IBAction)parking:(UIButton *)sender {
    
    _parking = [[LS_ParkingRootViewController alloc] init];
    [self presentViewcontrol:@[_parking]];
}

#pragma mark - 商城
- (IBAction)mall:(UIButton *)sender {
    
    _mall = [[MallTableViewController alloc] init];
    [self presentViewcontrol:@[_mall]];
}

// 推出下一级视图控制器
- (void)presentViewcontrol:(NSArray *)array
{
    UINavigationController *navigationC;
    if (!navigationC) {
        
        navigationC = [[UINavigationController alloc] init];
    }
    
    [navigationC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; // 设置视图跳转样式
    [navigationC setViewControllers:array];
    [self presentViewController:navigationC animated:YES completion:nil];
}

@end
