//
//  RegisteredViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "RegisteredViewController.h"
#import "RegisteredView.h"
@interface RegisteredViewController ()

@property (nonatomic, strong) RegisteredView *regisView; // 注册视图

@property (nonatomic, strong) NSTimer *timer; // 倒计时
@property (nonatomic, assign) NSInteger countdown; // 记录秒数

@property (nonatomic, strong) UIButton *sender; // 获取验证码按钮

@end

@implementation RegisteredViewController

- (void)loadView
{
    self.regisView = [[RegisteredView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _regisView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    [self addBarButtonItem]; // 添加navigaction 按钮
    
    
    __weak RegisteredViewController *registered = self;
    _regisView.block = ^(UIButton *sender) {
        [registered gettingCaptchaAction:sender];
    };
    
}



#pragma makr - 获取验证码事件
- (void)gettingCaptchaAction:(UIButton *)sender
{
    self.sender = sender;
    // 设置倒计秒数 60；
    _countdown = 60;
    sender.enabled = NO;
    // 创建并启动倒计时
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(onTimer)
                                            userInfo:nil
                                             repeats:YES];
    
    // 输入手机号
    NSString *phoneNumber = _regisView.phoneNumber.text;
    
    if ([phoneNumber isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入手机号"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        // 发送短信验证码
        __weak RegisteredViewController *registered = self;
        [[NetWorkRequestManage sharInstance] senderVerificationCode:phoneNumber
                                             returnVerificationCode:^(NSString *str) {
                                                 
                                                 [registered alertView:str];
                                                 
                                                 // 发送短信失败重新开启获取验证码
                                                 [_timer invalidate];
                                                 sender.enabled = YES;
                                                 [sender setTitle:@"验证码" forState:UIControlStateNormal];
                                                 
                                             }];
    }
    
}
// 倒计时方法
- (void)onTimer
{
    if (_countdown > 0) {
        [self.sender setTitle:[NSString stringWithFormat:@"%ld秒", (long)_countdown]
                     forState:UIControlStateNormal];
        _countdown--;
        
    } else {
        
        _countdown = 60;
        [_timer invalidate];
        [self.sender setTitle:@"验证码" forState:UIControlStateNormal];
        self.sender.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.sender.enabled = YES;
        
    }
}

#pragma mark - 添加 navigation Button
- (void)addBarButtonItem
{
    UIBarButtonItem *rightBI1 = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightBI:)];
    self.navigationItem.rightBarButtonItem = rightBI1;
    [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    
}

// 右边事件
- (void)didClickRightBI:(UIBarButtonItem *)but
{
    if (!_regisView.record) {
        [self alertView:@"请输入完整"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        return;
    }
    
    NSString *userName = _regisView.phoneNumber.text;
    NSString *pawdName = _regisView.password.text;
    NSString *captcha = _regisView.captcha.text;
    
    // 给服务器发送注册信息返回是否注册成功
    BOOL is = [[NetWorkRequestManage sharInstance] registeredAccount:userName
                                                                code:captcha
                                                            password:pawdName];
    
    // 根据是否注册成功判断提示用户
    if (is) {
        
        // 注册成功
        NSDictionary *userDic = @{
                                  @"account":userName,
                                  @"pawd":pawdName
                                  };
        // 账号密码存储到 userDefaults
        [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"account"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        // 注册成功退出当前视图控制器，下一步执行
        if (self.block) {
            self.block();
        }
        
    } else {
        
        // 注册失败
        [self alertView:@"注册失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertView 提示框
- (void)alertView:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
