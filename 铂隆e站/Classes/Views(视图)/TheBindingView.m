//
//  TheBindingView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "TheBindingView.h"

@interface TheBindingView ()

@property (nonatomic, strong) NSString *phoneStr;

@end

@implementation TheBindingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView];
    }
    return self;
}

// 创建所有视图
- (void)createAllSubView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor colorWithRed:245.0 / 256.0 green:245.0 / 256.0 blue:245.0 / 256.0 alpha:0.7];
    [self addSubview:backgroundView];
    
    // 提示
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    label.text = @"绑定手机号需要通过短信验证";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:label];
    
    // 分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 5, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:view];
    
    // 提示 中国 + 86
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), SCREEN_WIDTH * 0.3 - 1, SCREEN_HEIGHT * 0.09)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.text = @"中国 +86";
    label1.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:label1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), CGRectGetMinY(label1.frame), 1, CGRectGetHeight(label1.frame))];
    view2.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:view2];
    
    // 输入手机号
    self.phone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 1, CGRectGetMinY(label1.frame), SCREEN_WIDTH * 0.7, CGRectGetHeight(label1.frame))];
    _phone.backgroundColor = [UIColor whiteColor];
    _phone.placeholder = @" 请输入手机号";
    [backgroundView addSubview:_phone];
    
    // 分割线
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_phone.frame), SCREEN_WIDTH, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:view1];
    
    self.next = [UIButton buttonWithType:UIButtonTypeCustom];
    _next.frame = CGRectMake(SCREEN_WIDTH * 0.1, CGRectGetMaxY(label1.frame) + 10, SCREEN_WIDTH * 0.8, SCREEN_HEIGHT * 0.08);
    [_next setBackgroundImage:[UIImage imageNamed:@"setbankphone_btn2"] forState:UIControlStateNormal];
    [_next setTitle:@"下一步" forState:UIControlStateNormal];
    [_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _next.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:_next];
    
    self.merit = [UIButton buttonWithType:UIButtonTypeCustom];
    _merit.frame = CGRectMake(SCREEN_WIDTH * 0.35, CGRectGetMaxY(_next.frame), SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.08);
    [_merit setTitle:@"绑定优点" forState:UIControlStateNormal];
    [_merit setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _merit.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_merit addTarget:self action:@selector(clickMerritAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:_merit];
    
}

// 绑定优势
- (void)clickMerritAction:(UIButton *)sender
{
    
}


#pragma mark - 验证码界面
- (void)createrCaptchaView
{
    _phoneStr = _phone.text;
    
    // 移除背后子视图
    NSArray *array = [self subviews];
    for (int i = 0; i < array.count; i++) {
        UIView *view = array[i];
        [view removeFromSuperview];
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundView.backgroundColor = [UIColor colorWithRed:245.0 / 256.0 green:245.0 / 256.0 blue:245.0 / 256.0 alpha:1.0];
    [self addSubview:backgroundView];
    
    
    // 分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:view];
    
    // 提示 中国 + 86
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), SCREEN_WIDTH * 0.3 - 1, SCREEN_HEIGHT * 0.09)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.text = @"验证码";
    label1.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:label1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), CGRectGetMinY(label1.frame), 1, CGRectGetHeight(label1.frame))];
    view2.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:view2];
    
    // 输入手机号
    self.phone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 1, CGRectGetMinY(label1.frame), SCREEN_WIDTH * 0.7, CGRectGetHeight(label1.frame))];
    _phone.backgroundColor = [UIColor whiteColor];
    _phone.placeholder = @" 请输入验证码";
    [backgroundView addSubview:_phone];
    
    // 分割线
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_phone.frame), SCREEN_WIDTH, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:view1];
    
    
    self.finished = [UIButton buttonWithType:UIButtonTypeCustom];
    _finished.frame = CGRectMake(SCREEN_WIDTH * 0.1, CGRectGetMaxY(label1.frame) + 10, SCREEN_WIDTH * 0.8, SCREEN_HEIGHT * 0.08);
    [_finished setBackgroundImage:[UIImage imageNamed:@"setbankphone_btn2"] forState:UIControlStateNormal];
    [_finished setTitle:@"完成" forState:UIControlStateNormal];
    [_finished setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _finished.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundView addSubview:_finished];
    
}

#pragma mark - 创建绑定成功界面
- (void)createrSuccessView
{
    // 移除背后子视图
    NSArray *array = [self subviews];
    for (int i = 0; i < array.count; i++) {
        UIView *view = array[i];
        [view removeFromSuperview];
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundView.backgroundColor = [UIColor colorWithRed:245.0 / 256.0 green:245.0 / 256.0 blue:245.0 / 256.0 alpha:1.0];
    [self addSubview:backgroundView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 15)];
    label.text = @"你已绑定手机号码";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12.0f];
    [backgroundView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 5, SCREEN_WIDTH, 50)];
    label1.text = _phoneStr;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:24.0f];
    [backgroundView addSubview:label1];
    
    self.replaces = [UIButton buttonWithType:UIButtonTypeSystem];
    _replaces.frame = CGRectMake(SCREEN_WIDTH * 0.45, CGRectGetMaxY(label1.frame) + 10, SCREEN_WIDTH * 0.1, 20);
    _replaces.backgroundColor = [UIColor whiteColor];
    [_replaces setTitle:@"更换" forState:UIControlStateNormal];
    [_replaces setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _replaces.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [backgroundView addSubview:_replaces];
    
}


@end
