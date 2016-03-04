//
//  WaterAndElectricityViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/30.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "WaterAndElectricityViewController.h"
#import "WaterView.h"
@interface WaterAndElectricityViewController ()

// 水电视图
@property (nonatomic, strong) WaterView *waterV;

@end

@implementation WaterAndElectricityViewController

- (void)loadView
{
    self.waterV = [[WaterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _waterV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"水电缴费";
    
    // 定位地址
    _waterV.positionLabel.text = @"北京";
    
    // 
    _waterV.waterCompanyArray = @[@"北京市自来水XXXXXX有限公司1",
                                  @"北京市自来水XXXXXX有限公司2",
                                  @"北京市自来水XXXXXX有限公司3",
                                  @"北京市自来水XXXXXX有限公司4",
                                  @"北京市自来水XXXXXX有限公司5"];
    _waterV.electricityArray = @[@"北京市电力XXXXXX有限公司1",
                                 @"北京市电力XXXXXX有限公司2",
                                 @"北京市电力XXXXXX有限公司3",
                                 @"北京市电力XXXXXX有限公司 4",
                                 @"北京市电力XXXXXX有限公司 5"];
    
    [self addAction];
    
}

#pragma mark 给 缴费按钮添加事件
- (void)addAction
{
    [_waterV.payBUtton addTarget:self action:@selector(didClickPayAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickPayAction:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 12300:
            NSLog(@"水费");
            [self.waterV createConfirmView]; // 创建缴费确认视图
            [self confirmAction]; // 给确认缴费按钮添加事件
            break;
        case 12301:
            NSLog(@"电费");
            [self.waterV createConfirmView]; // 创建缴费确认视图
            [self confirmAction]; // 给确认缴费按钮添加事件
            break;
            
        default:
            break;
    }
}

#pragma mark 给确认、取消缴费按钮添加事件
- (void)confirmAction
{
    for (int i = 12305 ; i < 12307; i++) {
        UIButton *button = [self.view viewWithTag:i];
        [button addTarget:self action:@selector(clickPayCost:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 点击缴费
- (void)clickPayCost:(UIButton *)sender
{
    switch (sender.tag) {
        case 12305: // 确认缴费
            
            [_waterV createCompleteView];
            
#warning 水电缴费账号假信息
            _waterV.nameLabel.text = @"许仙";
            _waterV.accountLabel.text = @"123456789";
            _waterV.accountBalanceLabel.text = @"125.00";
            _waterV.boLongBalanceLabel.text = @"350.02";
            [_waterV.confirmView removeFromSuperview];
            
            break;
            
        case 12306: // 取消缴费
            
            [_waterV.confirmView removeFromSuperview];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
