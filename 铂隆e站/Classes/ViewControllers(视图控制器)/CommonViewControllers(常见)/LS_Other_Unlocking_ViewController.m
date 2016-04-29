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
    
    NSLog(@"textView =========== %@", _addressInfo.text);
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

@end
