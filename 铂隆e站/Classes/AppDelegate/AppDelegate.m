//
//  AppDelegate.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/26.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "AppDelegate.h"
#import "UserGuideViewController.h"  // 用户引导页
#import "LS_TabBarController.h"      // 新自定义导航栏
#import "LonginViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()
 
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 创建window窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self initializeUM];
    [self initiazeRong];
    [self connectionIMSDKServer:RC_IM_Temp_Token];
    
    // 判断是不是第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"]; // 第一次启动后设为YES
        
        //创建用户引导页
        UserGuideViewController *userGuide = [[UserGuideViewController alloc] init];
        self.window.rootViewController = userGuide;
        
        __weak AppDelegate *appD = self;
        userGuide.block = ^() {
            [appD firstpressed];// 跳转主界面
            // 第一次登陆自动弹出登陆界面
            [appD jumpLongViewController];
        };
        
    } else { // 不是第一次登陆
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"status"]) {  // 判断当前是否是登陆状态
            
            [self firstpressed]; // 跳转主界面
        } else { // 不是登陆状态弹出登陆界面
            
            [self firstpressed];
            [self jumpLongViewController];
        }
        
    }
    
    return YES;
}

#pragma mark - 初始化友盟key
- (void)initializeUM
{
    // 友盟AppKey
    [UMSocialData setAppKey:UMKey];
    
}

#pragma mark - 初始化融云key
- (void)initiazeRong
{
    // 初始化融云IM SDK
    [[RCIM sharedRCIM] initWithAppKey:RC_IM_Key];
    
}

#pragma mark 初始化自定义标签导航栏
- (void)firstpressed
{
    // 创建跟视图
//    CustomViewController *custom = [[CustomViewController alloc] init];
//    self.window.rootViewController = custom;
    LS_TabBarController *tabBar = [[LS_TabBarController alloc] init];
    self.window.rootViewController = tabBar;
    
}

#pragma mark - 跳转到登陆界面
- (void)jumpLongViewController
{
    LonginViewController *longinVC = [[LonginViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:longinVC];
    [self.window.rootViewController presentViewController:navigation animated:NO completion:nil];
    
}

#pragma mark - 获得IM token后连接SDK服务器
- (void)connectionIMSDKServer:(NSString *)token
{
    // 获得 token 后 连接融云IM SDK 服务器
    [[RCIM sharedRCIM] connectWithToken:token
                                success:^(NSString *userId) {
                                    
                                    NSLog(@"登陆融云IM成功,当前登陆的用户ID: %@", userId);
                                    
                                } error:^(RCConnectErrorCode status) {
                                    
                                    NSLog(@"登陆的错误码为-------- : %ld", (long)status);
                                    
                                } tokenIncorrect:^{
                                    
                                    /**
                                     *  token过期或者不正确。
                                     *  如果设置了token有限期限并且token过期，请重新请求您的服务器获取新的token
                                     *  如果没有设置token有效期却提示token错误，请检查您的客户端和服务端的appkey是否匹配，还有检查您获取token的流程。
                                     */
                                    NSLog(@"token错误");
                                    
                                }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [UMSocialSnsService applicationDidBecomeActive];
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - URL SchemesA跳转回调
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        NSLog(@"跳转状态未知!");
    }
    
    // 跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"aliPay = %@", resultDic);
         }];
        
    }
    
    
    return YES;
}

@end
