//
//  TheBindingViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "TheBindingViewController.h"
#import "TheBindingView.h"
@interface TheBindingViewController ()

@property (nonatomic, strong) TheBindingView *theBindingV;

@end

@implementation TheBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO; // navigation 不透明
    self.title = @"绑定手机";
    
    [self initSubView];
}

- (void)initSubView
{
    self.theBindingV = [[TheBindingView alloc] initWithFrame:self.view.frame];
    self.view = _theBindingV;
    
    [_theBindingV.next addTarget:self action:@selector(clickNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - 点击事件
// 验证
- (void)clickNextAction:(UIButton *)sender
{
    [_theBindingV createrCaptchaView]; // 创建验证码界面
    
    [_theBindingV.finished addTarget:self action:@selector(clickFinishedAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 完成
- (void)clickFinishedAction:(UIButton *)sender
{
    [_theBindingV createrSuccessView];  // 创建已绑定界面
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
