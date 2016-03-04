//
//  LonginView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/3.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "LonginView.h"

@implementation LonginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatorAllSubView];
    }
    return self;
}

// 创建子控件
- (void)creatorAllSubView
{
    self.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.0];
    
    // 头像背景图
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3)];
    backgroundImage.image = [UIImage imageNamed:@"toubeijing.png"];
    [self addSubview:backgroundImage];
    
    // 头像
    UIImageView *headPortraitImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang.jpg"]];
    headPortraitImage.frame = CGRectMake(0, 0, 90, 90);
    headPortraitImage.center = CGPointMake(CGRectGetWidth(backgroundImage.frame) / 2, CGRectGetHeight(backgroundImage.frame) / 2 + 25);
    headPortraitImage.layer.masksToBounds = YES; // 显示圆角
    headPortraitImage.layer.cornerRadius = 45.0; // 设置弧度
    headPortraitImage.layer.borderWidth = 2.0; // 圆边宽度
    headPortraitImage.layer.borderColor = [UIColor whiteColor].CGColor; // 圆边颜色
    [backgroundImage addSubview:headPortraitImage];
    
    // 输入框
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backgroundImage.frame), SCREEN_WIDTH, SCREEN_HEIGHT * 0.18)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    
    
    // 用户名
    self.userNameText = [[UITextField alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH - 60, 35)];
    _userNameText.backgroundColor = [UIColor whiteColor];
    _userNameText.borderStyle = UITextBorderStyleNone;
    _userNameText.placeholder = @"   请输入账号";
    _userNameText.returnKeyType = UIReturnKeyNext; // 键盘带一个Next按钮，进入下一个输入框
    _userNameText.clearButtonMode = UITextFieldViewModeWhileEditing; // 清空按钮
    _userNameText.keyboardType = UIKeyboardTypeASCIICapable;
    _userNameText.delegate = self;
    _userNameText.tag = 12000;
    [backgroundView addSubview:_userNameText];
    // 左侧图片
    _userNameText.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanghao.png"]];
    image.frame = CGRectMake(0, 0, 20, 25);
    _userNameText.leftView = image;
    
    
    // 分割线
    UIView *segmentationView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userNameText.frame), CGRectGetHeight(backgroundView.frame) * 0.5, CGRectGetWidth(_userNameText.frame), 1)];
    segmentationView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:segmentationView];
    
    
    // 密码
    self.passwordText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userNameText.frame), CGRectGetHeight(backgroundView.frame) - 45, CGRectGetWidth(_userNameText.frame), CGRectGetHeight(_userNameText.frame))];
    _passwordText.backgroundColor = [UIColor whiteColor];
    _passwordText.borderStyle = UITextBorderStyleNone;
    _passwordText.placeholder = @"   请输入密码";
    _passwordText.clearsOnBeginEditing = YES; // 再次输入清空内容
    _passwordText.secureTextEntry = YES; // 密码以圆点形式显示
    _passwordText.clearButtonMode = UITextFieldViewModeWhileEditing; // 清空按钮
    _passwordText.returnKeyType = UIReturnKeyRoute;
    _passwordText.delegate = self;
    _passwordText.tag = 12001;
    [backgroundView addSubview:_passwordText];
    // 左侧图片
    _passwordText.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *padImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima.png"]];
    padImage.frame = CGRectMake(0, 0, 20, 25);
    _passwordText.leftView = padImage;
    
    
    // 密码错误提示框
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(backgroundView.frame), CGRectGetWidth(_userNameText.frame), 21)];
    [self addSubview:_promptLabel];
    
    // 登陆按钮
    self.longBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _longBut.frame = CGRectMake(CGRectGetMinX(_userNameText.frame), CGRectGetMaxY(_promptLabel.frame) + 5, CGRectGetWidth(_userNameText.frame), 50);
    [_longBut setImage:[UIImage imageNamed:@"anniu-1.png"] forState:UIControlStateNormal];
    [self addSubview:_longBut];
    
    
    // 注册按钮
    self.registeredBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _registeredBut.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 25, CGRectGetMaxY(_longBut.frame) + 10, 60, 30);
    [_registeredBut setTitle:@"注册" forState:UIControlStateNormal];
    [_registeredBut setTintColor:[UIColor grayColor]];
    [self addSubview:_registeredBut];
    
    // 第三方登陆按钮
    self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_registeredBut.frame) - 9, CGRectGetMaxY(_registeredBut.frame) + 30, 80, 30)];
    _thirdLabel.text = @"第三方登陆";
    _thirdLabel.textColor = [UIColor grayColor];
    _thirdLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_thirdLabel];
    
    // 微信
    self.weiXinBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _weiXinBut.frame = CGRectMake( CGRectGetMinX(_userNameText.frame) + 20, CGRectGetMaxY(_thirdLabel.frame) + 20, 48, 48);
    [_weiXinBut setImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
    [self addSubview:_weiXinBut];
    
    // 微博
    self.weiBoBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _weiBoBut.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 25, CGRectGetMinY(_weiXinBut.frame), 50, 50);
    [_weiBoBut setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
    [self addSubview:_weiBoBut];
    
    // QQ
    self.qqBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _qqBut.frame = CGRectMake(CGRectGetMaxX(_userNameText.frame) - 68, CGRectGetMinY(_weiXinBut.frame), 48, 48);
    [_qqBut setImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
    [self addSubview:_qqBut];
    
    
    /*
    // 判断是否安装某些程序
    NSURL *qqURL = [NSURL URLWithString:@"mqq://"];
    NSURL *weixinURL = [NSURL URLWithString:@"weixin://"];
    NSURL *weiboURL = [NSURL URLWithString:@"sinaweibo://"];
    BOOL isQQ = [[UIApplication sharedApplication] canOpenURL:qqURL];
    BOOL isWeiXin = [[UIApplication sharedApplication] canOpenURL:weixinURL];
    BOOL isWeiBo = [[UIApplication sharedApplication] canOpenURL:weiboURL];
    NSLog(@"qq == %d", isQQ);
    NSLog(@"weixin == %d", isWeiXin);
    NSLog(@"weibo == %d", isWeiBo);
    */
}

// 点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_userNameText resignFirstResponder];
    [_passwordText resignFirstResponder];
}

// Return 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 判断那个输入框
    if (12000 == textField.tag) {
        [_passwordText becomeFirstResponder];
    } else {
        
        [textField resignFirstResponder];
    }
    return YES;
}

@end

