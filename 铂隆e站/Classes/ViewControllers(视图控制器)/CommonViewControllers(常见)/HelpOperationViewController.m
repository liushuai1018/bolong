//
//  HelpOperationViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "HelpOperationViewController.h"

@interface HelpOperationViewController ()

@end

@implementation HelpOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"操作指南";
    self.navigationController.navigationBar.translucent = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    imageView.image = [UIImage imageNamed:@"zhinan.jpg"];
    [self.view addSubview:imageView];
    
    [self addBarButton]; // 添加左边BarButton
}

#pragma mark BarButton
- (void)addBarButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)clickBarButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
