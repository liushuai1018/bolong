//
//  HeatingView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "HeatingView.h"

@implementation HeatingView

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
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _scrollView.backgroundColor = [UIColor colorWithRed:235.0/256.0 green:235.0/256.0 blue:235.0/256.0 alpha:1.0];
    [self addSubview:_scrollView];
    
    // 图标
    self.iocImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 40, 60, 80, 80)];
    [_scrollView addSubview:_iocImage];
    
    // 宽度
    CGFloat width = SCREEN_WIDTH * 0.9;
    CGFloat height = 50;
    // 公司列表
    self.pulldownMenusV = [[PulldownMenusView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.05, CGRectGetMaxY(_iocImage.frame) + 20, width, height)];
    _pulldownMenusV.textField.backgroundColor = [UIColor whiteColor];
    _pulldownMenusV.tv.backgroundColor = [UIColor whiteColor];
    _pulldownMenusV.layer.masksToBounds = YES;
    _pulldownMenusV.layer.cornerRadius = 5.0;
    [_scrollView addSubview:_pulldownMenusV];
    
    // 缴费账号
    self.accountNumber = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pulldownMenusV.frame), CGRectGetMaxY(_pulldownMenusV.frame) + 15, width, height)];
    _accountNumber.backgroundColor = [UIColor whiteColor];
    _accountNumber.textAlignment = NSTextAlignmentCenter;
    _accountNumber.placeholder = @"请输入缴费号码";
    _accountNumber.layer.masksToBounds = YES;
    _accountNumber.layer.cornerRadius = 5.0;
    _accountNumber.returnKeyType = UIReturnKeyDone;
    _accountNumber.delegate = self;
    _accountNumber.clearsOnBeginEditing = YES;
    _accountNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_scrollView addSubview:_accountNumber];
    
    // 缴费金额
    self.paymentAmount = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pulldownMenusV.frame), CGRectGetMaxY(_accountNumber.frame) + 15, width, height)];
    _paymentAmount.backgroundColor = [UIColor whiteColor];
    _paymentAmount.textAlignment = NSTextAlignmentCenter;
    _paymentAmount.placeholder = @"请输入缴费金额";
    _paymentAmount.layer.masksToBounds = YES;
    _paymentAmount.layer.cornerRadius = 5.0;
    _paymentAmount.returnKeyType = UIReturnKeyDone;
    _paymentAmount.delegate = self;
    _paymentAmount.clearsOnBeginEditing = YES;
    _paymentAmount.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_scrollView addSubview: _paymentAmount];
    
    
    // 缴费按钮
    self.payBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBUtton.frame = CGRectMake(CGRectGetMinX(_pulldownMenusV.frame), CGRectGetMaxY(_paymentAmount.frame) + 15, width, 40);
    [_payBUtton setTitle:@"缴费" forState:UIControlStateNormal];
    [_payBUtton setBackgroundImage:[UIImage imageNamed:@"jifei.png"] forState:UIControlStateNormal];
    _payBUtton.tag = 12300;
    [_scrollView addSubview:_payBUtton];
    
    // 取消界面其他第一响应链
    __weak HeatingView *heat = self;
    _pulldownMenusV.aBlock = ^() {
        [heat.accountNumber resignFirstResponder];
        [heat.paymentAmount resignFirstResponder];
    };
}

#pragma mark TextFieldDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 隐藏下拉菜单
    [_pulldownMenusV clickOnTheOther];
    [_accountNumber resignFirstResponder];
    [_paymentAmount resignFirstResponder];
    
}

// return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 隐藏下拉菜单
    [_pulldownMenusV clickOnTheOther];
    return YES;
}

#pragma mark - 取消输入框第一响应
- (void)LSResignFirstResponder
{
    [_accountNumber resignFirstResponder];
    [_paymentAmount resignFirstResponder];
}

#pragma mark 确认缴费视图
- (void)createConfirmView
{
    UIColor *color = [UIColor colorWithRed:55.0 / 256.0 green:55.0 / 256.0 blue:55.0 / 256.0 alpha:0.7];
    
    // 背景视图
    self.confirmView = [[UIView alloc] initWithFrame:self.bounds];
    _confirmView.backgroundColor = color;
    [self addSubview:_confirmView];
    
    // 白色背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.1, SCREEN_HEIGHT * 0.25, SCREEN_WIDTH * 0.8, SCREEN_WIDTH * 0.45)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 5.0;
    [_confirmView addSubview:backgroundView];
    
    // 视图提示文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(backgroundView.frame), 30)];
    label.text = @"支付方式";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0f];
    [backgroundView addSubview:label];
    
    // 选择图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(backgroundView.frame) * 0.15, CGRectGetMaxY(label.frame) + 19, 12, 12)];
    imageView.image = [UIImage imageNamed:@"daxuanze.png"];
    [backgroundView addSubview:imageView];
    
    // 方式
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(backgroundView.frame) * 0.45, CGRectGetMinY(imageView.frame) - 4, CGRectGetWidth(backgroundView.frame) * 0.45, 20)];
    textField.text = @"铂隆币";
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.textAlignment = NSTextAlignmentCenter;
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView1.image = [UIImage imageNamed:@"bolongbi-1.png"];
    
    textField.leftView = imageView1;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.userInteractionEnabled = NO;
    [backgroundView addSubview:textField];
    
    // 确定支付
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(1, CGRectGetHeight(backgroundView.frame) - 40, CGRectGetWidth(backgroundView.frame) * 0.49, 20);
    [button setTitle:@"是" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = 12500;
    [backgroundView addSubview:button];
    
    // 分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame), 1, 20)];
    view.backgroundColor = color;
    [backgroundView addSubview:view];
    
    // 取消分割
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(CGRectGetMaxX(view.frame), CGRectGetMinY(button.frame), CGRectGetWidth(button.frame), 20);
    [button1 setTitle:@"否" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.tag = 12501;
    [backgroundView addSubview:button1];
}

#pragma mark 创建缴费完成视图
- (void)createCompleteView
{
    self.completeView = [[UIView alloc] initWithFrame:self.bounds];
    _completeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_completeView];
    // 标题
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 50, 80, 100, 30)];
    textField.text = @"  付款成功";
    textField.font = [UIFont systemFontOfSize:16.0f];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"daxuanze.png"];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [_completeView addSubview:textField];
    
    
    // 姓名
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(textField.frame) + 50, 100, 20)];
    label1.text = @"姓名:";
    label1.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:label1];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), CGRectGetMinY(label1.frame), 200, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:_nameLabel];
    
    // 缴费账号
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label1.frame) + 20, 100, 20)];
    label2.text = @"缴费账号:";
    label2.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:label2];
    
    self.accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMinY(label2.frame), 200, 20)];
    _accountLabel.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:_accountLabel];
    
    // 水电费余额
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label2.frame) + 20, 100, 20)];
    label3.text = @"账号余额:";
    label3.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:label3];
    
    self.accountBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame), CGRectGetMinY(label3.frame), 200, 20)];
    _accountBalanceLabel.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:_accountBalanceLabel];
    
    // 铂隆币余额
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label3.frame) + 20, 100, 20)];
    label4.text = @"铂隆币余额";
    label4.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:label4];
    
    self.boLongBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame), CGRectGetMinY(label4.frame), 200, 20)];
    _boLongBalanceLabel.font = [UIFont systemFontOfSize:12.0f];
    [_completeView addSubview:_boLongBalanceLabel];
}

@end
