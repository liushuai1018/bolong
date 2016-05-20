//
//  LS_topUpBLB_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_topUpBLB_ViewController.h"
#import "LS_TopUpBLB_View.h"

@interface LS_topUpBLB_ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) LS_TopUpBLB_View *topUpView;

// 记录当前选择的金额
@property (assign , nonatomic) NSInteger index;

@end

@implementation LS_topUpBLB_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"充值";
    
    [self createrSubView];
}

#pragma mark - 创建子视图
- (void)createrSubView
{
    self.topUpView = [[LS_TopUpBLB_View alloc] initWithFrame:self.view.bounds];
    self.view = _topUpView;
    
    _topUpView.textField.delegate = self;
    
    _topUpView.block = ^(NSInteger index){
        _index = index;
    };
    
    [_topUpView.purchase addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 购买按钮
- (void)purchase:(UIButton *)sender
{
    NSString *title;
    if (_index == 4) {
        title = [NSString stringWithFormat:@"%@¥", _topUpView.textField.text];
    } else {
        title = _topUpView.show.text;
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:title
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, -SCREEN_HEIGHT * 0.2, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    
    return YES;
}

@end
