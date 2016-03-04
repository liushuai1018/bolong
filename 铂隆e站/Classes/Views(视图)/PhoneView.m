//
//  PhoneView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/29.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "PhoneView.h"

@implementation PhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView];
    }
    return self;
}

#pragma mark 创建所有子视图
- (void)createAllSubView
{
    self.backgroundColor = [UIColor colorWithRed:235.0/256.0 green:235.0/256.0 blue:235.0/256.0 alpha:1.0];
    
    // 手机号
    self.phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 30)];
    _phoneNumber.placeholder = @" 请先输入手机号";
    _phoneNumber.font = [UIFont systemFontOfSize:14.0f];
//    _phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumber.delegate = self;
    _phoneNumber.backgroundColor = [UIColor whiteColor];
    _phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_phoneNumber];
    
    // 提示
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_phoneNumber.frame) + 10, 100, 15)];
    label.text = @"充话费";
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    
    CGFloat width = (SCREEN_WIDTH - 60) / 3.0;
    CGFloat height = width * 0.6;
    // 10
    self.tenBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _tenBut.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 15, width, height);
    [_tenBut setImage:[UIImage imageNamed:@"10Y.png"] forState:UIControlStateNormal];
    _tenBut.tag = 11200;
    [self addSubview:_tenBut];
    
    // 20
    self.twentyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _twentyBut.frame = CGRectMake(CGRectGetMaxX(_tenBut.frame) + 10, CGRectGetMinY(_tenBut.frame), width, height);
    [_twentyBut setImage:[UIImage imageNamed:@"20Y.png"] forState:UIControlStateNormal];
    _twentyBut.tag = 11201;
    [self addSubview:_twentyBut];
    
    // 30
    self.thirtyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirtyBut.frame = CGRectMake(CGRectGetMaxX(_twentyBut.frame) + 10, CGRectGetMinY(_tenBut.frame), width, height);
    [_thirtyBut setImage:[UIImage imageNamed:@"30Y.png"] forState:UIControlStateNormal];
    _thirtyBut.tag = 11202;
    [self addSubview:_thirtyBut];
    
    // 50
    self.fiftyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _fiftyBut.frame = CGRectMake(20, CGRectGetMaxY(_tenBut.frame) + 10, width, width * 0.6);
    [_fiftyBut setImage:[UIImage imageNamed:@"50Y.png"] forState:UIControlStateNormal];
    _fiftyBut.tag = 11203;
    [self addSubview:_fiftyBut];
    
    // 100
    self.oneHundredBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneHundredBut.frame = CGRectMake(CGRectGetMaxX(_fiftyBut.frame) + 10, CGRectGetMinY(_fiftyBut.frame), width, height);
    [_oneHundredBut setImage:[UIImage imageNamed:@"100Y.png"] forState:UIControlStateNormal];
    _oneHundredBut.tag = 11204;
    [self addSubview:_oneHundredBut];
    
    // 其他
    self.otherBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherBut.frame = CGRectMake(CGRectGetMaxX(_oneHundredBut.frame) + 10, CGRectGetMinY(_fiftyBut.frame), width, height);
    [_otherBut setImage:[UIImage imageNamed:@"qita.png"] forState:UIControlStateNormal];
    _otherBut.tag = 11205;
    [self addSubview:_otherBut];
    
    
}

