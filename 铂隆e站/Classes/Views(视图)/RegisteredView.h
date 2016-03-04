//
//  RegisteredView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^kBlock2)(UIButton *);

@interface RegisteredView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneNumber; // 手机号
@property (nonatomic, strong) UITextField *password; // 密码
@property (nonatomic, strong) UITextField *confirmPassword; // 确认密码
@property (nonatomic, strong) UITextField *captcha; // 验证码
@property (nonatomic, strong) UIButton *gettingCaptcha; // 获取验证码
@property (nonatomic, strong) UILabel *promptLabel; // 消息提示框
@property (nonatomic, copy) kBlock2 block;

@property (nonatomic, assign) BOOL record;   // 记录是否有输入不正确的地方

@end
