//
//  ApplyForViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ApplyForViewController.h"

@interface ApplyForViewController ()

@end

@implementation ApplyForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请";
    self.navigationController.navigationBar.translucent = NO;
    [self addBar];
}

#pragma mark - addbar
- (void)addBar
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)clickRightAction:(UIBarButtonItem *)sender
{
    NSLog(@"等待验证");
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
