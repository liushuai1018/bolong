//
//  LS_user_headView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/15.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_user_headView.h"

@implementation LS_user_headView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createrAllSubView];
        
    }
    return self;
}

- (void)createrAllSubView
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    // 黑色
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width,  height* 0.55)];
    view.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0];
    [self addSubview:view];
    
    // 白色
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), width, height - CGRectGetMaxY(view.frame) - 3)];
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    
    // 灰色
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), width, 3)];
    view2.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
    [self addSubview:view2];
    
    // 头像
    self.portraitImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height * 0.3, height * 0.3)];
    _portraitImage.image = [UIImage imageNamed:@"wo"];
    _portraitImage.layer.masksToBounds = YES;
    _portraitImage.layer.cornerRadius = height * 0.15;
    _portraitImage.center = CGPointMake(width * 0.5, height * 0.5);
    [self addSubview:_portraitImage];
    
    // 铂隆币
    self.BoLongbi = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) - 30, CGRectGetMinX(_portraitImage.frame), 30)];
    _BoLongbi.textAlignment = NSTextAlignmentCenter;
    _BoLongbi.textColor = [UIColor whiteColor];
    _BoLongbi.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_BoLongbi];
    
    // 更换头像
    self.portraitBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _portraitBut.frame = CGRectMake(CGRectGetMaxX(_portraitImage.frame), CGRectGetMinY(_BoLongbi.frame), CGRectGetWidth(_BoLongbi.frame), 30);
    [_portraitBut setTitle:@"更换头像" forState:UIControlStateNormal];
    [_portraitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _portraitBut.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_portraitBut];
    
    // name
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_portraitImage.frame) + 5, width, 30)];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.placeholder = @"设置名称";
    _name.font = [UIFont systemFontOfSize:13.0f];
    _name.returnKeyType = UIReturnKeyDone;
    [self addSubview:_name];
    
    // 手机号
    self.phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_name.frame) + 5, width, 30)];
    _phoneNumber.textAlignment = NSTextAlignmentCenter;
    _phoneNumber.textColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.69 alpha:1.0];
    _phoneNumber.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:_phoneNumber];
    
}

#pragma mark - touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_name resignFirstResponder];
}

@end
