//
//  RetrievePasswordViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/4.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "RetrievePasswordView.h"
#import "PasswordView.h"

@interface RetrievePasswordViewController ()

@property (nonatomic, strong) RetrievePasswordView *passwordView;
@property (nonatomic, strong) PasswordView *passwordView1;

@end

@implementation RetrievePasswordViewController

- (void)loadView
{
    self.passwordView = [[RetrievePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _passwordView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    self.navigationController.navigationBar.translucent = NO;
    [self addBarButtonItem];
    [self addAction];
}

#pragma mark - 添加左返回按钮
- (void)addBarButtonItem
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 添加事件
- (void)addAction
{
    [_passwordView.nextButton addTarget:self action:@selector(nextButtonActtion:) forControlEvents:UIControlEventTouchUpInside];
}

// 下一步
- (void)nextButtonActtion:(UIButton *)sender
{
    _passwordView1 = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [_passwordView1.doneButton addTarget:self action:@selector(clickDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = _passwordView1;
    
}

// 完成
- (void)clickDoneAction:(UIButton *)sender
{
    NSString *password1 = _passwordView1.password.text;
    NSString *password2 = _passwordView1.confirmPassword.text;
    
    if ([password1 isEqualToString:password2]) {
        
        NSString *phone = _passwordView.phone.text;
        NSString *code = _passwordView.verificationCode.text;
        
        [[NetWorkRequestManage sharInstance] forgetPasswordphone:phone
                                                        password:password1
                                                            code:code
                                                           retun:^(NSString *str)
        {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
           [alert show];
        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认密码有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
