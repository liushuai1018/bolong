//
//  InputBoxView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "InputBoxView.h"

@implementation InputBoxView

- (id)initWithFrame:(CGRect)frame string:(NSString *)str
{
    self= [super initWithFrame:frame];
    if (self) {
        [self createrAllSubViewString:str];
    }
    return self;
}

#pragma mark - 创建子视图
- (void)createrAllSubViewString:(NSString *)str
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 输入框
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(30, 5, SCREEN_WIDTH - 110, 35);
    _textField.placeholder = str;
    _textField.font = [UIFont systemFontOfSize:14.0f];
    _textField.layer.borderWidth = 1.0;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_textField];
    
    // 发送
    _sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBut.frame = CGRectMake(CGRectGetMaxX(_textField.frame), CGRectGetMinY(_textField.frame), 60, 35);
    [_sendBut setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_sendBut];
}

@end
