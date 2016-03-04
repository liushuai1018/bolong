//
//  WaterView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/31.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "WaterView.h"
#import "PulldownMenusView.h"

@implementation WaterView

- (void)setWaterCompanyArray:(NSArray *)waterCompanyArray
{
    _waterCompanyArray = waterCompanyArray;
    _pulldownMenusV.tableArray = waterCompanyArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubViews];
    }
    return self;
}


- (void)createAllSubViews
{
    self.backgroundColor = [UIColor colorWithRed:235.0/256.0 green:235.0/256.0 blue:235.0/256.0 alpha:1.0];
    
    // 图像
    self.xuanZeImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25, 20, SCREEN_WIDTH * 0.5, 30)];
    _xuanZeImage.image = [UIImage imageNamed:@"xuanze.png"];
    _xuanZeImage.userInteractionEnabled = YES;
    [self addSubview:_xuanZeImage];
    
    
    // 水费 button
    self.waterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _waterButton.frame = CGRectMake(0, 0, CGRectGetWidth(_xuanZeImage.frame) * 0.5, CGRectGetHeight(_xuanZeImage.frame));
    [_waterButton setTitle:@"水费" forState:UIControlStateNormal];
    [_waterButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_waterButton addTarget:self action:@selector(didClickWaterAction:) forControlEvents:UIControlEventTouchUpInside];
    [_xuanZeImage addSubview:_waterButton];
    
    // 电费 button
    self.electricityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _electricityButton.frame = CGRectMake(CGRectGetMaxX(_waterButton.frame), 0, CGRectGetWidth(_waterButton.frame), CGRectGetHeight(_waterButton.frame));
    [_electricityButton setTitle:@"电费" forState:UIControlStateNormal];
    [_electricityButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_electricityButton addTarget:self action:@selector(didClickElectricityAction:) forControlEvents:UIControlEventTouchUpInside];
    [_xuanZeImage addSubview:_electricityButton];
    
    // 定位
    self.positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _positionButton.frame = CGRectMake(CGRectGetMaxX(_xuanZeImage.frame) + 20, CGRectGetMinY(_xuanZeImage.frame) + 7, 12, 15);
    [_positionButton setImage:[UIImage imageNamed:@"dingwei.png"] forState:UIControlStateNormal];
    [self addSubview:_positionButton];
    
    //
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_positionButton.frame) + 5, CGRectGetMinY(_positionButton.frame), 20, 10)];
    _positionLabel.textColor = [UIColor colorWithRed:135.0/256.0 green:135.0/256.0 blue:135.0/256.0 alpha:1.0];
    _positionLabel.font = [UIFont systemFontOfSize: 8.0f];
    [self addSubview:_positionLabel];
    
    // 图标
    self.iocImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 40, CGRectGetMaxY(_xuanZeImage.frame) + 30, 80, 80)];
    _iocImage.image = [UIImage imageNamed:@"shui.png"];
    [self addSubview:_iocImage];
    
    CGFloat width = SCREEN_WIDTH * 0.9;
    // 公司列表
    self.pulldownMenusV = [[PulldownMenusView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.05, CGRectGetMaxY(_iocImage.frame) + 20, width, 50)];
    _pulldownMenusV.textField.text =  @"北京市自来水XXXXXX有限公司";
    _pulldownMenusV.textField.backgroundColor = [UIColor whiteColor];
    _pulldownMenusV.tv.backgroundColor = [UIColor whiteColor];
    _pulldownMenusV.layer.masksToBounds = YES;
    _pulldownMenusV.layer.cornerRadius = 5.0;
    [self addSubview:_pulldownMenusV];
    
    // 缴费账号
    self.accountNumber = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pulldownMenusV.frame), CGRectGetMaxY(_pulldownMenusV.frame) + 15, width, 50)];
    _accountNumber.backgroundColor = [UIColor whiteColor];
    _accountNumber.textAlignment = NSTextAlignmentCenter;
    _accountNumber.placeholder = @"请输入缴费号码";
    _accountNumber.layer.masksToBounds = YES;
    _accountNumber.layer.cornerRadius = 5.0;
    _accountNumber.returnKeyType = UIReturnKeyDone;
    _accountNumber.delegate = self;
    _accountNumber.clearsOnBeginEditing = YES;
    _accountNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_accountNumber];
    
    // 缴费金额
    self.paymentAmount = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pulldownMenusV.frame), CGRectGetMaxY(_accountNumber.frame) + 15, width, 50)];
    _paymentAmount.backgroundColor = [UIColor whiteColor];
    _paymentAmount.textAlignment = NSTextAlignmentCenter;
    _paymentAmount.placeholder = @"请输入缴费金额";
    _paymentAmount.layer.masksToBounds = YES;
    _paymentAmount.layer.cornerRadius = 5.0;
    _paymentAmount.returnKeyType = UIReturnKeyDone;
    _paymentAmount.delegate = self;
    _paymentAmount.clearsOnBeginEditing = YES;
    _paymentAmount.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview: _paymentAmount];
    
    
    // 缴费按钮
    self.payBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBUtton.frame = CGRectMake(CGRectGetMinX(_pulldownMenusV.frame), CGRectGetMaxY(_paymentAmount.frame) + 15, width, 40);
    [_payBUtton setTitle:@"缴费" forState:UIControlStateNormal];
    [_payBUtton setBackgroundImage:[UIImage imageNamed:@"jifei.png"] forState:UIControlStateNormal];
    _payBUtton.tag = 12300;
    [self addSubview:_payBUtton];
    
    // 取消界面其他第一响应链
    __weak WaterView *water = self;
    _pulldownMenusV.aBlock = ^() {
        [water.accountNumber resignFirstResponder];
        [water.paymentAmount resignFirstResponder];
    };
    
    
}

// 转化水费界面
- (void)didClickWaterAction:(UIButton *)sender
{
    _xuanZeImage.image = [UIImage imageNamed:@"xuanze.png"];
    _iocImage.image = [UIImage imageNamed:@"shui.png"];
    _pulldownMenusV.tableArray = _waterCompanyArray;
    _payBUtton.tag = 12300;
    _accountNumber.text = @"";
    _paymentAmount.text = @"";
    _pulldownMenusV.textField.text =  @"北京市自来水XXXXXX有限公司";
    [_pulldownMenusV clickOnTheOther];
}

// 转换电费界面
- (void)didClickElectricityAction:(UIButton *)sender
{
    _xuanZeImage.image = [UIImage imageNamed:@"xuanze-2.png"];
    _iocImage.image = [UIImage imageNamed:@"dian_"];
    _pulldownMenusV.tableArray = _electricityArray;
    _payBUtton.tag = 12301;
    _accountNumber.text = @"";
    _paymentAmount.text = @"";
    _pulldownMenusV.textField.text =  @"北京市电力XXXXXX有限公司";
    [_pulldownMenusV clickOnTheOther];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
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
    [_pulldownMenusV clickOnTheOther];
    return YES;
}

#pragma mark 创建缴费确认视图
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
    button.tag = 12305;
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
    button1.tag = 12306;
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
