//
//  LonginViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/3.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "LonginViewController.h"
#import "LonginView.h"
#import "RegisteredViewController.h"
#import "RetrievePasswordViewController.h"
@interface LonginViewController ()

@property (nonatomic, strong) LonginView *longView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView; // 菊花
@property (nonatomic, strong) UIView *backgView; // 菊花背景

@end

@implementation LonginViewController

- (void)loadView
{
    // 创建自定义View
    self.longView = [[LonginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _longView; // 替换自带的View
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    self.navigationController.navigationBar.translucent = NO;
    
    [self addAction]; // 事件关联
}

#pragma mark - 视图将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 本地有存储的话自动输入账号信息
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"account"];
    
    if (dict) {
        _longView.userNameText.text = [dict objectForKey:@"account"];
        _longView.passwordText.text = [dict objectForKey:@"pawd"];
    }
}

#pragma mark - 添加按钮事件
- (void)addAction
{
    // 登陆按钮
    [_longView.longBut addTarget:self action:@selector(longinAction:) forControlEvents:UIControlEventTouchUpInside];
    // 注册按钮
    [_longView.registeredBut addTarget:self action:@selector(registeredAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma Mark - 登陆
- (void)longinAction:(UIButton *)but
{
    [_longView.userNameText resignFirstResponder];
    [_longView.passwordText resignFirstResponder];
    
    NSString *userName =  _longView.userNameText.text;
    NSString *pawdName = _longView.passwordText.text;
    
    if ([userName isEqualToString:@""] || [pawdName isEqualToString:@""]) {
        [self alertControlWithTitle:@"请输入账号密码" action:nil];
        return;
    }
    
    __weak LonginViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] longinAccount:userName password:pawdName returns:^(NSDictionary *isLongin) {
        LonginViewController *strong_control = weak_control;
        if (strong_control) {
            
            NSInteger index = [[isLongin objectForKey:@"code"] integerValue];
            
            if (index == 0) {
                
                NSDictionary *dict = [isLongin objectForKey:@"datas"];
                UserInformation *infor = [[UserInformation alloc] init];
                [infor setValuesForKeysWithDictionary:dict];
                // 用户信息存储到本地
                [[LocalStoreManage sharInstance] UserInforStoredLocally:infor];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"status"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 记录登陆成功的账号
                NSDictionary *userDic = @{
                                          @"account":userName,
                                          @"pawd":pawdName
                                          };
                // 账号密码存储到 userDefaults
                [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"account"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [strong_control successPushRootViewControl]; // 登陆成功跳转主界面
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertAction *retrievePassword = [UIAlertAction actionWithTitle:@"找回密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        RetrievePasswordViewController *retrievePas = [[RetrievePasswordViewController alloc] init];
                        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:retrievePas];
                        [strong_control presentViewController:navigation animated:YES completion:nil];
                    }];
                    
                    [strong_control alertControlWithTitle:[isLongin objectForKey:@"datas"] action:retrievePassword];
                    
                });
            }
        }
    }];
}

#pragma mark - 注册
- (void)registeredAction:(UIButton *)but
{
    RegisteredViewController *registeredVC = [[RegisteredViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:registeredVC];
    
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登陆成功显示主界面
- (void)successPushRootViewControl
{
    
    [_activityIndicatorView stopAnimating]; // 停止旋转
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 根据用户token 登陆IM服务器
    [self connectionIMSDKServer];
}

// 菊花
- (void)activityIndicatorViews
{
    self.backgView = [[UIView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH * 0.5 - 100, SCREEN_HEIGHT * 0.5 - 80, 200, 160)];
    _backgView.backgroundColor = [UIColor whiteColor];
    _backgView.layer.masksToBounds = YES;
    _backgView.layer.cornerRadius = 10.0;
    _backgView.layer.borderWidth = 3.0;
    _backgView.layer.borderColor = [UIColor purpleColor].CGColor;
    [self.view addSubview:_backgView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正在登陆";
    [_backgView addSubview:label];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = CGPointMake( 100, 100); // 菊花只能设置中心，不能设置大小
    _activityIndicatorView.color = [UIColor orangeColor];
    [_backgView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
}

#pragma mark - 获得IM token后连接SDK服务器
- (void)connectionIMSDKServer
{
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    [[NetWorkRequestManage sharInstance] obtainIMToken:userInfo returns:^(NSString *token) {
        
        // 获得 token 后 连接融云IM SDK 服务器
        [[RCIM sharedRCIM] connectWithToken:token
                                    success:^(NSString *userId) {
                                        
//                                        NSLog(@"登陆融云IM成功,当前登陆的用户ID: %@", userId);
                                        
                                    } error:^(RCConnectErrorCode status) {
                                        
                                    } tokenIncorrect:^{
                                        
                                        /**
                                         *  token过期或者不正确。
                                         *  如果设置了token有限期限并且token过期，请重新请求您的服务器获取新的token
                                         *  如果没有设置token有效期却提示token错误，请检查您的客户端和服务端的appkey是否匹配，还有检查您获取token的流程。
                                         */
                                    }];
    }];
    
}

#pragma mark - alertControl
- (void)alertControlWithTitle:(NSString *)title action:(UIAlertAction *)retrievePassword {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    if (retrievePassword) {
        [alert addAction:retrievePassword];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
