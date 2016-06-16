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
#import <AdSupport/AdSupport.h>
#import "JPUSHService.h"

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
    
    [self initiazeRong];
    [self connectionIMSDKServer];
    [self initJPUSHWithOptions:launchOptions];
    
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
- (void)connectionIMSDKServer
{
    // 获取用户信息
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    if (userInfo != nil) {
        
        [[NetWorkRequestManage sharInstance] obtainIMToken:userInfo returns:^(NSString *token) {
            
            // 获得 token 后 连接融云IM SDK 服务器
            [[RCIM sharedRCIM] connectWithToken:token
                                        success:^(NSString *userId) {
                                            
                                            
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
    
    
}

#pragma mark - 极光推送
- (void)initJPUSHWithOptions:(NSDictionary *)launchOption {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { // 系统版本
        // 可以自定义类别categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert )
                                              categories:nil];
    } else {
        // 类别categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert )
                                              categories:nil];
    }
    
    // 如果不需要使用IDFA, advertisingIDentifier 可为nil
    [JPUSHService setupWithOption:launchOption
                           appKey:JPush_key
                          channel:@"App Store"
                 apsForProduction:FALSE
            advertisingIdentifier:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; // 设置通知消息归0
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [application setApplicationIconBadgeNumber:0];// 设置通知消息归0
    [application cancelAllLocalNotifications]; // 取消全部的本地通知
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
    // 跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic)
         {
             
         }];
    }
    return YES;
}

#pragma mark - JPUSH
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    // JPUSH 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 判断程序是否在前台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        // 在前台弹出一个提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"推送消息" message:@"你有一条新的推送消息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        
        UIAlertAction *chakan = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:chakan];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
@end
