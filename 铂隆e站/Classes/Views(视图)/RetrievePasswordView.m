//
//  RetrievePasswordView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/4.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "RetrievePasswordView.h"

@interface RetrievePasswordView ()

@property (nonatomic, strong) UIButton *verificationButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countdown;

@end

@implementation RetrievePasswordView

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
    
    _phone = [[UITextField alloc] initWithFrame:CGRectMake(3, 0, viewWidth * 0.75, viewHeight * 0.5)];
    _phone.placeholder = @"  请输入手机号码";
    _phone.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouji_"]];
    imageView.frame = CGRectMake(2, 0, 20, 30);
    _phone.leftView = imageView;
    [view addSubview:_phone];
    
    self.verificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _verificationButton.frame = CGRectMake(CGRectGetMaxX(_phone.frame), 0, viewWidth * 0.25, viewHeight * 0.5);
    [_verificationButton setTitle:@"验证码" forState:UIControlStateNormal];
    [_verificationButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_verificationButton];
    
    _verificationCode = [[UITextField alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(_phone.frame), CGRectGetWidth(_phone.frame), CGRectGetHeight(_phone.frame))];
    _verificationCode.placeholder = @"  输入验证码";
    _verificationCode.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yanzhengma_"]];
    imageView1.frame = CGRectMake(2, 0, 20, 30);
    _verificationCode.leftView = imageView1;
    [view addSubview:_verificationCode];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nextButton.frame = CGRectMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame) + 35, viewWidth, SCREEN_HEIGHT * 0.1);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:[UIColor colorWithRed:0.98 green:0.66 blue:0.39 alpha:1.0]];
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 5.0;
    [self addSubview:_nextButton];
    
}

#pragma mark -button 事件
- (void)clickButton:(UIButton *)sender
{
    // 发送验证码请求
    [[NetWorkRequestManage sharInstance] senderVerificationCode:_phone.text returnVerificationCode:^(NSString *str) {
        
    }];
    
    sender.enabled = NO;
    [sender setTitle:@"60秒" forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor lightGrayColor]];
    
    _countdown = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(onTimer)
                                            userInfo:nil
                                             repeats:YES];
    
}

#pragma  mark - 倒计时事件
- (void)onTimer
{
    if (_countdown > 0) {
        [_verificationButton setTitle:[NSString stringWithFormat:@"%ld秒", (long)_countdown] forState:UIControlStateNormal];
        _countdown--;
    } else {
        _countdown = 60;
        [_timer invalidate];
        [_verificationButton setTitle:@"验证码" forState:UIControlStateNormal];
        [_verificationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_verificationButton setBackgroundColor:[UIColor whiteColor]];
        _verificationButton.enabled = YES;
        
    }
}

@end
