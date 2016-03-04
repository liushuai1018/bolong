//
//  PropertyViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PropertyViewController.h"
#import "PropertyView.h"

@interface PropertyViewController ()

// 物业缴费视图
@property (nonatomic, strong) PropertyView *propertyV;

@end

@implementation PropertyViewController

- (void)loadView
{
    self.propertyV = [[PropertyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _propertyV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物业缴费";
    
#warning mark 小区单元
    _propertyV.communltyPMV.tableArray = @[@"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区"];
    _propertyV.unitPMV.tableArray = @[@"一单元", @"二单元", @"三单元", @"四单元"];
    
    [self cilckButton]; // 添加按钮事件
}


- (void)cilckButton
{
    [_propertyV.payButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction:(UIButton *)sender
{
    NSLog(@"缴纳物业费用");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
