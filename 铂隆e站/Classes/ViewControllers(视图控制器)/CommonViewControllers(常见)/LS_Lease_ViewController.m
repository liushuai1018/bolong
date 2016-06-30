//
//  LS_Lease_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/27.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Lease_ViewController.h"
#import "LS_Lease_LeaseList_TableViewController.h"
#import "LS_Lease_Sell_TableViewController.h"
#import "LS_Lease_Inform_ViewController.h"

#define yellowColor [UIColor colorWithRed:0.99 green:0.9 blue:0.28 alpha:1.0]
@interface LS_Lease_ViewController ()
// 导航栏View
@property (weak, nonatomic) IBOutlet UIView *showView;

// 选中标识 1
@property (weak, nonatomic) IBOutlet UIView *mark1;
// 选中标识 2
@property (weak, nonatomic) IBOutlet UIView *mark2;
// 选中标识 3
@property (weak, nonatomic) IBOutlet UIView *mark3;

@property (strong, nonatomic) LS_Lease_LeaseList_TableViewController *leaseList;  // 出租信息
@property (strong, nonatomic) LS_Lease_Sell_TableViewController *sellList;        // 出售信息
@property (strong, nonatomic) LS_Lease_Inform_ViewController *housingInform; // 房屋信息

@end

@implementation LS_Lease_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViewControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initVC
- (void)initViewControl {
    _leaseList = [[LS_Lease_LeaseList_TableViewController alloc] init];
    _sellList = [[LS_Lease_Sell_TableViewController alloc] init];
    _housingInform = [[LS_Lease_Inform_ViewController alloc] init];
    
    [self addChildViewController:_leaseList];
    [self addChildViewController:_sellList];
    [self addChildViewController:_housingInform];
    
    _leaseList.tableView.frame = _showView.bounds;
    
    _housingInform.view.frame = _showView.bounds;
    
    [_showView addSubview:_leaseList.view];
}

#pragma mark - 租赁
- (IBAction)housingLease:(UIButton *)sender {
    _mark2.backgroundColor = [UIColor whiteColor];
    _mark3.backgroundColor = [UIColor whiteColor];
    _mark1.backgroundColor = yellowColor;
    
    [_housingInform.view removeFromSuperview];
    [_sellList.view removeFromSuperview];
    [_showView addSubview:_leaseList.view];
}

#pragma mark - 出售
- (IBAction)housingSell:(UIButton *)sender {
    _mark1.backgroundColor = [UIColor whiteColor];
    _mark3.backgroundColor = [UIColor whiteColor];
    _mark2.backgroundColor = yellowColor;
    
    [_leaseList.view removeFromSuperview];
    [_housingInform.view removeFromSuperview];
    _sellList.tableView.frame = _showView.bounds;
    [_showView addSubview:_sellList.view];
}

#pragma mark - 发布
- (IBAction)InformRelease:(UIButton *)sender {
    _mark1.backgroundColor = [UIColor whiteColor];
    _mark2.backgroundColor = [UIColor whiteColor];
    _mark3.backgroundColor = yellowColor;
    
    [_leaseList.view removeFromSuperview];
    [_sellList.view removeFromSuperview];
    _housingInform.bounds = _showView.bounds;
    [_showView addSubview:_housingInform.view];
}


@end
