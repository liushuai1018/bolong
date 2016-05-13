//
//  LS_ParkingRootViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/15.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_ParkingRootViewController.h"
#import "PresenceOfparkingViewController.h"
#import "SurroundTableViewController.h"
#import "ConsultRootViewController.h"

@interface LS_ParkingRootViewController ()
{
    PresenceOfparkingViewController *_presence;  // 占道停车
    SurroundTableViewController *_surround;      // 周边
    ConsultRootViewController *_consultRoot;     // 停车咨询
    
    // 记录其他按钮是否显示
    BOOL _otherShow;
    // 其他按钮子视图
    UIView *_otherView;
}

@property (weak, nonatomic) IBOutlet UIButton *otherBut;


@end

@implementation LS_ParkingRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self replaceLeftBarButton];
    _otherShow = NO;
    [self createrOtherSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSet
- (void)initSet
{
    self.title = @"停车";
    self.navigationController.navigationBar.translucent = NO;
    
}

#pragma mark - 设置 返回键
- (void)replaceLeftBarButton
{
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
}
// 自定义左边BarBUtton事件
- (void)didClickLeftAction:(UIBarButtonItem *)bar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 占道停车
- (IBAction)parkingAction:(UIButton *)sender {
    _presence = [[PresenceOfparkingViewController alloc] init];
    [self.navigationController pushViewController:_presence animated:YES];
}

#pragma mark - 商业停车
- (IBAction)businessAction:(UIButton *)sender {
}

#pragma mark - 社区停车
- (IBAction)communityAction:(UIButton *)sender {
}

#pragma mark - 其他
- (IBAction)otherAction:(UIButton *)sender {
    if (_otherShow) {
        _otherShow = NO;
        [sender setImage:[UIImage imageNamed:@"new_tingche_other1"] forState:UIControlStateNormal];
        [_otherView setHidden:YES];
    } else {
        
        _otherView.frame = CGRectMake(0, CGRectGetMinY(sender.frame) - CGRectGetHeight(_otherView.frame), CGRectGetWidth(_otherView.frame), CGRectGetHeight(_otherView.frame));
        _otherShow = YES;
        [sender setImage:[UIImage imageNamed:@"new_tingche_other2"] forState:UIControlStateNormal];
        [self.view bringSubviewToFront:_otherView];
        [_otherView setHidden:NO];
    }
    
}

#pragma mark - 其他按钮子视图
- (void)createrOtherSubView
{
    // 背景
    _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) * 0.57, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) * 0.23)];
    _otherView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_otherView];
    
    // 周边
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(_otherView.frame), CGRectGetHeight(_otherView.frame) * 0.5);
    [button setImage:[UIImage imageNamed:@"new_zhoubian"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(surroundAction:) forControlEvents:UIControlEventTouchUpInside];
    [_otherView addSubview:button];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(button.frame), CGRectGetWidth(button.frame) - 60, 1)];
    view.backgroundColor = [UIColor blackColor];
    [_otherView addSubview:view];
    
    // 咨询
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
    [button1 setImage:[UIImage imageNamed:@"new_tingche_zixun"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(consultAction:) forControlEvents:UIControlEventTouchUpInside];
    [_otherView addSubview:button1];
    
    [_otherView setHidden:YES];
}

#pragma mark - 周边
- (void)surroundAction:(UIButton *)sender
{
    _surround = [[SurroundTableViewController alloc] init];
    [self.navigationController pushViewController:_surround animated:YES];
    [self hiddenOtheBut];
}

#pragma mark - 咨询
- (void)consultAction:(UIButton *)sender
{
    _consultRoot = [[ConsultRootViewController alloc] init];
    [self.navigationController pushViewController:_consultRoot animated:YES];
    [self hiddenOtheBut];
}

#pragma mark - 隐藏其他按钮
- (void)hiddenOtheBut
{
    [_otherBut setImage:[UIImage imageNamed:@"new_tingche_other1"] forState:UIControlStateNormal];
    _otherShow = NO;
    [_otherView setHidden:YES];
}

@end