#pragma mark 续费提示框
- (void)createWarningViewWithInt:(CGFloat)index actualNumber:(CGFloat)actual currentNumber:(NSString *)current surplusNumber:(CGFloat)surplus phone:(NSString *)phone
{
    
    UIColor *color = [UIColor colorWithRed:55.0 / 256.0 green:55.0 / 256.0 blue:55.0 / 256.0 alpha:0.7];
    
    // 手机号字符串
    NSString *phoneNumberStr = [NSString stringWithFormat:@"%ld元手机费 -%@", (long)index, phone];
    
    // 当前铂隆币
    NSString *remainingStr = [NSString stringWithFormat:@"铂隆币 (＄%@)", current];
    
    // 剩余铂隆币
    NSString *surplusStr = [NSString stringWithFormat:@"剩余:%.2f", surplus];
    
    // 实缴话费
    NSString *paidIn = [NSString stringWithFormat:@"-%.2f", actual];
    
    
    self.promptView = [[UIView alloc] initWithFrame:self.bounds];
    _promptView.backgroundColor = color;
    [self addSubview:_promptView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.6, SCREEN_WIDTH * 0.35)];
    view.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.3);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0;
    [_promptView addSubview:view];
    
    
    CGFloat width = CGRectGetWidth(view.frame);
    // 小 X
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(width - 18, 7, 15, 15);
    [button setImage:[UIImage imageNamed:@"guanbi.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickPromptAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    // 提示
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - 30, 15)];
    label.center = CGPointMake(width * 0.5, 13);
    label.text = @"付费成功";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor greenColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:label];
    
    // 手机号
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 3, width, 10)];
    label1.text = phoneNumberStr;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = color;
    label1.font = [UIFont systemFontOfSize:6.0f];
    [view addSubview:label1];
    
    
    // 分割线
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame) + 2, width, 1)];
    view1.backgroundColor = [UIColor colorWithRed:155.0 / 256.0 green:155.0 / 256.0 blue:155.0 / 256.0 alpha:0.7];
    [view addSubview:view1];
    
    // 图标
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame) + 15, CGRectGetHeight(view.frame) * 0.3, CGRectGetHeight(view.frame) * 0.3)];
    imageView.image = [UIImage imageNamed:@"bolongbi-1.png"];
    [view addSubview:imageView];
    
    // 铂隆币
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMinY(imageView.frame), width - CGRectGetHeight(view.frame) * 0.3 - 20, CGRectGetHeight(imageView.frame) * 0.333)];
    label2.text = remainingStr;
    label2.textColor = color;
    label2.font = [UIFont systemFontOfSize:9.0f];
    [view addSubview:label2];
    
    // 实缴
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label2.frame), CGRectGetHeight(imageView.frame) * 0.666 + CGRectGetMinY(imageView.frame), 40, CGRectGetHeight(label2.frame))];
    label3.text = paidIn;
    label3.textColor = color;
    label3.font = [UIFont systemFontOfSize:9.0f];
    [view addSubview:label3];
    
    // 剩余
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame) + 5, CGRectGetMinY(label3.frame), width - CGRectGetMaxX(label3.frame) - 5, CGRectGetHeight(label2.frame))];
    label4.text = surplusStr;
    label4.textColor = color;
    label4.font = [UIFont systemFontOfSize:9.0f];
    [view addSubview:label4];
    
    
}

- (void)didClickPromptAction
{
    [_promptView removeFromSuperview];
}

#pragma mark touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneNumber resignFirstResponder];
}

#pragma mark textField 协议
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 添加选择输入文字监听
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // 临时存储
    NSString *checkString;
    
    /*
     *  判断手机号位数
     *  达到11位返回 NO 则不可在输入
     *  未达到11位返回 YES 可以继续输入
     */
    if (range.location > 11) {
        
        return NO;
        
    } else {
        /**
         *  每次输入字符拼接到当前字符串后面
         */
        if (![string isEqualToString:@""]) {
            
            checkString = [self.phoneNumber.text stringByAppendingString:string];
            
        } else {
            checkString = [checkString stringByDeletingLastPathComponent];
        }
        /**
         *  判断每次输入完后字符串是否达到要求，达到设置按钮可点击
         */
        if ([self isValidateMobile:checkString]) {
            // 手机号达到要求设置按钮可点击
            [self butUserInteractionEnabled:YES];
        } else {
            // 手机号未达到要求按钮不可点击
            [self butUserInteractionEnabled:NO];
        }
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    // 判断是不是要输入文字的文本框
    if (textField == self.phoneNumber) {
        
        // 判断选择输入文本框的长度
        if (textField.text.length > 11) {
            
            // 超过限制从0 截取到限制长度
            textField.text = [textField.text substringToIndex:11];
            
            /**
             *  判断每次输入完后字符串是否达到要求，达到设置按钮可点击
             */
            if ([self isValidateMobile:textField.text]) {
                // 手机号达到要求设置按钮可点击
                [self butUserInteractionEnabled:YES];
            }
        }
    }
}

// 正则表达式
#pragma mark 手机号码验证
- (BOOL)isValidateMobile:(NSString *)mobile
{
    // 手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    // NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark 手机号达不到要求禁止点击
- (void)butUserInteractionEnabled:(BOOL)is
{
    if (is) {
        for (int i = 11200; i < 11206; i++) {
            UIButton *but = [self viewWithTag:i];
            but.userInteractionEnabled = YES;
            but.alpha = 1.0;
        }
    } else {
        for (int i = 11200; i < 11206; i++) {
            UIButton *but = [self viewWithTag:i];
            but.userInteractionEnabled = NO;
            but.alpha = 0.4;
        }
    }
}

@end
