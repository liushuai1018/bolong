//
//  RegisteredView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "RegisteredView.h"

@implementation RegisteredView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatorAllSubView]; // 创建所有子控件
    }
    return self;
}

// 创建所有子控件
- (void)creatorAllSubView
{
    // 设置背景颜色
    // 灰色
    UIColor *color = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.0];
    self.backgroundColor = color;
    // 背景View
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    
    
    // 每个输入框的高度
    CGFloat height = CGRectGetHeight(backgroundView.frame);
    // 分割线的宽度
    CGFloat width = CGRectGetWidth(backgroundView.frame);
    
    
    // 手机号
    UILabel *phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake( 20, 0, 80, height * 0.24)];
    phoneNumber.text = @"手机号";
    [backgroundView addSubview:phoneNumber];
    // 显示框高度与宽度
    CGFloat labelWidth = CGRectGetWidth(phoneNumber.frame);
    CGFloat labelHeight = CGRectGetHeight(phoneNumber.frame);
    
    
    // 手机号输入框
    self.phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneNumber.frame) + 5, 0, width - 120, height * 0.24)];
    _phoneNumber.placeholder = @"请您输入手机号码";
    _phoneNumber.font = [UIFont systemFontOfSize:14.0f];
    _phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing; //清空按钮
    _phoneNumber.keyboardType = UIKeyboardTypeNumberPad; // 设置键盘样式
    _phoneNumber.delegate = self;
    _phoneNumber.tag = 13000;
    [backgroundView addSubview:_phoneNumber];
    
    // 输入框高度与宽度
    CGFloat textWidth = CGRectGetWidth(_phoneNumber.frame);
    CGFloat textHeight = CGRectGetHeight(_phoneNumber.frame);
    
    // 分割线1
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneNumber.frame), width, height * 0.01)];
    view1.backgroundColor = color;
    [backgroundView addSubview:view1];
    
    
    // 密码
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneNumber.frame), CGRectGetMaxY(view1.frame), labelWidth, labelHeight)];
    passwordLabel.text = @"密码";
    [backgroundView addSubview:passwordLabel];
    // 密码输入框
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneNumber.frame), CGRectGetMinY(passwordLabel.frame), textWidth, textHeight)];
    _password.placeholder = @"请您设置8~16位密码";
    _password.font = [UIFont systemFontOfSize:14.0f];
    _password.clearsOnBeginEditing = YES; // 再次输入清空内容
    _password.secureTextEntry = YES; // 密码以圆点显示
    _password.clearButtonMode = UITextFieldViewModeWhileEditing; // 清空按钮
    _password.returnKeyType = UIReturnKeyNext; // 键盘带进入下一个输入框按钮
    _password.delegate = self;
    _password.tag = 13001;
    [backgroundView addSubview:_password];
    // 分割线2
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(passwordLabel.frame), width, height * 0.01)];
    view2.backgroundColor = color;
    [backgroundView addSubview:view2];
    
    
    // 确认密码
    UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneNumber.frame), CGRectGetMaxY(view2.frame), labelWidth, labelHeight)];
    confirmLabel.text = @"确认密码";
    [backgroundView addSubview:confirmLabel];
    // 确认密码输入框
    self.confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneNumber.frame), CGRectGetMinY(confirmLabel.frame), textWidth, textHeight)];
    _confirmPassword.placeholder = @"请您再次数去密码";
    _confirmPassword.font = [UIFont systemFontOfSize:14.0f];
    _confirmPassword.clearsOnBeginEditing = YES; // 再次输入清空
    _confirmPassword.secureTextEntry = YES; // 密码以圆点显示
    _confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing; // 清空按钮
    _confirmPassword.returnKeyType = UIReturnKeyNext; //键盘带进入下一个输入框按钮
    _confirmPassword.delegate = self;
    _confirmPassword.tag = 13002;
    [backgroundView addSubview:_confirmPassword];
    // 分割线3
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(confirmLabel.frame), width, height * 0.01)];
    view3.backgroundColor = color;
    [backgroundView addSubview:view3];
    
    
    // 验证码
    UILabel *captchaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneNumber.frame), CGRectGetMaxY(view3.frame), labelWidth, labelHeight)];
    captchaLabel.text = @"验证码";
    [backgroundView addSubview:captchaLabel];
    // 验证码输入框
    self.captcha = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneNumber.frame), CGRectGetMinY(captchaLabel.frame), textWidth - 100, textHeight)];
    _captcha.placeholder = @"请您输入验证码";
    _captcha.font = [UIFont systemFontOfSize:14.0f];
    _captcha.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _captcha.keyboardType = UIKeyboardTypeASCIICapable;
    _captcha.returnKeyType = UIReturnKeyDone;
    _captcha.delegate = self;
    _captcha.tag = 13003;
    [backgroundView addSubview:_captcha];
    
    // 获取验证码
    self.gettingCaptcha = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _gettingCaptcha.frame = CGRectMake(CGRectGetMaxX(_captcha.frame) + 20, CGRectGetMinY(_captcha.frame) + height * 0.05, 70, textHeight - height * 0.1);
    _gettingCaptcha.backgroundColor = [UIColor colorWithRed:77.0 / 255 green:77.0 / 255 blue:77.0 / 255 alpha:1.0];
    [_gettingCaptcha setTitle:@"验证码" forState:UIControlStateNormal];
    [_gettingCaptcha setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _gettingCaptcha.layer.masksToBounds = YES;
    _gettingCaptcha.layer.cornerRadius = 5.0;
    [_gettingCaptcha addTarget:self action:@selector(clickGettingCaptcha:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:_gettingCaptcha];
    
    
    // 提示框
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneNumber.frame), CGRectGetMaxY(backgroundView.frame) + 5, SCREEN_WIDTH - 40, 25)];
    _promptLabel.textColor = [UIColor redColor]; // 提示字体颜色
    _promptLabel.textAlignment = NSTextAlignmentCenter; // 居中
    [self addSubview:_promptLabel];
    
    
    
}

