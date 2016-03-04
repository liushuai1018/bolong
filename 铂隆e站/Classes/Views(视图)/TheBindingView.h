//
//  TheBindingView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheBindingView : UIView

@property (nonatomic, strong) UITextField *phone;  // 手机号

@property (nonatomic, strong) UIButton *next;      // 下一步

@property (nonatomic, strong) UIButton *merit;     // 优点

/**
 *  输入验证码界面
 */
@property (nonatomic, strong) UIButton *finished;  // 完成

- (void)createrCaptchaView;                        // 创建验证码界面


/**
 *  绑定成功
 */
@property (nonatomic, strong) UIButton *replaces;   // 更换手机号

- (void)createrSuccessView;                         // 创建绑定成功界面

@end
