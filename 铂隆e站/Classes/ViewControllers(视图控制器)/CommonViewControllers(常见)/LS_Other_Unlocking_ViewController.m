//
//  LS_Other_Unlocking_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/27.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_Unlocking_ViewController.h"

@interface LS_Other_Unlocking_ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_buttom;

// 用户地址
@property (weak, nonatomic) IBOutlet UITextView *addressInfo;
@end

@implementation LS_Other_Unlocking_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开锁";
    
    [self initTextView];
}

#pragma mark - initTextView
- (void)initTextView
{
    _addressInfo.delegate = self;
    _addressInfo.layer.borderWidth = 0.5;
    _addressInfo.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 求助按钮监听事件
- (IBAction)buttonAction:(UIButton *)sender {
    BOOL is = [_addressInfo.text isEqualToString:@"请输入详细地址如：xx小区xx号楼xx单元xx室"];
    BOOL is1 = [_addressInfo.text isEqualToString:@""];
    
    if (is || is1) {
        [self alertControl];
        return;
    }
    
    // 修饰成弱引用
    __weak LS_Other_Unlocking_ViewController *wea_control = self;
    [[NetWorkRequestManage sharInstance] other_UnlockingAddress:_addressInfo.text
                                                         returns:^(NSString *phone)
    {
        // 转换成强引用
        LS_Other_Unlocking_ViewController *string_control = wea_control;
        // 判断是否被释放
        if (string_control) {
            [string_control callPhonenumber:phone];
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
- (void)alertControl
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"地址不能为空"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
