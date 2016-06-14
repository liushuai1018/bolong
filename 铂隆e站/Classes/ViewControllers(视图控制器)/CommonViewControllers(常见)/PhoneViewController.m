//
//  PhoneViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/29.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "PhoneViewController.h"
#import "PhoneView.h"
@interface PhoneViewController ()

@property (nonatomic, strong) PhoneView *phoneV; // 手机充费视图

@end

@implementation PhoneViewController

- (void)loadView
{
    _phoneV = [[PhoneView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _phoneV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机充值";
    self.navigationController.navigationBar.translucent = NO;
    
    
    [self addAction];
    [self createrBatItem];
}

#pragma mark - 创建
- (void)createrBatItem
{
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemAction:)];
    self.navigationItem.leftBarButtonItem = leftBut;
}

- (void)barItemAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 添加按钮事件
- (void)addAction
{
    for (int i = 11200; i < 11206; i++) {
        UIButton *but = [self.view viewWithTag:i];
        
        [but addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 初始化费用按钮都不可点击
    [_phoneV butUserInteractionEnabled:NO];
}

- (void)didClickAction:(UIButton *)but
{
    
    // 收回键盘
    [_phoneV.phoneNumber resignFirstResponder];
    
    switch (but.tag) {
            
        case 11200:
            [self alertViewWithString:10 actualName:9.96];
            break;
            
        case 11201:
            [self alertViewWithString:20 actualName:19.95];
            break;
            
        case 11202:
            [self alertViewWithString:30 actualName:19.97];
            break;
            
        case 11203:
            [self alertViewWithString:50 actualName:49.96];
            break;
            
        case 11204:
            [self alertViewWithString:100 actualName:99.90];
            break;
            
        case 11205:
//            NSLog(@"其他");
            break;
            
        default:
            break;
    }
}

/**
 *  缴费提示框
 *
 *  @param index  选择缴费金额
 *  @param actual 实际缴费金额
 */
- (void)alertViewWithString:(NSInteger)index actualName:(CGFloat)actual
{
    NSString *string = [NSString stringWithFormat:@"充值话费: %ld", (long)index];
    UIAlertController *alertC = nil;
    alertC = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消话费充值
    }];
    [alertC addAction:cancelAction];
    
    [alertC addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning mark 确定充值话费.
            
            // 手机号
            NSString *phone = _phoneV.phoneNumber.text;
            if (phone.length == 11) {
                
                // 剩余铂隆币
                CGFloat surplus = [_remaining floatValue] - actual;
                [_phoneV createWarningViewWithInt:index actualNumber:actual currentNumber:_remaining surplusNumber:surplus phone:phone];
            }
            
        }];
        action;
    })];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
