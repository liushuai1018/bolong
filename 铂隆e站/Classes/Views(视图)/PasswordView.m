//
//  PasswordView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/4.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PasswordView.h"

@implementation PasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView];
    }
    return self;
}

#pragma mark - 创建所有子视图
- (void)createAllSubView
{
    
    self.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, SCREEN_HEIGHT * 0.2)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self addSubview:view];
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0,  viewHeight * 0.5, viewWidth, 1.0)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:view1];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 40, viewHeight * 0.5)];
    _password.placeholder = @"新密码";
    _password.secureTextEntry = YES;
    [view addSubview:_password];
    
    _confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(view1.frame), viewWidth - 40, viewHeight * 0.5)];
    _confirmPassword.placeholder = @"确认密码";
    _confirmPassword.secureTextEntry = YES;
    [view addSubview:_confirmPassword];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _doneButton.frame = CGRectMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame) + 35, viewWidth, SCREEN_HEIGHT * 0.1);
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton setBackgroundColor:[UIColor colorWithRed:77.0 / 255 green:77.0 / 255 blue:77.0 / 255 alpha:1.0]];
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = 5.0;
    [self addSubview:_doneButton];
    
}

@end
