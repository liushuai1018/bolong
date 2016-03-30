//
//  WuYePayCostViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "WuYePayCostViewController.h"
#import "WuYePayCostView.h"
#import "WuYeDetails.h"
#import "HousingAddress.h"

@interface WuYePayCostViewController ()

@property (strong, nonatomic) WuYePayCostView *wuyePayCostView;

@end

@implementation WuYePayCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self createrView];
    [self setBlock];
}

#pragma mark - 界面显示信息赋值
- (void)viewWillAppear:(BOOL)animated
{
    _wuyePayCostView.name.text = [NSString stringWithFormat:@"姓名:%@", _wuye.name];
    _wuyePayCostView.number.text = [NSString stringWithFormat:@"身份证:%@", _wuye.number];
    
    NSMutableArray *array = [NSMutableArray array];
    for (HousingAddress *address in _wuye.addressList) {
        [array addObject:[NSString stringWithFormat:@"地址:%@",address.address]];
    }
    _wuyePayCostView.pulldownMenus.textField.placeholder = @"地址:选择缴纳的房屋";
    _wuyePayCostView.pulldownMenus.tableArray = array;
    _wuyePayCostView.paymentDetails.text = @"详情:物业费每平方米按2.2元收取";
    _wuyePayCostView.totalFee.text = [NSString stringWithFormat:@"总计:%.2f", _wuye.total_price];
    
}

#pragma mark - 创建 SubView
- (void)createrView
{
    self.wuyePayCostView = [[WuYePayCostView alloc] initWithFrame:self.view.bounds];
    
    self.view = _wuyePayCostView;
}

#pragma mark - 设置block
- (void)setBlock
{
    _wuyePayCostView.block = ^(){
        
        NSLog(@"确认支付物业费");
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
