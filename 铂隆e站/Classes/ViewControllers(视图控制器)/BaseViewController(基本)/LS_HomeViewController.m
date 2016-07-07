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
#import "LS_Mall_ViewController.h"
#import "LS_temp_parking_ViewController.h"

@interface LS_HomeViewController ()
{
    LS_pay_TableViewController *_pay;       // 缴费
    LS_ParkingRootViewController *_parking; // 停车
    LS_temp_parking_ViewController *_tempParking; // 临时停车视图
//    MallTableViewController *_mall;       // 商城
    LS_Mall_ViewController *_mall;          // 新商城
    
}

// 这个是商城
@property (weak, nonatomic) IBOutlet UIView *parking_View;
// 这个是停车
@property (weak, nonatomic) IBOutlet UIView *mall_View;

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
// 停车or商城距离上的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parkOrMall_top;
// 右边视图距离右边
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mall_right;
// 左边视图距离左边
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parking_left;


@property (strong, nonatomic) UIButton *rewardImage; // 奖励图片
@property (assign, nonatomic) NSInteger countdown;   // 倒计时秒数
@property (strong, nonatomic) NSTimer *timer;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 判断是否是注册后第一次登陆
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstRegistration"]) {
        [self createrBoLongBiImage];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstRegistration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    NSString *equipmentModel = [[LS_EquipmentModel sharedEquipmentModel] accessModel];
    if ([equipmentModel isEqualToString:@"3.5_inch"]) {
        _width.constant = -20;
        _parkOrMall_top.constant = -30;
        _parking_left.constant = -104;
        _mall_right.constant = 104;
        return;
    }
    if ([equipmentModel isEqualToString:@"4_inch"]) {
        _width.constant = 0;
        return;
    }
    if ([equipmentModel isEqualToString:@"4.7_inch"]) {
        _width.constant = 0;
        return;
    }
    if ([equipmentModel isEqualToString:@"5.5_inch"]) {
        
        _width.constant = 0;
        return;
    }
    
    
}

#pragma makr - 物业缴费
- (IBAction)wuyePay:(UIButton *)sender {
    
    _pay = [[LS_pay_TableViewController alloc] init];
    [self presentViewcontrol:@[_pay]];
}

#pragma mark - 停车
- (IBAction)parking:(UIButton *)sender {
    /*
    _parking = [[LS_ParkingRootViewController alloc] init];
    [self presentViewcontrol:@[_parking]];
     */
    
    _tempParking = [[LS_temp_parking_ViewController alloc] init];
    [self presentViewcontrol:@[_tempParking]];
}

#pragma mark - 商城
- (IBAction)mall:(UIButton *)sender {
    /*
    _mall = [[LS_Mall_ViewController alloc] init];
    [self presentViewcontrol:@[_mall]];
     */
    [self alertControlTitle:@"攻城狮正在努力开发中..."];
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

#pragma mark - 创建奖励铂隆币图片
- (void)createrBoLongBiImage
{
    // 创建并启动倒计时
    _countdown = 3; // 三秒
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(onTimer)
                                            userInfo:nil
                                             repeats:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.rewardImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _rewardImage.frame = [UIScreen mainScreen].bounds;
    [_rewardImage setImage:[UIImage imageNamed:@"new_jiangli"] forState:UIControlStateNormal];
    [_rewardImage addTarget:self action:@selector(BoLongBiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rewardImage];
}

- (void)BoLongBiAction:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [sender removeFromSuperview];
}

- (void)onTimer
{
    if (_countdown > 0) {
        _countdown--;
        
    } else {
        _countdown = 3;
        [_timer invalidate];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.tabBarController.tabBar.hidden = NO;
        [_rewardImage removeFromSuperview];
    }
}

#pragma mark - alertControl
- (void)alertControlTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
