//
//  LS_TabBarController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/14.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_TabBarController.h"

#import "LS_HomeViewController.h"
#import "LS_UserTableViewController.h"
#import "LS_Help_TableViewController.h"

@interface LS_TabBarController ()
{
    LS_HomeViewController *LS_home; // 新首页
    LS_UserTableViewController *LS_user; // 我的界面
    LS_Help_TableViewController *LS_help;
}
@end

@implementation LS_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBar];
    [self initAllSubControls];
}

#pragma mark - 初始化tabBar
- (void)initTabBar
{
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [UIColor colorWithRed:0.99 green:0.84 blue:0.19 alpha:1.0];
}

#pragma mark - 初始化子控件
- (void)initAllSubControls
{
    
    LS_home = [[LS_HomeViewController alloc] init];
    UINavigationController *homeNavigtion = [[UINavigationController alloc] initWithRootViewController:LS_home];
    
    LS_user = [[LS_UserTableViewController alloc] init];
    UINavigationController *userNavigtion = [[UINavigationController alloc] initWithRootViewController:LS_user];
    
    LS_help = [[LS_Help_TableViewController alloc] init];
    UINavigationController *LS_helpNavigation = [[UINavigationController alloc] initWithRootViewController:LS_help];
    
    self.viewControllers = @[homeNavigtion,
                             userNavigtion,
                             LS_helpNavigation];
    
    // 设置TabBar标题
    homeNavigtion.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"E站" image:[UIImage imageNamed:@"tabBar_E"] tag:100000];
    userNavigtion.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"tabBat_wo"] tag:100002];
    LS_helpNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"帮助" image:[UIImage imageNamed:@"tabBar_bang"] tag:100004];
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]]; // 设置所有顶部导航栏的背景
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
}
@end
