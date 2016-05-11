//
//  LS_Other_recycling_View.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/9.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_recycling_View.h"
#import "LS_button.h"

@implementation LS_Other_recycling_View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createrAllSubView];
    }
    return self;
}

#pragma mark - 创建所有子视图
- (void)createrAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 背景
    UIImageView *bg_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bg_imageView.image = [UIImage imageNamed:@"new_shouye_bg.png"];
    bg_imageView.userInteractionEnabled = YES;
    [self addSubview:bg_imageView];
    
    // 按钮
    _button = [LS_button buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.7);
    _button.center = self.center;
    _button.adjustsImageWhenHighlighted = NO;
    [_button setBackgroundImage:[UIImage imageNamed:@"LS_huishou_YH"] forState:UIControlStateNormal];
    [self addSubview:_button];
    
    // 上门收购
    _buyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBut.frame = CGRectMake(SCREEN_WIDTH * 0.35, CGRectGetMaxY(_button.frame) + 40, SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.05);
    [_buyBut setTitle:@"上门收购" forState:UIControlStateNormal];
    [_buyBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyBut.layer.masksToBounds = YES;
    _buyBut.layer.cornerRadius = SCREEN_HEIGHT * 0.025;
    _buyBut.layer.borderWidth = 1.0;
    _buyBut.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_buyBut];
    
    // Logo
    UIImageView *logo_image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 40, CGRectGetMinY(_button.frame) - 90, 80, 70)];
    logo_image.image = [UIImage imageNamed:@"LS_huishou_logo"];
    [self addSubview:logo_image];
}

@end
