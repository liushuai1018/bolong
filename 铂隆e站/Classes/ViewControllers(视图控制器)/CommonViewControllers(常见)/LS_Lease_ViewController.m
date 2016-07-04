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

// 菊花
@property (strong, nonatomic) UIActivityIndicatorView *activity;

// 租赁Data
@property (strong, nonatomic) NSArray *leaseDataAr;
// 出售
@property (strong, nonatomic) NSArray *sellDataAr;

@end

@implementation LS_Lease_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self activityIndicatorViews];
    [self initViewControl];
    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData {
    __weak LS_Lease_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] other_LeaseOrSellLiseInfostate:@"1" returns:^(NSArray *dataAr) {
        weak_control.leaseDataAr = dataAr;
        weak_control.leaseList.dataAr = dataAr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weak_control stopActivity]; // 停止菊花
        });
    }];
    
    [[NetWorkRequestManage sharInstance] other_LeaseOrSellLiseInfostate:@"2" returns:^(NSArray *dataAr) {
        weak_control.sellDataAr = dataAr;
        weak_control.sellList.dataAr = dataAr;
    }];
    
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
    [_showView addSubview:_leaseList.view];
    
}

#pragma mark - 租赁
- (IBAction)housingLease:(UIButton *)sender {
    _mark2.backgroundColor = [UIColor whiteColor];
    _mark3.backgroundColor = [UIColor whiteColor];
    _mark1.backgroundColor = yellowColor;
    
    [_housingInform.view removeFromSuperview];
    [_sellList.view removeFromSuperview];
    _leaseList.tableView.frame = _showView.bounds;
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

#pragma mark - 菊花
- (void)activityIndicatorViews {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:0.6];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = view.center;
    self.activity = activity;
    [view addSubview:self.activity];
    [self.activity startAnimating];
    
    view.center = self.view.superview.center;
    [self.view addSubview:view];
    
}

- (void)stopActivity {
    [_activity stopAnimating];
    [_activity.superview removeFromSuperview];
}

@end
