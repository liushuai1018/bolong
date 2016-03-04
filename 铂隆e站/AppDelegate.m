//
//  AppDelegate.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/26.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "AppDelegate.h"
#import "UserGuideViewController.h"  // 用户引导页
#import "CustomViewController.h"     // 自定义标签导航栏
#import "LonginViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate ()
 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 创建window窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initializeUM];
    [self initiazeRong];
    
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
            [self jumpLongViewController];
        };
        
    } else {
        [self firstpressed]; // 跳转主界面
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
    CustomViewController *custom = [[CustomViewController alloc] init];
    self.window.rootViewController = custom;
    
}

#pragma mark - 跳转到登陆界面
- (void)jumpLongViewController
{
    LonginViewController *longinVC = [[LonginViewController alloc] init];
    [self.window.rootViewController presentViewController:longinVC animated:NO completion:nil];
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// URL SchemesA跳转回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        NSLog(@"跳转状态未知!");
    }
    return YES;
}

@end
