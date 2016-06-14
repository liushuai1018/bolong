//
//  HeatingViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "HeatingViewController.h"
#import "HeatingView.h"
@interface HeatingViewController ()

@property (nonatomic, strong) HeatingView *heatV;

@end

@implementation HeatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"暖气缴费";
    [self createrView];
    [self initializeTheSet]; // 初始化设置
    [self addPayEvent]; // 添加缴费按钮事件
}

#pragma mark - 创建View
- (void)createrView
{
    self.heatV = [[HeatingView alloc] initWithFrame:self.view.bounds];
    self.view = _heatV;
}

// 初始化设置
- (void)initializeTheSet
{
    _heatV.iocImage.image = [UIImage imageNamed:@"nuanqi_iOC.png"];
    _heatV.pulldownMenusV.textField.text = @"北京市暖气XXXXX有限公司";
    _heatV.pulldownMenusV.tableArray = @[@"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司", @"北京市暖气XXXXX有限公司"];
}

#pragma mark 添加缴费按钮事件
- (void)addPayEvent
{
    [_heatV.payBUtton addTarget:self action:@selector(clickPayEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickPayEvent:(UIButton *)sender
{
    // 取消输入框的第一响应链
    [_heatV LSResignFirstResponder];
    
    [_heatV createConfirmView];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [_heatV.confirmView viewWithTag:i + 12500];
        [button addTarget:self action:@selector(clickWhetherOrNotPay:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 点击是否缴费
- (void)clickWhetherOrNotPay:(UIButton *)sender
{
    
    
    switch (sender.tag) {
        case 12500:
            [_heatV createCompleteView];
#warning mark 假数据
            _heatV.nameLabel.text = @"白娘子";
            _heatV.accountLabel.text = @"1234567890";
            _heatV.accountBalanceLabel.text = @"235.00";
            _heatV.boLongBalanceLabel.text = @"300.02";
            [_heatV.confirmView removeFromSuperview];
            
            break;
        case 12501:
            [_heatV.confirmView removeFromSuperview];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    CGFloat tableViewHeight = _heatV.frame.size.height - height;
    
    // 获取键盘弹出动画的时间
    double duration = [[info.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        _heatV.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeight);
        _heatV.scrollView.contentSize = CGSizeMake(_heatV.frame.size.width, _heatV.frame.size.height);
    }];
    
    
}

#pragma mark - 监听键盘的收回
- (void)keyboardWillHide:(NSNotification *)infor
{
    double duraction = [[infor.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duraction animations:^{
        _heatV.scrollView.frame = CGRectMake(0, 0, _heatV.frame.size.width, _heatV.frame.size.height);
        _heatV.scrollView.contentSize = CGSizeMake(_heatV.frame.size.width, _heatV.frame.size.height);
    }];
}

@end
