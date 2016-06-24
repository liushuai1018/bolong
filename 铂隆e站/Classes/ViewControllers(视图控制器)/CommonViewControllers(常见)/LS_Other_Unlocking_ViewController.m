//
//  LS_Other_Unlocking_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/27.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_Unlocking_ViewController.h"
#import "SelectAVillageTableViewController.h"
#import "LS_WuYeInform_Model.h"

@interface LS_Other_Unlocking_ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_buttom;

// 用户地址
@property (weak, nonatomic) IBOutlet UITextView *addressInfo;

// 选择物业
@property (weak, nonatomic) IBOutlet UIButton *wuYe;

// 所有物业
@property (copy, nonatomic) NSArray *dataAr;

// 选择的物业
@property (strong, nonatomic) LS_WuYeInform_Model *model;

@end

@implementation LS_Other_Unlocking_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开锁";
    
    [self initData];
    [self initTextView];
}

#pragma mark - initTextView
- (void)initTextView
{
    _addressInfo.delegate = self;
    _addressInfo.layer.borderWidth = 0.5;
    _addressInfo.layer.borderColor = [UIColor blackColor].CGColor;
}

#pragma mark - initData
- (void)initData {
    
    __weak LS_Other_Unlocking_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] getWuYeRetuns:^(NSArray *array) {
        weak_control.dataAr = array;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择物业
- (IBAction)selectWuYe:(UIButton *)sender {
    SelectAVillageTableViewController *control = [[SelectAVillageTableViewController alloc] init];
    control.wuyeAr = _dataAr;
    __weak LS_Other_Unlocking_ViewController *weak_control = self;
    control.wuyeBlock = ^(LS_WuYeInform_Model *model) {
        weak_control.model = model;
        [weak_control.wuYe setTitle:model.fenqu forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 求助按钮监听事件
- (IBAction)buttonAction:(UIButton *)sender {
    
    if (!_model) {
        [self alertControlTitle:@"请选择物业公司!"];
        return;
    }
    
    BOOL is = [_addressInfo.text isEqualToString:@"请输入详细地址如：xx小区xx号楼xx单元xx室"];
    BOOL is1 = [_addressInfo.text isEqualToString:@""];
    
    if (is || is1) {
        [self alertControlTitle:@"请填写详细地址!"];
        return;
    }
    
    // 修饰成弱引用
    __weak LS_Other_Unlocking_ViewController *wea_control = self;
    [[NetWorkRequestManage sharInstance] other_UnlockingAddress:_addressInfo.text
                                                         wuYeID:_model.wuyeID
                                                         returns:^(NSString *phone)
    {
        // 转换成强引用
        LS_Other_Unlocking_ViewController *string_control = wea_control;
        // 判断是否被释放
        if (string_control) {
            if ([phone isEqualToString:@"求助失败!"]) {
                [string_control alertControlTitle:phone];
            } else {
                [string_control callPhonenumber:phone];
            }
        }
    }];
}

// 调用电话
- (void)callPhonenumber:(NSString *)phone
{
    
    NSString *parameter = [NSString stringWithFormat:@"tel://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parameter]];
}

#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = nil;
    
    __weak LS_Other_Unlocking_ViewController *control = self;
    [UIView animateWithDuration:2.5 animations:^{
        control.view_buttom.constant = 250;
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

 - (void)textViewDidEndEditing:(UITextView *)textView
{
    __weak LS_Other_Unlocking_ViewController *control = self;
    [UIView animateWithDuration:2.5 animations:^{
        control.view_buttom.constant = 10;
    }];
}


#pragma mark - 提示框
- (void)alertControlTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
