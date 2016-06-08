//
//  LonginView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/3.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//


/**
 *  登陆界面
 */
#import <UIKit/UIKit.h>

@interface LonginView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameText; // 用户名
@property (nonatomic, strong) UITextField *passwordText; // 密码
@property (nonatomic, strong) UIButton *longBut; // 登陆按钮
@property (nonatomic, strong) UIButton *registeredBut; // 注册按钮
@property (nonatomic, strong) UILabel *promptLabel; // 密码错误提示框

@end
