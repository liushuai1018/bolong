//
//  CustomTabBar.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/27.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  自定义TabBar
 */
#import <UIKit/UIKit.h>

@class CustomTabBar;
@protocol CustomTabBarDelegate <UITabBarDelegate>

- (void)tabBarDidClickPlusButton:(CustomTabBar *)tabBar;

@end

@interface CustomTabBar : UITabBar

@property (nonatomic, strong) UIButton *button; // 自定义的Button
@property (nonatomic, assign) id<CustomTabBarDelegate> delegates;

@end
