//
//  PasswordView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/4.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  忘记密码的下一步
 */
#import <UIKit/UIKit.h>

@interface PasswordView : UIView

@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *confirmPassword;
@property (nonatomic, strong) UIButton *doneButton;

@end
