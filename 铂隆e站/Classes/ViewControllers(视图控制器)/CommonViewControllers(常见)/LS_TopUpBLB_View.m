//
//  LS_TopUpBLB_View.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_TopUpBLB_View.h"
#import "LS_Rotation_View.h"

@implementation LS_TopUpBLB_View

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
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame) - 64;
    
    _balance = [[UILabel alloc] initWithFrame:CGRectMake(0, height * 0.05, width, height * 0.1)];
    _balance.textColor = [UIColor colorWithRed:0.95 green:0.73 blue:0.24 alpha:1.0];
    _balance.textAlignment = NSTextAlignmentCenter;
    _balance.font = [UIFont systemFontOfSize:20.0];
    _balance.text = @"余额:  0";
    [self addSubview:_balance];
    
    // 背景
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height * 0.2, width, height * 0.7)];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1.0];
    view.tag = 12360;
    [self addSubview:view];
    
    // 大圆
    LS_Rotation_View *view1 = [[LS_Rotation_View alloc] initWithFrame:CGRectMake(0, 0, width - 40, width - 40)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.center = view.center;
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = CGRectGetWidth(view1.frame) * 0.5;
    [self addSubview:view1];
    
    __weak LS_TopUpBLB_View *selfs = self;
    view1.block = ^(NSInteger index) {
        [selfs pointingLabel:index];
    };
    
    
    NSArray *titleArray = @[@"250\n铂隆币",
                            @"200\n铂隆币",
                            @"150\n铂隆币",
                            @"100\n铂隆币",
                            @"其他\n铂隆币",
                            @"500\n铂隆币",
                            @"400\n铂隆币",
                            @"300\n铂隆币"
                            ];
    
    // 添加八个子view
    for (int i = 0; i < 8; i++) {
        UILabel *view3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        view3.text = [titleArray objectAtIndex:i];
        view3.textAlignment = NSTextAlignmentCenter;
        view3.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.76 alpha:1.0];
        view3.font = [UIFont systemFontOfSize:12];
        view3.layer.masksToBounds = YES;
        view3.layer.cornerRadius = 10;
        view3.numberOfLines = 2;
        view3.tag = 12350 + i;
        
        [view1 addSubview:view3];
        
        CGFloat x = CGRectGetWidth(view1.frame) * 0.5 + CGRectGetWidth(view1.frame) * 0.4 * sin(M_PI_4 * i);
        CGFloat y = CGRectGetWidth(view1.frame) * 0.5 + CGRectGetWidth(view1.frame) * 0.4 * cos(M_PI_4 * i);
        
        view3.center = CGPointMake(x, y);
        
        if (7 == i) {
            view3.textColor = [UIColor colorWithRed:0.95 green:0.73 blue:0.24 alpha:1.0];
        }
    }
    
    // 小圆
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view1.frame) * 0.6, CGRectGetWidth(view1.frame) * 0.6)];
    backgroundImage.center = view.center;
    backgroundImage.image = [UIImage imageNamed:@"LS_chongz_background"];
    backgroundImage.userInteractionEnabled = YES;
    backgroundImage.tag = 12359;
    [self addSubview:backgroundImage];
    // 提示文字
    _show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view1.frame) * 0.55, CGRectGetWidth(view1.frame) * 0.55)];
    _show.center = view.center;
    _show.textColor = [UIColor colorWithRed:0.95 green:0.73 blue:0.24 alpha:1.0];
    _show.textAlignment = NSTextAlignmentCenter;
    _show.font = [UIFont systemFontOfSize:25];
    _show.text = @"30¥";
    [self addSubview:_show];
    
    // 输入金额
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_show.frame), 20)];
    _textField.center = view.center;
    _textField.textColor = [UIColor colorWithRed:0.95 green:0.73 blue:0.24 alpha:1.0];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.placeholder = @"请输入金额";
    _textField.hidden = YES;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_textField];
    
    // 指针
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    imageView.image = [UIImage imageNamed:@"LS_chongzhi_zhizhen"];
    CGFloat x = CGRectGetMidX([_show bounds]) + CGRectGetMaxX([_show bounds]) * 0.43 * sin(M_PI_4 * 7);
    CGFloat y = CGRectGetMidY([_show bounds]) + CGRectGetMaxY([_show bounds]) * 0.43 * cos(M_PI_4 * 7);
    imageView.center = CGPointMake(x, y);
    [backgroundImage addSubview:imageView];
    
    // 购买
    _purchase = [UIButton buttonWithType:UIButtonTypeCustom];
    _purchase.frame = CGRectMake(0, height * 0.9, width, height * 0.1);
    [_purchase setTitle:@"购买" forState:UIControlStateNormal];
    [_purchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_purchase setBackgroundColor:[UIColor blackColor]];
    [self addSubview:_purchase];
    
}

#pragma mark - 指针指向那个一个Label
- (void)pointingLabel:(NSInteger)index
{
    _show.hidden = NO;
    _textField.hidden = YES;
    
    switch (index) {
        case 12350:{
            _show.text = @"25¥";
            break;
        }
        case 12351:{
            _show.text = @"20¥";
            break;
        }
        case 12352:{
            _show.text = @"15¥";
            break;
        }
        case 12353:{
            _show.text = @"10¥";
            break;
        }
        case 12354:{
            _show.hidden = YES;
            _textField.hidden = NO;
            break;
        }
        case 12355:{
            _show.text = @"50¥";
            break;
        }
        case 12356:{
            _show.text = @"40¥";
            break;
        }
        case 12357:{
            _show.text = @"30¥";
            break;
        }
        default:
            break;
    }
    
    if (self.block) {
        self.block(index - 12350);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

@end
