//
//  LS_Other_Water_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_Water_ViewController.h"

#import "SelectAVillageTableViewController.h"
#import "LS_WuYeInform_Model.h"

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

// 选择物业
@property (weak, nonatomic) IBOutlet UIButton *selectWuye;

// 所有物业
@property (copy, nonatomic) NSArray *dataAr;

// 选择的物业
@property (strong, nonatomic) LS_WuYeInform_Model *model;

@end

@implementation LS_Other_Water_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"送水";
    [self initData];
}

#pragma mark - data
- (void)initData
{
    [[NetWorkRequestManage sharInstance] other_WaterMoneyWithPrice:^(NSString *price) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _price.text = [NSString stringWithFormat:@"每桶: %@元", price];
            _priceMoney = [price floatValue];
        });
    }];
    
    __weak LS_Other_Water_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] getWuYeRetuns:^(NSArray *array) {
        weak_control.dataAr = array;
    }];
}

#pragma mark - 选择物业公司
- (IBAction)selectWuYe:(UIButton *)sender {
    SelectAVillageTableViewController *control = [[SelectAVillageTableViewController alloc] init];
    control.wuyeAr = _dataAr;
    __weak LS_Other_Water_ViewController *weak_control = self;
    control.wuyeBlock = ^(LS_WuYeInform_Model *model) {
        weak_control.model = model;
        [weak_control.selectWuye setTitle:model.fenqu forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 送水支付事件
- (IBAction)songShui_pay:(UIButton *)sender {
    
    if (!_model) {
        [self createrAlertControlWithTitle:@"选择物业公司!"];
        return;
    }
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    NSString *address = _address.text;
    if ([address isEqualToString:@""]) {
        [self createrAlertControlWithTitle:@"请输入地址"];
        return;
    }
    if ([_number.text isEqualToString:@""]) {
        [self createrAlertControlWithTitle:@"请输入购买数量"];
        return;
    }
    NSString *totalPrice = [NSString stringWithFormat:@"%.2f", [_number.text integerValue] * _priceMoney];
    
    [[NetWorkRequestManage sharInstance] other_waterWithWuYeId:_model.wuyeID
                                                       Address:address
                                                         momey:totalPrice
                                                      userInfo:userInfo.user_id];
    
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

- (void)createrAlertControlWithTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
