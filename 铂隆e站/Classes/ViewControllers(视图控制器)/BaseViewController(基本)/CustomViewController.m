//
//  CustomViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/27.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "CustomViewController.h"
#import "HomeTableViewController.h"
#import "UserTableViewController.h"
#import "HelpTableViewController.h"
#import "CustomTabBar.h"

@interface CustomViewController () <CustomTabBarDelegate>

{
    HomeTableViewController *_home; // 首页
    UserTableViewController *_user; // 我
    HelpTableViewController *_help; // 帮助
    CustomTabBar *_custom; // 自定义TabBar
}

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.translucent = NO;
    [self initialize]; // 初始化子控件
    [self clearColorItem]; // 隐藏 tabbar 上面的黑线
    
    
}

#pragma mark - 初始化子控件
- (void)initialize
{
    
    _home = [[HomeTableViewController alloc] init];
    UINavigationController *homeNavigtion = [[UINavigationController alloc] initWithRootViewController:_home];
    
    _user = [[UserTableViewController alloc] init];
    UINavigationController *userNavigtion = [[UINavigationController alloc] initWithRootViewController:_user];
    
    _help = [[HelpTableViewController alloc] init];
    UINavigationController *helpNavigtion = [[UINavigationController alloc] initWithRootViewController:_help];
    
    self.viewControllers = @[homeNavigtion, helpNavigtion, userNavigtion];
    
    // 设置TabBar标题
    homeNavigtion.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"shouye"] tag:100000];
    helpNavigtion.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"帮助" image:[UIImage imageNamed:@"bangzhu"] tag:100002];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]]; // 设置所有顶部导航栏的背景
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    // 创建自定义样式tabBar替换系统样式
    _custom = [[CustomTabBar alloc] init];
    _custom.delegates = self;
    [self setValue:_custom forKeyPath:@"tabBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 隐藏tabbar 上黑线
- (void)clearColorItem {
    // 隐藏 tabbar 上面的黑线
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    self.tabBar.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self setValue:self.tabBar forKeyPath:@"tabBar"]; // 成功替换系统自带的 tabBar
    
}

#pragma mark - tabBar Delegate
// tabbar协议方法
- (void)tabBarDidClickPlusButton:(CustomTabBar *)tabBar
{
    
    self.selectedIndex = 2;
    [_custom.button setImage:[UIImage imageNamed:@"wo-2.png"] forState:UIControlStateNormal];
    
}


// 点击tabBar 执行此方法
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [_custom.button setImage:[UIImage imageNamed:@"wo.png"] forState:UIControlStateNormal];
}

@end
