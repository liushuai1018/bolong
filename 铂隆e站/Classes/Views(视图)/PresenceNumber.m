//
//  PresenceNumber.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PresenceNumber.h"

@implementation PresenceNumber

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
    // 六个输入框
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat textFirldWidth = width / 7.0;
    for (NSInteger i = 0; i < 6; i ++) {
        LSTextField *textField = [[LSTextField alloc] init];
        textField.frame = CGRectMake(width / 14.0  + textFirldWidth * i, 10, textFirldWidth, textFirldWidth);
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardType =UIKeyboardTypeNumberPad;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:16.0f];
        textField.tag = i + 98765;
        textField.delegate = self;
        textField.ls_delegate = self;
        [self addSubview:textField];
    }
    
    // 提示
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(width / 14.0, 20 + textFirldWidth, 300, 15)];
    textField.text = @" 请输入地面上标记的6位泊位数字";
    textField.font = [UIFont systemFontOfSize:12.0f];
    textField.userInteractionEnabled = NO;
    UIImageView *leftImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    leftImageView.image = [UIImage imageNamed:@"bochehao_warn"];
    textField.leftView = leftImageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:textField];
    
    // 黄色背景
    UIImageView *yellowBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textField.frame), width, CGRectGetHeight(self.frame) - CGRectGetMaxY(textField.frame) - 64)];
    yellowBackground.image = [UIImage imageNamed:@"bochehao_bg"];
    yellowBackground.userInteractionEnabled = YES;
    [self addSubview:yellowBackground];
    
    // 选择时间
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
    label.text = @"选择时间";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor whiteColor];
    [yellowBackground addSubview:label];
    
    // 选择器
//    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(label.frame) + 5, width / 7.0 * 6.0, CGRectGetHeight(yellowBackground.frame) * 0.35)];
//    _datePicker.backgroundColor = [UIColor whiteColor];
//    _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//    [yellowBackground addSubview:_datePicker];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(label.frame) + 5, width / 7.0 * 6.0, CGRectGetHeight(yellowBackground.frame) * 0.35)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.showsSelectionIndicator = YES;
    [yellowBackground addSubview:_pickerView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_pickerView.frame) * 0.5, 0, 0.5, CGRectGetHeight(_pickerView.frame))];
    view.backgroundColor = [UIColor lightGrayColor];
    [_pickerView addSubview:view];
    
    // 应付车费
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pickerView.frame), CGRectGetMaxY(_pickerView.frame) + 15,  CGRectGetWidth(_pickerView.frame), 15)];
    label1.text = @"应付车费";
    label1.font = [UIFont systemFontOfSize:14.0f];
    label1.textColor = [UIColor whiteColor];
    [yellowBackground addSubview:label1];
    
    // 缴费显示
    self.payLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label1.frame), CGRectGetMaxY(label1.frame) + 10,  CGRectGetWidth(label1.frame), CGRectGetHeight(label1.frame))];
    _payLabel.text = @"0.00元/账户余额0.00元";
    _payLabel.textColor = [UIColor blackColor];
    _payLabel.font = [UIFont systemFontOfSize:13.0f];
    [yellowBackground addSubview:_payLabel];
    
    // 确认
    self.determine = [UIButton buttonWithType:UIButtonTypeSystem];
    _determine.frame = CGRectMake(CGRectGetMinX(_pickerView.frame), CGRectGetMaxY(_payLabel.frame) + 20, CGRectGetWidth(_pickerView.frame), 40);
    [_determine setTitle:@"确认" forState:UIControlStateNormal];
    [_determine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_determine setBackgroundColor:[UIColor whiteColor]];
    _determine.layer.masksToBounds = YES;
    _determine.layer.cornerRadius = 5.0;
    [yellowBackground addSubview:_determine];
}



#pragma mark - LSDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    textField.text = string;
    NSInteger index = textField.tag + 1;
    LSTextField *text = [self viewWithTag:index];
    [text becomeFirstResponder];
    return NO;
}

- (void)lsTextFieldDelegateBackward:(LSTextField *)textField
{
    
    if ([textField.text isEqualToString:@""]) {
        NSInteger index = textField.tag - 1;
        LSTextField *text = [self viewWithTag:index];
        text.text = nil;
        [text becomeFirstResponder];
        
    }
}



#pragma mark - 移除键盘 获取泊车号
- (void)removeKeyObtaionNumber
{
    self.numberStr = nil;
    _numberStr = [[NSMutableString alloc] init];
    for (int i = 0; i < 6; i++) {
        LSTextField *text = [self viewWithTag:i + 98765];
        [text resignFirstResponder];
        [_numberStr appendString:text.text];
    }
}

@end
