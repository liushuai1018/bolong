//
//  LS_addNewAddress_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_addNewAddress_ViewController.h"
#import "LS_selectRegion_TableViewController.h"
#import "LS_addressManage.h"

@interface LS_addNewAddress_ViewController () <UITextFieldDelegate, UITextViewDelegate>

// 姓名
@property (weak, nonatomic) IBOutlet UITextField *name;

// 手机号
@property (weak, nonatomic) IBOutlet UITextField *mobile;

// 所在地区
@property (weak, nonatomic) IBOutlet UILabel *region;

// 街道
@property (weak, nonatomic) IBOutlet UITextField *street;

// 详细地址
@property (weak, nonatomic) IBOutlet UITextView *full_address;

// 记录是否设置为默认地址
@property (assign, nonatomic) BOOL LS_default;

// 设置默认地址按钮
@property (weak, nonatomic) IBOutlet UISwitch *default_switch;

// 设置为是添加新地址还是 修改原有地址
@property (assign, nonatomic) BOOL judge;

@end

@implementation LS_addNewAddress_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加新地址";
    
    [self addItem];
    [self setKeyboadrd];
    _judge = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_modeifyAddress) {  // 如果 modeify_address 有值则代表这是在修改原有地址
        self.title = @"修改收货地址";
        _name.text = _modeifyAddress.name;
        _mobile.text = _modeifyAddress.mobile;
        _region.text = _modeifyAddress.region;
        _street.text = _modeifyAddress.street;
        _full_address.text = _modeifyAddress.full_address;
        _default_switch.on = _modeifyAddress.LS_default ? YES : NO;
        
        // No 是修改原有地址
        _judge = NO;
    }
}

#pragma mark - addItem
- (void)addItem
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

// 左边
- (void)leftAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 右边
- (void)rightAction:(UIBarButtonItem *)item
{
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    LS_addressManage *address = [[LS_addressManage alloc] init];
    address.name = _name.text;
    address.mobile = _mobile.text;
    address.code = @"100000";
    address.province = @"北京";
    address.city = @"北京";
    address.region = _region.text;
    address.street = _street.text;
    address.full_address = _full_address.text;
    address.LS_default = _LS_default;
    
    BOOL name_Is = [_name.text isEqualToString:@""];
    BOOL mobile_Is = [_mobile.text isEqualToString:@""];
    BOOL region_Is = [_region.text isEqualToString:@""];
    BOOL street_Is = [_street.text isEqualToString:@""];
    
    if (!name_Is && !mobile_Is && !region_Is && !street_Is) {
        
        if (_judge) { // YES 代表是创建新地址
//            NSLog(@"----添加新的地址----");
            [[NetWorkRequestManage sharInstance] addNewAddressUser_id:userInfo.user_id full_address:address];
        } else { // NO 代理修改原有地址
            
            address.address_id = _modeifyAddress.address_id;
//            NSLog(@"----修改原有地址----");
            [[NetWorkRequestManage sharInstance] upAddressUser_id:userInfo.user_id address:address];
        }
        
        
        // 把新地址发送到管理界面
        if (self.sendNewAddress) {
            self.sendNewAddress(address);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"信息请填写完整"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

#pragma mark - 设置键盘
- (void)setKeyboadrd
{
    _name.delegate = self;
    _mobile.delegate = self;
    _street.delegate = self;
    _full_address.delegate = self;
}

#pragma mark - 选择所在地区
- (IBAction)selectRegion:(UIButton *)sender {
    LS_selectRegion_TableViewController *selectRegion = [[LS_selectRegion_TableViewController alloc] init];
    
    __weak LS_addNewAddress_ViewController *control = self;
    selectRegion.block = ^(NSString *str) {
        control.region.text = str;
    };
    
    [self.navigationController pushViewController:selectRegion animated:YES];  
}

#pragma mark - 设置为默认地址
- (IBAction)setAddress:(UISwitch *)sender {
    
    NSString *is = sender.isOn ? @"YES" : @"NO";
    if ([is isEqualToString:@"YES"]) {
        _LS_default = YES;
    } else {
        _LS_default = NO;
    }
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
