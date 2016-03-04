//
//  FeedbckViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/14.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "FeedbckViewController.h"
#import "FeedbckView.h"
@interface FeedbckViewController ()

@property (nonatomic, strong) FeedbckView *feedbckView;

@end

@implementation FeedbckViewController

- (void)loadView
{
    self.feedbckView = [[FeedbckView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _feedbckView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"意见反馈";
    
    // 添加事件
    [_feedbckView.submitBtn addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加左边按钮
    [self addleftBarButton];
}

// 添加左边barButton
- (void)addleftBarButton
{
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

// 左边BarButton
- (void)didClickLeftAction:(UIBarButtonItem *)but
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#warning mark -- 提交
- (void)didClickAction:(UIButton *)but
{
    NSString *opinion = _feedbckView.opinionTF.text;
    NSString *unmber = _feedbckView.unmberTF.text;
    NSLog(@"意见: %@, 手机号: %@", opinion, unmber);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
