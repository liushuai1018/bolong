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
@interface LonginViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) LonginView *longView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView; // 菊花
@property (nonatomic, strong) UIView *backgView; // 菊花背景

// 奖励图片
@property (strong, nonatomic) UIButton *rewardImage;
// 倒计时
@property (assign, nonatomic) NSInteger countdown; // 倒计时秒数
@property (strong, nonatomic) NSTimer *timer;

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
    
    // 设置微信 AppId、appSecret、分享
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXSecret url:nil];
    // 设置QQ AppId、appSecret、分享
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQSecret url:QQURL];
    
    // 微博 SSO
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback_success_151218"];
    
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
    
    // 微信
    [_longView.weiXinBut addTarget:self action:@selector(didClickWeiXinAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // QQ
    [_longView.qqBut addTarget:self action:@selector(didClickQQAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 微博
    [_longView.weiBoBut addTarget:self action:@selector(didClickWeiBoAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma Mark - 登陆
- (void)longinAction:(UIButton *)but
{
    [_longView.userNameText resignFirstResponder];
    [_longView.passwordText resignFirstResponder];
    
    NSString *userName =  _longView.userNameText.text;
    NSString *pawdName = _longView.passwordText.text;
    
    BOOL is = [[NetWorkRequestManage sharInstance] longinAccount:userName password:pawdName];
    
    if (is) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"status"];
        
        // 记录登陆成功的账号
        NSDictionary *userDic = @{
                                  @"account":userName,
                                  @"pawd":pawdName
                                  };
        // 账号密码存储到 userDefaults
        [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"account"];
        
        [self successPushRootViewControl]; // 登陆成功跳转主界面
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"密码或账户错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"找回密码", nil];
        [alert show];
    }
    
}

#pragma mark - 注册
- (void)registeredAction:(UIButton *)but
{
    RegisteredViewController *registeredVC = [[RegisteredViewController alloc] init];
    
    __weak LonginViewController *control = self;
    registeredVC.block = ^(){
        
        // 注册成功后弹出奖励铂隆币图片
        [control createrBoLongBiImage];
    };
    [self.navigationController pushViewController:registeredVC animated:YES];
}

// 创建奖励铂隆币图片
- (void)createrBoLongBiImage
{
    // 创建并启动倒计时
    _countdown = 3; // 三秒
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(onTimer)
                                            userInfo:nil
                                             repeats:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.rewardImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _rewardImage.frame = [UIScreen mainScreen].bounds;
    [_rewardImage setImage:[UIImage imageNamed:@"new_jiangli"] forState:UIControlStateNormal];
    [_rewardImage addTarget:self action:@selector(BoLongBiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rewardImage];
}

- (void)BoLongBiAction:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [sender removeFromSuperview];
}

- (void)onTimer
{
    if (_countdown > 0) {
        _countdown--;
        
    } else {
        _countdown = 3;
        [_timer invalidate];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [_rewardImage removeFromSuperview];
    }
}

#pragma mark -- 获取微信的授权
- (void)didClickWeiXinAction:(UIButton *)but
{
    [self thirdPartyAuthorization:UMShareToWechatSession]; // 微信
}

#pragma mark -- 获取QQ授权
- (void)didClickQQAction:(UIButton *)but
{
    [self thirdPartyAuthorization:UMShareToQQ]; // QQ
}

#pragma mark -- 获取微博授权
- (void)didClickWeiBoAction:(UIButton *)but
{
    [self thirdPartyAuthorization:UMShareToSina]; // 微博
}


// 第三方授权
- (void)thirdPartyAuthorization:(NSString *)snsName
{
    
    // 创建 Sns 平台
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    /**
     *  处理点击登录事件后的block对象
     @param presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
     @param socialControllerService 可以用此对象的socialControllerService.socialData可以获取分享内嵌文字、内嵌图片，分享次数等
     @param isPresentInController 如果YES代表弹出(present)到当前UIViewController，否则push到UIViewController的navigationController
     @param completion 授权完成之后的回调对象，返回的response参数表示成功与否和拿到的授权信息
     */
    
    [self activityIndicatorViews]; 
    
    __weak LonginViewController *longinVC = self;
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
        
        // 判断是否授权成功
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            // 获取用户消息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsName];
            
            // 获取用户信息
            [[UMSocialDataService defaultDataService] requestSnsInformation:snsName completion:^(UMSocialResponseEntity *response) {
                
                NSLog(@"response :%@", response.data);
                
                // 记录登陆那个平台
                NSInteger index = 1;
                // 记录唯一ID
                NSInteger openID = 0;
                if ([snsName isEqualToString:UMShareToQQ]) {
                    index = 1;
                    openID = [[response.data objectForKey:@"openid"] integerValue];
                }
                if ([snsName isEqualToString:UMShareToWechatSession]) {
                    index = 2;
                }
                if ([snsName isEqualToString:UMShareToSina]) {
                    index = 3;
                    openID = [[response.data objectForKey:@"uid"] integerValue];
                }
                
                // 获取第三方信息绑定到服务器
                [[NetWorkRequestManage sharInstance] otherLoginOpenID:openID
                                                                 type:index
                                                            user_name:[response.data objectForKey:@"screen_name"]
                                                            user_avar:snsAccount.iconURL];
                
            }];
            
            // 登陆成功跳转主界面
            [longinVC successPushRootViewControl];
        } else {
            [_activityIndicatorView stopAnimating];
            [_backgView removeFromSuperview];
        }
        
    });
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
                                        
                                        NSLog(@"登陆融云IM成功,当前登陆的用户ID: %@", userId);
                                        
                                    } error:^(RCConnectErrorCode status) {
                                        
                                        NSLog(@"登陆的错误码为: %ld", (long)status);
                                        
                                    } tokenIncorrect:^{
                                        
                                        /**
                                         *  token过期或者不正确。
                                         *  如果设置了token有限期限并且token过期，请重新请求您的服务器获取新的token
                                         *  如果没有设置token有效期却提示token错误，请检查您的客户端和服务端的appkey是否匹配，还有检查您获取token的流程。
                                         */
                                        NSLog(@"token错误");
                                        
                                    }];
    }];
    
}

#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        RetrievePasswordViewController *retrievePas = [[RetrievePasswordViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:retrievePas];
        [self presentViewController:navigation animated:YES completion:nil];
    }
}

@end