#pragma mark - 验证码按钮

- (void)clickGettingCaptcha:(UIButton *)sender
{
    [_captcha resignFirstResponder]; // 收回键盘
    self.block(sender); // 执行发送手机号
}

#pragma mark - UITextField Delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneNumber resignFirstResponder];
    [_password resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    [_captcha resignFirstResponder];
}
// Return 键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 13001:
            [_confirmPassword becomeFirstResponder];
            break;
        case 13002:
            [_captcha becomeFirstResponder];
            break;
            
        default:
            [textField resignFirstResponder];
            break;
    }
    
    return YES;
}

// 编辑结束
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSString *str = textField.text;
    NSInteger index = str.length; // 当前输入框的字符个数
    
    // 判断申请添加是否符合要求
    switch (textField.tag) {
        case 13000:
            
            if (![self isValidateMobile:textField.text]) {
                _promptLabel.text = @"请输入正确手机号!";
                _record = NO;
            } else {
                _promptLabel.text = @"";
                _record = YES;
            }
            
            break;
        case 13001:
            
            if (7 < index && index < 17) {
                _promptLabel.text = @"";
                _record = YES;
            } else {
                _promptLabel.text = @"请输入正确";
                _record = NO;
            }
            
            break;
        case 13002:
            
            if (![_password.text isEqualToString:_confirmPassword.text]) {
                _promptLabel.text = @"两次输入密码不相同!";
                _record = NO;
            } else {
                _promptLabel.text = @"";
                _record = YES;
            }
            
            break;
            
        default:
            break;
    }
}

// 正则表达式
#pragma mark 手机号码验证
- (BOOL)isValidateMobile:(NSString *)mobile
{
    // 手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - 随时监听输入文字
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (13003 == textField.tag) {
        
        // 添加选择输入文字监听
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        // 临时存储
        NSString *checkString;
        
        if (range.length > 6) {
            
            return NO;
            
        } else {
            
            if (![string isEqualToString:@""]) {
                
                checkString = [_captcha.text stringByAppendingString:string];
                
                NSLog(@"phone %@", self.captcha.text);
                
            } else {
                
                checkString = [checkString stringByDeletingLastPathComponent];
                
            }
            
            if (checkString.length == 6) {
                self.block1();
            } else {
                self.block2();
            }
            
            
        }
        
        return YES;
        
        
        
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    // 判断是不是要输入文字的文本框
    if (textField == self.captcha) {
        
        // 判断选择输入文本框的长度
        if (textField.text.length > 6) {
            
            // 超过限制从0 截取到限制长度
            textField.text = [textField.text substringToIndex:6];
            
            if (textField.text.length == 6) {
                
                self.block1();
            }
            
            
        }
    }
}
*/

@end
