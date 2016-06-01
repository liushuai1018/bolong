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
    
    [self createrRightBarButton];
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
    
    [self getTheLatestBalance];
    [_topUpView.purchase addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 创建导航栏右边按钮
- (void)createrRightBarButton
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightDidAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - 右BarButton
- (void)rightDidAction:(UIBarButtonItem *)sender
{
    
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
    
    if ([title isEqualToString:@""]) {
        [self createrAlertViewTitle:@"请输入想充值的金额!"];
        return;
    }
    
    BOOL is = [title containsString:@"¥"];
    
    if (is) {
        title = [title substringToIndex:title.length - 1];
    }
    
    NSLog(@"title = %@", title);
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    __weak LS_topUpBLB_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] wallet_top_upMoneyUserID:userInfo.user_id RMB:title returns:^(NSDictionary *dic) {
        LS_topUpBLB_ViewController *strong_control = weak_control;
        if (strong_control) {
            
            NSInteger index = [[dic objectForKey:@"resultStatus"] integerValue];
            if (9000 == index) { // 判断缴费情况 resultStatus 值除了 9000 以外都是缴费失败
                
                [strong_control getTheLatestBalance];
                
                [strong_control createrAlertViewTitle:@"充值成功!"];
            } else {
                [strong_control createrAlertViewTitle:@"充值失败!"];
            }
        }
    }];
    
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

#pragma mark - alertView
- (void)createrAlertViewTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 获取最新余额
- (void)getTheLatestBalance
{
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    __weak LS_topUpBLB_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] wallet_obtainMoneyUserID:userInfo.user_id returns:^(NSString *money) {
        LS_topUpBLB_ViewController *strong_control = weak_control;
        if (strong_control) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程更新余额
                strong_control.topUpView.balance.text = [NSString stringWithFormat:@"余额: %@", money];
            });
            
        }
    }];
}

@end
