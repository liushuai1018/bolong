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
#import "MallTableViewController.h"

@interface LS_HomeViewController ()
{
    LS_pay_TableViewController *_pay;       // 缴费
    LS_ParkingRootViewController *_parking; // 停车
//    MallTableViewController *_mall;       // 商城
    LS_Mall_ViewController *_mall;          // 新商城
    
}

// 这个是商城
@property (weak, nonatomic) IBOutlet UIView *parking_View;
// 这个是停车
@property (weak, nonatomic) IBOutlet UIView *mall_View;

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;



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
    }
    
#warning mark - 隐藏为完成的下一版本在展开
    _parking_View.hidden = YES;
    _mall_View.hidden = YES;
    
    
    _width.constant = SCREEN_WIDTH * 0;
    
    NSString *equipmentModel = [[LS_EquipmentModel sharedEquipmentModel] accessModel];
    if ([equipmentModel isEqualToString:@"4_inch"]) {
        
        
        return;
    }
    if ([equipmentModel isEqualToString:@"4.7_inch"]) {
        
        _width.constant = SCREEN_WIDTH * 0.25;
        return;
    }
    if ([equipmentModel isEqualToString:@"5.5_inch"]) {
        
        _width.constant = SCREEN_WIDTH * 0.3;
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
    
    _parking = [[LS_ParkingRootViewController alloc] init];
    [self presentViewcontrol:@[_parking]];
}

#pragma mark - 商城
- (IBAction)mall:(UIButton *)sender {
    
    _mall = [[LS_Mall_ViewController alloc] init];
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

@end
