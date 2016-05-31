//
//  LS_Other_Water_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_Water_ViewController.h"

@interface LS_Other_Water_ViewController () <UITextFieldDelegate>
//  每桶价格
@property (weak, nonatomic) IBOutlet UILabel *price;

//  地址
@property (weak, nonatomic) IBOutlet UITextField *address;

//  数量
@property (weak, nonatomic) IBOutlet UITextField *number;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *price_Y;

// 每桶单价
@property (assign, nonatomic) CGFloat priceMoney;

@end

@implementation LS_Other_Water_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"送水";
    [self initData];
}

#pragma mark - dat
- (void)initData
{
    NSString *pice = [[NetWorkRequestManage sharInstance] other_WaterMoney];
    _price.text = [NSString stringWithFormat:@"每桶: %@元", pice];
    _priceMoney = [pice floatValue];
}

#pragma mark - 送水支付事件
- (IBAction)songShui_pay:(UIButton *)sender {
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    NSString *totalPrice = [NSString stringWithFormat:@"%.2f", [_number.text integerValue] * _priceMoney];
    
    [[NetWorkRequestManage sharInstance] other_waterAddress:_address.text
                                                      momey:totalPrice
                                                   userInfo:userInfo];
    
}

#pragma mark - textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _price_Y.constant = - 216;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _price_Y.constant = 0;
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_address resignFirstResponder];
    [_number resignFirstResponder];
    _price_Y.constant = 0;
}

@end
