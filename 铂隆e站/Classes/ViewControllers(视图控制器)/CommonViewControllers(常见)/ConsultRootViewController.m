//
//  ConsultRootViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ConsultRootViewController.h"
#import "ConsultListTableViewController.h"
#import "OnlineConsultViewController.h"
#import "ReplyListTableViewController.h"

@interface ConsultRootViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentedControl;
// 咨询列表
@property (strong, nonatomic) ConsultListTableViewController *consultList;
// 在线咨询
@property (strong, nonatomic) OnlineConsultViewController *onlineConsult;
// 答复
@property (strong, nonatomic) ReplyListTableViewController *replyList;

// 用户信息
@property (strong, nonatomic) UserInformation *userInfo;

// 咨询列表数据
@property (copy, nonatomic) NSArray *consultListAr;
// 答复列表
@property (copy, nonatomic) NSArray *replyListAr;

@end

@implementation ConsultRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"咨询";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建子视图控制器
    [self createrViewControl];
    // 创建分段视图控制器
    [self createrSegmentedControl];
    
    // 获取用户信息
    self.userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    [self requestConsultData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取咨询数据
- (void)requestConsultData
{
    __weak ConsultRootViewController *root = self;
    [[NetWorkRequestManage sharInstance] consultListPage:@"1" returns:^(NSArray *array) {
        
        root.consultListAr = array;
        root.consultList.dataArray = root.consultListAr;
        [root.consultList.tableView  reloadData];
        
    }];
}

#pragma mark - 获取答复数据
- (void)requstReplyData
{
    __weak ConsultRootViewController *root = self;
    [[NetWorkRequestManage sharInstance] requestReplyListInfoUser_id:_userInfo.user_id returns:^(NSArray *array) {
        
        root.replyListAr = array;
        root.replyList.dataArry = root.replyListAr;
        [root.replyList.tableView reloadData];
        
    }];
}

#pragma mark - 创建咨询、在线、答复视图控制器
- (void)createrViewControl
{
    self.consultList = [[ConsultListTableViewController alloc] init];
    self.onlineConsult = [[OnlineConsultViewController alloc] init];
    self.replyList = [[ReplyListTableViewController alloc] init];
    
    // 将子视图控制器添加到视图容器
    [self addChildViewController:self.consultList];
    [self addChildViewController:self.onlineConsult];
    [self addChildViewController:self.replyList];
    
    // 获取用户信息
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    _consultList.userInfo = userInfo;
    _replyList.userInfo = userInfo;
    
    __weak ConsultRootViewController *root = self;
    // 执行完动作获取最新消息并刷新界面
    _consultList.block = ^(){
        [root requestConsultData];
    };
    
    _replyList.block = ^(){
        
        [root requstReplyData];
        
    };
    
    // 设置默认视图
    [self.view addSubview:_consultList.view];
}

#pragma mark - 创建分段视图控制器
- (void)createrSegmentedControl
{
    NSArray *array = @[@"最新咨询", @"在线咨询", @"答复"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 30);
    self.segmentedControl.tintColor = [UIColor blackColor];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
}

#pragma mark - segmentedControl Ation
- (void)segmentedControlAction:(UISegmentedControl *)sender
{
    
    switch (sender.selectedSegmentIndex) {
        case 0: {
            if (_consultList.view.superview == nil) {
                
                [_onlineConsult.view removeFromSuperview];
                [_replyList.view removeFromSuperview];
                
                [self.view addSubview:_consultList.view];
                [self.view sendSubviewToBack:_consultList.view];
                
                [self requestConsultData];
            }
            break;
        }
        case 1: {
            if (_onlineConsult.view.superview == nil) {
                
                [_consultList.view removeFromSuperview];
                [_replyList.view removeFromSuperview];
                
                [self.view addSubview:_onlineConsult.view];
                [self.view sendSubviewToBack:_onlineConsult.view];
            }
            break;
        }
        case 2: {
            if (_replyList.view.superview == nil) {
                
                [_consultList.view removeFromSuperview];
                [_onlineConsult.view removeFromSuperview];
                
                [self.view addSubview:_replyList.view];
                [self.view sendSubviewToBack:_replyList.view];
                
                [self requstReplyData];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
