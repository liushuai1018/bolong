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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"水电缴费";
    [self createrView];
    
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

#pragma mark - 创建自定义视图
- (void)createrView
{
    self.waterV = [[WaterView alloc] initWithFrame:self.view.bounds];
    self.view = _waterV;
}

#pragma mark 给 缴费按钮添加事件
- (void)addAction
{
    [_waterV.payBUtton addTarget:self action:@selector(didClickPayAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickPayAction:(UIButton *)sender
{
    [_waterV LSResignFirstResponder];
    
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

#pragma mark - 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 注册键盘推出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // 注册键盘回收通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    NSLog(@"注册监控键盘");
}
#pragma mark - 视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // remove通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    NSLog(@"注销监控键盘");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 监听键盘的弹出
- (void)keyboardWillShow:(NSNotification *)info
{
    // 获取键盘高度
    CGFloat height = [[info.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    /*
     *  在弹出键盘的状态下再次修改输入的类型 会再次减去键盘的高度，导致tableView下面一大块空白
     */
    
    // 获取键盘的顶端到导航栏下部的高
    CGFloat tableViewHeight = _waterV.frame.size.height - height;
    
    // 获取键盘弹出动画的时间
    double duration = [[info.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        _waterV.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeight);
        _waterV.scrollView.contentSize = CGSizeMake(_waterV.frame.size.width, _waterV.frame.size.height);
    }];
    
    
}

#pragma mark - 监听键盘的收回
- (void)keyboardWillHide:(NSNotification *)infor
{
    double duraction = [[infor.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duraction animations:^{
        _waterV.scrollView.frame = CGRectMake(0, 0, _waterV.frame.size.width, _waterV.frame.size.height);
        _waterV.scrollView.contentSize = CGSizeMake(_waterV.frame.size.width, _waterV.frame.size.height);
    }];
}

@end
