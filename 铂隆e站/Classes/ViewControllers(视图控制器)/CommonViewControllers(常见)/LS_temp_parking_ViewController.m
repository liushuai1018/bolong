//
//  LS_temp_parking_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/7/7.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_temp_parking_ViewController.h"

@interface LS_temp_parking_ViewController ()

@end

@implementation LS_temp_parking_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSet];
    [self replaceLeftBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSet
- (void)initSet
{
    self.title = @"停车";
    self.navigationController.navigationBar.translucent = NO;
    
}

#pragma mark - 设置 返回键
- (void)replaceLeftBarButton
{
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
}
// 自定义左边BarBUtton事件
- (void)didClickLeftAction:(UIBarButtonItem *)bar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tempParking:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1121530169?mt=8"]];
}


@end
