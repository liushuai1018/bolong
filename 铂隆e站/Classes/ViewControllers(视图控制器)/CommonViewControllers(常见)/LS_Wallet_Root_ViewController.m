//
//  LS_Wallet_Root_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/25.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Wallet_Root_ViewController.h"

@interface LS_Wallet_Root_ViewController ()

// 设置铂隆币距离上边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceTop;

// 背景
@property (weak, nonatomic) IBOutlet UIImageView *bg;

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

#pragma mark - 适配
- (void)adapter
{
    
    NSLog(@"height = %.f \n width = %.f", SCREEN_HEIGHT, SCREEN_WIDTH);
    
    NSLog(@"view_height = %.f \n view_width = %.f", CGRectGetHeight(_bg.frame), CGRectGetWidth(_bg.frame));
    
    _distanceTop.constant = SCREEN_HEIGHT * 0.16;
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

@end
