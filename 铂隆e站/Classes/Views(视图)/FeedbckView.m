//
//  FeedbckView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/14.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "FeedbckView.h"

@implementation FeedbckView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView];
    }
    return self;
}

// 创建所有子视图
- (void)createAllSubView
{
    self.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.0];
    
    // 提示文字
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, SCREEN_WIDTH - 20, 30)];
    label1.text = @"我们懂得聆听，知错就改，您的意见是";
    label1.font = [UIFont systemFontOfSize:14.0];
    label1.textColor = [UIColor lightGrayColor];
    [self addSubview:label1];
    
    // 意见
    self.opinionTF = [[UITextView alloc] initWithFrame:CGRectMake( CGRectGetMinX(label1.frame), CGRectGetMaxY(label1.frame), CGRectGetWidth(label1.frame), SCREEN_HEIGHT * 0.25)];
    _opinionTF.delegate = self;
    _opinionTF.backgroundColor = [UIColor whiteColor];
    [self addSubview:_opinionTF];
    
    // 提示文字2
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label1.frame), CGRectGetMaxY(_opinionTF.frame) + 5, CGRectGetWidth(label1.frame), 30)];
    label2.text = @"请留下您的手机号，以便于我们联系您";
    label2.font = [UIFont systemFontOfSize:14.0];
    label2.textColor = [UIColor lightGrayColor];
    [self addSubview:label2];
    
    // 手机号
    self.unmberTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(label1.frame), CGRectGetMaxY(label2.frame) + 5, CGRectGetWidth(label1.frame), 40)];
    _unmberTF.delegate = self;
    _unmberTF.keyboardType = UIKeyboardTypeNumberPad;
    _unmberTF.backgroundColor = [UIColor whiteColor];
    [self addSubview:_unmberTF];
    
    // 提交按钮
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitBtn.frame = CGRectMake(CGRectGetMinX(label1.frame), CGRectGetMaxY(_unmberTF.frame) + 20, CGRectGetWidth(label1.frame), 40);
    self.submitBtn.backgroundColor = [UIColor orangeColor];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self addSubview:_submitBtn];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_opinionTF resignFirstResponder];
    [_unmberTF resignFirstResponder];
}



@end
