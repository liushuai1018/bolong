//
//  HelpOperationViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "HelpOperationViewController.h"
#import "LS_HelpOper_Image_ViewController.h"

@interface HelpOperationViewController ()

@end

@implementation HelpOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"操作指南";
    self.navigationController.navigationBar.translucent = NO;
    
    [self addBarButton]; // 添加左边BarButton
}

#pragma mark - 如何缴纳物业费
- (IBAction)wuYe:(UIButton *)sender {
    LS_HelpOper_Image_ViewController *control = [[LS_HelpOper_Image_ViewController alloc] init];
    control.title = @"物业缴费";
    control.images = [UIImage imageNamed:@"LS_Help_wuye.jpg"];
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 铂隆币获取
- (IBAction)boLongBi:(UIButton *)sender {
    LS_HelpOper_Image_ViewController *control = [[LS_HelpOper_Image_ViewController alloc] init];
    control.title = @"获取铂隆币";
    control.images = [UIImage imageNamed:@"LS_Help_BoLongBi.jpg"];
    [self.navigationController pushViewController:control animated:YES];
}


#pragma mark BarButton
- (void)addBarButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)clickBarButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
