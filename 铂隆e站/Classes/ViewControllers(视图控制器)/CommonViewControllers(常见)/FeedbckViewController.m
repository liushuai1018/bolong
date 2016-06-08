//
//  FeedbckViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/14.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "FeedbckViewController.h"
#import "FeedbckView.h"
@interface FeedbckViewController ()

@property (nonatomic, strong) FeedbckView *feedbckView;

@end

@implementation FeedbckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"意见反馈";
    
    
    [self createrSubView];
    // 添加左边按钮
    [self addleftBarButton];
}

#pragma mark - 创建View
- (void)createrSubView
{
    self.feedbckView = [[FeedbckView alloc] initWithFrame:self.view.bounds];
    self.view = _feedbckView;
    
    // 添加事件
    [_feedbckView.submitBtn addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 添加左边barButton
- (void)addleftBarButton
{
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

// 左边BarButton
- (void)didClickLeftAction:(UIBarButtonItem *)but
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickAction:(UIButton *)but
{
    NSString *opinion = _feedbckView.opinionTF.text;
    if ([opinion isEqualToString:@""]) {
        [self createrAlertViewString:@"请输入意见!"];
        return;
    }
    NSString *unmber = _feedbckView.unmberTF.text;
    if ([unmber isEqualToString:@""]) {
        [self createrAlertViewString:@"请输入手机号!"];
        return;
    }
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    __weak FeedbckViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] help_opinionUserID:userInfo.user_id content:opinion phone:unmber returns:^(BOOL is) {
        if (is) {
            FeedbckViewController *strong_control = weak_control;
            if (strong_control) {
                [self createrAlertViewString:@"意见反馈成功"];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createrAlertViewString:(NSString *)string
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
