//
//  CustomTabBar.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/27.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        
        // 添加一个button代替 TabBar
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"wo.png"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"wo-2.png"] forState:UIControlStateHighlighted];
        CGRect rect = self.frame;
        rect.size = image.size;
        button.frame = rect;
        [button addTarget:self action:@selector(puslBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.button = button;
        
        
        // 设置选中状态颜色
        self.tintColor = [UIColor orangeColor];
        
    }
    return  self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5 - 10);
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = CGRectGetWidth(_button.frame) * 0.5;
    
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 3;
    CGFloat tabbarButtonIndex = 0;
    
    for (UIView *child in self.subviews) {

        Class class = NSClassFromString(@"UITabBarButton");
        
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect rect = child.frame;
            rect.size.width = tabbarButtonW;
            // 设置x
            rect.origin.x = tabbarButtonIndex * tabbarButtonW;
            child.frame = rect;
            
            
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 1) {
                tabbarButtonIndex++;
            }
        }
    }
    
}

#pragma mark - 自定义tabbar 事件处理器
- (void)puslBtn
{
    if ([self.delegates respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        
        [self.delegates tabBarDidClickPlusButton:self];
    }
}
@end
